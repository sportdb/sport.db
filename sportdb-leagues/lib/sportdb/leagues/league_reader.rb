# encoding: utf-8


module SportDb
module Import


class LeagueReader

##
## todo/check: make countries a method arg and NOT a global setting - why? why not?
##
def self.config=( value )  @config=value; end
def self.config     ## todo/check: rename to find_country( ) or something - why? why not?
  if @config
    @config
  else
    puts "** !! ERROR !! - country index required for league reader; sorry; use LeagueReader.config to set/configure"
    exit 1
  end
end



def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
  txt = File.open( path, 'r:utf-8' ).read
  parse( txt )
end

def self.parse( txt )
  recs = []
  last_rec = nil
  country  = nil    # last country
  intl     = false  # is international (league/tournament/cup/competition)

  OutlineReader.parse( txt ).each do |node|
    if [:h1,:h2,:h3,:h4,:h5,:h6].include?( node[0] )
      heading_level  = node[0][1].to_i
      heading        = node[1]

      puts "heading #{heading_level} >#{heading}<"

      if heading_level != 1
        puts "** !!! ERROR !!! unsupported heading level; expected heading 1 for now only; sorry"
        pp line
        exit 1
      else
        puts "heading (#{heading_level}) >#{heading}<"
        last_heading = heading
        ## map to country or international / int'l
        if heading =~ /international|int'l/i
          country = nil
          intl    = true
        else
          ## assume country in heading; allow all "formats" supported by parse e.g.
          ##   Österreich • Austria (at)
          ##   Österreich • Austria
          ##   Austria
          ##   Deutschland (de) • Germany
          country = config.countries.parse( heading )
          intl    = false

          ## check country code - MUST exist for now!!!!
          if country.nil?
            puts "!!! error [league reader] - unknown country >#{heading}< - sorry - add country to config to fix"
            exit 1
          end
        end
      end
    elsif node[0] == :l   ## regular (text) line
      line = node[1]

      if line.start_with?( '|' )
          ## assume continuation with line of alternative names
          ##  note: skip leading pipe
          values = line[1..-1].split( '|' )   # team names - allow/use pipe(|)
          ## strip and  squish (white)spaces
          #   e.g. New York FC      (2011-)  => New York FC (2011-)
          values = values.map { |value| value.strip.gsub( /[ \t]+/, ' ' ) }
          puts "alt_names: #{values.join( '|' )}"

          last_rec.alt_names += values
      else
        ## assume "regular" line
        ##  check if starts with id  (todo/check: use a more "strict"/better regex capture pattern!!!)
        if line =~ /^([a-z0-9][a-z0-9.]*)[ ]+(.+)$/
          league_key  = $1
          ## strip and  squish (white)spaces
          league_name = $2.gsub( /[ \t]+/, ' ' ).strip

          puts "key: >#{league_key}<, name: >#{league_name}<"


          alt_names_auto = []
          if country
            alt_names_auto << "#{country.key.upcase} #{league_key.upcase.gsub('.', ' ')}"
            alt_names_auto << "#{country.key.upcase}"   if league_key == '1'   ## add shortcut for top level 1 (just country key)
            if country.key.upcase != country.fifa
              alt_names_auto << "#{country.fifa} #{league_key.upcase.gsub('.', ' ')}"
              alt_names_auto << "#{country.fifa}"    if league_key == '1'   ## add shortcut for top level 1 (just country key)
            end
            alt_names_auto << "#{country.name} #{league_key}"  if league_key =~ /^[0-9]+$/   ## if all numeric e.g. add Austria 1 etc.
          else   ## assume int'l (no country) e.g. champions league, etc.
            ## only auto-add key (e.g. CL, EL, etc.)
            alt_names_auto << league_key.upcase.gsub('.', ' ')   ## note: no country code (prefix/leading) used
          end

          pp alt_names_auto

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
                            intl:           intl)
          recs << rec
          last_rec = rec
        else
          puts "** !!! ERROR !!! missing key for (canonical) league name"
          exit 1
        end
      end
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
