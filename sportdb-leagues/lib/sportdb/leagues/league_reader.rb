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

  txt.each_line do |line|
    line = line.strip

    next  if line.empty?
    break if line == '__END__'

    next if line.start_with?( '#' )   ## skip comments too

    ## strip inline (until end-of-line) comments too
    ##  e.g  ţ  t  ## U+0163
    ##   =>  ţ  t
    line = line.sub( /#.*/, '' ).strip


    next if line =~ /^={1,}$/          ## skip "decorative" only heading e.g. ========

    ## note: like in wikimedia markup (and markdown) all optional trailing ==== too
    ##  todo/check:  allow ===  Text  =-=-=-=-=-=   too - why? why not?
    if line =~ /^(={1,})       ## leading ======
                ([^=]+?)      ##  text   (note: for now no "inline" = allowed)
                =*            ## (optional) trailing ====
                $/x
      heading_marker = $1
      heading_level  = $1.length   ## count number of = for heading level
      heading        = $2.strip

      puts "heading #{heading_level} >#{heading}<"

      if heading_level != 1
        puts "** !! ERROR !! unsupported headin level; expected heading 1 for now only; sorry"
        pp line
        exit 1
      else
        puts "heading (#{heading_level}) >#{heading}<"
        last_heading = heading
        ## map to country or international / int'l
        if heading =~ /international|int'l/i
          country = nil
          intl    = true
        elsif heading =~ /\(([a-z]{2,3})\)/i
          country_code = $1
          intl         = false

          ## check country code - MUST exist for now!!!!
          country = config.countries[ country_code ]
          if country.nil?
            puts "!!! error [league reader] - unknown country with code >#{country_code}< - sorry - add country to config to fix"
            exit 1
          end
        else
          puts "** !! ERROR !! no match found for heading (expected country code or internationa):"
          pp line
          exit 1
        end
      end
    elsif line.start_with?( '|' )
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

        ## prepend country key/code if country present
        ##   todo/fix: only auto-prepend country if key/code start with a number (level) or incl. cup
        ##    why? lets you "overwrite" key if desired - use it - why? why not?
        league_key = "#{country.key}.#{league_key}"   if country

        rec = League.new( key:     league_key,
                          name:    league_name,
                          country: country,
                          intl:    intl)
        recs << rec
        last_rec = rec
      else
        puts "** !! ERROR !! missing key for (canonical) league name"
        exit 1
      end
    end
    ## pp line
  end
  recs
end # method parse

end # class LeagueReader

end ## module Import
end ## module SportDb
