# encoding: utf-8


module SportDb

## shared "higher-level" outline reader
##  todo: add CountryOutlineReader - why? why not?

class LeagueOutlineReader

  def self.config() Import.config; end    ## shortcut convenience helper

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
        ## note: skip lines if no heading seen
        if recs.empty?
          puts "** !! WARN !! - skipping line (no heading) >#{line}<"
        else
          recs[-1][:lines] << line
        end
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
    m = config.leagues.match( name )
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
