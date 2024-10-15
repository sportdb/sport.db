
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


## note - allow / too e.g. rel1/2 or rel.1/2 - why? why not?
KEY_RE =  %r{^
                [a-z0-9][a-z0-9/.]*
              $}x

SEASON_RE =  %r{^  (?<start_season> \d{4} (?: / \d{1,4})?
                               )?
                        -
                    (?<end_season> \d{4}  (?: / \d{1,4})?
                              )?
               $}x



def parse
  recs = []
  last_rec = nil

  leagues  = {}   ## lookup leagues for adding periods
                  ##  note - gets reset for every section!!!

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

        leagues = {}  ## note - reset leagues lookup cache
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


        ## squish spaces for =>
        ##   allow more than one space for rename!!!
        ##   e.g.
        ##    Division 1 =>  Championship
        ##
        ##  maybe warn about extra space - why? why not?
        line = line.gsub( /[ ]*
                             =>
                            [ ]*
                             /x, ' => ')


        ##  split by double (or more) spaces or by comma
        values = line.split( / [ ]*,[ ]*
                                 |
                               [ ]{2,}
                             /x )

        ## note - for now key is required (maybe make optional in future
        ##                   and auto-gen)
        if !KEY_RE.match(values[0])
          puts "** !!! ERROR !!! missing (or invalid) key for (canonical) league name; got >#{values[0]}<"
          exit 1
        end
        key = values.shift


        ## check for (start/end) season qualifier
        start_season = nil
        end_season   = nil

        if m=SEASON_RE.match(values[0])
           values.shift  ## eat-up value
            start_season = Season.parse(m[:start_season])  if m[:start_season]
            end_season   = Season.parse(m[:end_season])    if m[:end_season]
        end

        ## note - names might be old => new !!!
        ##   Division 3 =>  League Two
        value = values.shift
        ## note - reverse to make canonical name always first
        names =   value.split( /[ ]*
                                   =>
                                  [ ]*/x, 2).reverse

        ## 1) strip (commercial) sponsor markers/tags e.g $$
        ## 2) strip and squish (white)spaces
        names = names.map {|name| _norm( name )}


        auto_key  = unaccent( names[0] ).downcase.gsub( /[^0-9a-z]/, '' )


        ## assume last value is slug
        slug = values.shift
        if slug.nil?
          slug = auto_key
        end


          ## prepend country key/code if country present
          ##   todo/fix: only auto-prepend country if key/code start with a number (level) or incl. cup
          ##    why? lets you "overwrite" key if desired - use it - why? why not?
          if country
            auto_key  = "#{country.key}_#{auto_key}"
            key       = "#{country.key}.#{key}"

            #### check for adjective (use first in list/array)
            ##     fallback to country name for qualifier prefix
            prefix = (COUNTRY_ADJ[ country.key ] || [country.name])[0]

            qname     = "#{prefix} #{names[0]}"
          else
            qname = names[0]
          end

          logger.debug "auto_key: #{auto_key}, key: #{key}, names: #{names.inspect}, qname: #{qname}," +
                       " slug: #{slug}," +
                       " start_season: #{start_season}, end_season: #{end_season}"


          period = Sports::LeaguePeriod.new( key: key,
                                     name: names[0],
                                     qname: qname,
                                     slug: slug,
                                     prev_name: names[1],
                                     start_season: start_season,
                                     end_season: end_season
                                   )

          rec = nil
          if leagues.has_key?( names[0] )
                   rec = leagues[ names[0] ]
                   ## fix - add name only if not yet included!!!!!
                   rec.alt_names <<  names[0]    if !rec.alt_names.include?( names[0] )
          else
                   ## assume new entry - auto-create ("parent") record for periods
                   rec =  League.new( key: auto_key,
                                       name:           names[0],
                                       country:        country,
                                       intl:           intl,
                                       clubs:          clubs)
                   leagues[ names[0] ] = rec
                   recs << rec
          end

          ## if rename - possibly add name for lookup (for longer rename chain)
          ##    plus add canonical name to alt names too!!!
          if names[1]
            leagues[ names[1] ] = rec
          end

          rec.periods << period
          pp rec

          last_rec = rec
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
