
module SportDb
module Import


class LeagueReader


def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
  txt = File.open( path, 'r:utf-8' ) { |f| f.read }
  parse( txt )
end

def self.parse( txt )
  new( txt ).parse
end



include Logging

def initialize( txt )
  @txt = txt
end

def parse
  recs = []
  last_rec = nil

  country  = nil    # last country
  intl     = false  # is international (league/tournament/cup/competition)
  clubs    = true   # or clubs|national teams

  OutlineReader.parse( @txt ).each do |node|
    if [:h1,:h2,:h3,:h4,:h5,:h6].include?( node[0] )
      heading_level  = node[0][1].to_i
      heading        = node[1]

      logger.debug "heading #{heading_level} >#{heading}<"

      if heading_level != 1
        puts "** !!! ERROR !!! unsupported heading level; expected heading 1 for now only; sorry"
        pp line
        exit 1
      else
        logger.debug "heading (#{heading_level}) >#{heading}<"
        last_heading = heading
        ## map to country or international / int'l or national teams
        if heading =~ /national team/i   ## national team tournament
          country = nil
          intl    = true
          clubs   = false
        elsif heading =~ /international|int'l/i  ## int'l club tournament
          country = nil
          intl    = true
          clubs   = true
        else
          ## assume country in heading; allow all "formats" supported by parse e.g.
          ##   Österreich • Austria (at)
          ##   Österreich • Austria
          ##   Austria
          ##   Deutschland (de) • Germany
          country = Country.parse_heading( heading )
          intl    = false
          clubs   = true

          ## check country code - MUST exist for now!!!!
          if country.nil?
            puts "!!! error [league reader] - unknown country >#{heading}< - sorry - add country to config to fix"
            exit 1
          end
        end
      end
    elsif node[0] == :p   ## paragraph with (text) lines
      lines = node[1]
      lines.each do |line|

      if line.start_with?( '|' )
          ## assume continuation with line of alternative names
          ##  note: skip leading pipe
          values = line[1..-1].split( '|' )   # team names - allow/use pipe(|)
          values = values.map {|value| _norm(value) }  ## squish/strip etc.

          logger.debug "alt_names: #{values.join( '|' )}"

          last_rec.alt_names += values
      else
        ## assume "regular" line
        ##  check if starts with id  (todo/check: use a more "strict"/better regex capture pattern!!!)
        if line =~ /^([a-z0-9][a-z0-9.]*)[ ]+(.+)$/
          league_key  = $1
          ## 1) strip (commercial) sponsor markers/tags e.g $$
          ## 2) strip and squish (white)spaces
          league_name = _norm( $2 )

          logger.debug "key: >#{league_key}<, name: >#{league_name}<"


          ## prepend country key/code if country present
          ##   todo/fix: only auto-prepend country if key/code start with a number (level) or incl. cup
          ##    why? lets you "overwrite" key if desired - use it - why? why not?
          if country
            league_key = "#{country.key}.#{league_key}"
          end

          rec = League.new( key:            league_key,
                            name:           league_name,
                            country:        country,
                            intl:           intl,
                            clubs:          clubs)
          recs << rec
          last_rec = rec
        else
          puts "** !!! ERROR !!! missing key for (canonical) league name"
          exit 1
        end
      end
      end  # each line
    else
      puts "** !!! ERROR !!! [league reader] - unknown line type:"
      pp node
      exit 1
    end
    ## pp line
  end
  recs
end # method parse



#######################
###  helpers

## norm(alize) helper  - squish (spaces)
##                      and remove dollars ($$$)
##                      and remove leading and trailing spaces
def _norm( str )
  ## only extra clean-up of dollars for now ($$$)
  _squish( str.gsub( '$', '' ) )
end

def _squish( str )
  str.gsub( /[ \t\u00a0]+/, ' ' ).strip
end


end # class LeagueReader

end ## module Import
end ## module SportDb
