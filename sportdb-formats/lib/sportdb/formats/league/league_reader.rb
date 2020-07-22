# encoding: utf-8


module SportDb
module Import


class LeagueReader

  def catalog() Import.catalog; end


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
          country = catalog.countries.parse( heading )
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
          ## 1) strip (commerical) sponsor markers/tags e.g. $$ Liga $$BBV$$ MX
          ## 2) strip and  squish (white)spaces
          #   e.g. New York FC      (2011-)  => New York FC (2011-)
          values = values.map { |value| value.gsub( '$', '' )
                                             .gsub( /[ \t]+/, ' ' )
                                             .strip  }
          logger.debug "alt_names: #{values.join( '|' )}"

          last_rec.alt_names += values
      else
        ## assume "regular" line
        ##  check if starts with id  (todo/check: use a more "strict"/better regex capture pattern!!!)
        if line =~ /^([a-z0-9][a-z0-9.]*)[ ]+(.+)$/
          league_key  = $1
          ## 1) strip (commercial) sponsor markers/tags e.g $$
          ## 2) strip and squish (white)spaces
          league_name = $2.gsub( '$', '' )
                          .gsub( /[ \t]+/, ' ' )
                          .strip

          logger.debug "key: >#{league_key}<, name: >#{league_name}<"


          alt_names_auto = []
          if country
            alt_names_auto << "#{country.key.upcase} #{league_key.upcase.gsub('.', ' ')}"
            ## todo/check: add "hack" for cl (chile) and exclude?
            ##             add a list of (auto-)excluded country codes with conflicts? why? why not?
            ##                 cl - a) Chile  b) Champions League
            alt_names_auto << "#{country.key.upcase}"   if league_key == '1'   ## add shortcut for top level 1 (just country key)
            if country.key.upcase != country.code
              alt_names_auto << "#{country.code} #{league_key.upcase.gsub('.', ' ')}"
              alt_names_auto << "#{country.code}"    if league_key == '1'   ## add shortcut for top level 1 (just country key)
            end
            alt_names_auto << "#{country.name} #{league_key}"  if league_key =~ /^[0-9]+$/   ## if all numeric e.g. add Austria 1 etc.

            ## auto-add with country prepended
            ##   e.g. England Premier League, Austria Bundesliga etc.
            ##  todo/check: also add variants with country alt name if present!!!
            ##  todo/check: exclude cups or such from country + league name auto-add - why? why not?
            alt_names_auto << "#{country.name} #{league_name}"
          else   ## assume int'l (no country) e.g. champions league, etc.
            ## only auto-add key (e.g. CL, EL, etc.)
            alt_names_auto << league_key.upcase.gsub('.', ' ')   ## note: no country code (prefix/leading) used
          end

          ## pp alt_names_auto

          ## prepend country key/code if country present
          ##   todo/fix: only auto-prepend country if key/code start with a number (level) or incl. cup
          ##    why? lets you "overwrite" key if desired - use it - why? why not?
          if country
            league_key = "#{country.key}.#{league_key}"
          end

          rec = League.new( key:            league_key,
                            name:           league_name,
                            alt_names_auto: alt_names_auto,
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

end # class LeagueReader

end ## module Import
end ## module SportDb
