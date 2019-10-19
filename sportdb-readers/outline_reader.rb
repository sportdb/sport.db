# encoding: UTF-8

module SportDb

class OutlineReader

  def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt )
  end

  def self.parse( txt )
    outline=[]   ## outline structure

    txt.each_line do |line|
        line = line.strip

        next if line.empty?    ## todo/fix: keep blank line nodes - why? why not?
        break if line == '__END__'

        next if line.start_with?( '#' )   ## skip comments too
        ## strip inline (until end-of-line) comments too
        ##  e.g Eupen        => KAS Eupen,    ## [de]
        ##   => Eupen        => KAS Eupen,
        line = line.sub( /#.*/, '' ).strip
        pp line

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
           outline << [:"h#{heading_level}", heading]
        else
           ## assume it's a (plain/regular) text line
           outline << [:l, line]
        end
    end
    outline
  end # method read
end # class OutlineReader



## shared "higher-level" outline reader
##  todo: add CountryOutlineReader - why? why not?
class LeagueOutlineReader
  ## split into league + season
  ##  e.g. Österr. Bundesliga 2015/16   ## or 2015-16
  ##       World Cup 2018
  LEAGUE_SEASON_HEADING_REGEX =  /^
         (?<league>.+?)     ## non-greedy
            \s+
         (?<season>\d{4}
            (?:[\/-]\d{2})?     ## optional 2nd year in season
         )
            $/x

  def self.parse( txt )
    recs=[]
    OutlineReader.parse( txt ).each do |node|
      if node[0] == :h1
        ## check for league and season
        heading = node[1]
        if m=heading.match( LEAGUE_SEASON_HEADING_REGEX )
          puts "league >#{m[:league]}<, season >#{m[:season]}<"

           recs << { league: m[:league],
                     season: m[:season],
                     lines:  []
                   }
        else
          puts "** !!! ERROR !!! - CANNOT match league and season in heading; season missing?"
          pp heading
          exit 1
        end
      elsif node[0] == :l   ## regular (text) line
        line = node[1]
        recs[-1][:lines] << line
      else
        puts "** !!! ERROR !!! unknown line type; for now only heading 1 for leagues supported; sorry:"
        pp node
        exit 1
      end
    end

    ## pass 2 - check & map; replace inline (string with data record)
    recs.each do |rec|
      league = find_league( rec[:league] )
      rec[:league] = league
    end

    recs
  end # method parse


  def self.find_league( name )
    league = nil
    m = LEAGUES.match( name )
    # pp m

    if m.nil?
      puts "** !!! ERROR !!! no league match found for >#{name}<, add to leagues table; sorry"
      exit 1
    elsif m.size > 1
      puts "** !!! ERROR !!! ambigious league name; too many leagues (#{m.size}) found:"
      pp m
      exit 1
    else
      league = m[0]
    end

    league
  end
end # class LeagueOutlineReader

end # module SportDb
