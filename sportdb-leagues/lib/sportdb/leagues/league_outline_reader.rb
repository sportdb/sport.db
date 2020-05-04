# encoding: utf-8


module SportDb

## shared "higher-level" outline reader
##  todo: add CountryOutlineReader - why? why not?

class LeagueOutlineReader

  def self.catalog() Import.catalog; end    ## shortcut convenience helper

  ## split into league + season
  ##  e.g. Österr. Bundesliga 2015/16   ## or 2015-16
  ##       World Cup 2018
  LEAGUE_SEASON_HEADING_RE =  %r{^
         (?<league>.+?)     ## non-greedy
            \s+
         (?<season>\d{4}
            (?:[\/-]\d{1,4})?     ## optional 2nd year in season
         )
            $}x


  def self.read( path, season: nil )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt, season: season )
  end

  def self.parse( txt, season: nil )
    ## todo/fix: change recs to secs (sections) !!!
    recs=[]
    OutlineReader.parse( txt ).each do |node|
      ## todo/fix: use proper node field names!!!!
      node_type = node[0]   ## e.g. :h1, :h2, :l, etc.
      node_text = node[1]

      if node[0] == :h1
        ## check for league (and stage) and season
        heading = node[1]
        values = split_league( heading )
        if m=values[0].match( LEAGUE_SEASON_HEADING_RE )
          puts "league >#{m[:league]}<, season >#{m[:season]}<"

           recs << { league: m[:league],
                     season: m[:season],
                     stage:  values[1],     ## note: defaults to nil if not present
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


    ## pass 2 - filter seasons if filter present
    if season
       filtered_recs = []
       filter = normalize_seasons( season )
       recs.each do |rec|
         if filter.include?( SeasonUtils.key( rec[:season] ))
           filtered_recs << rec
         else
           puts "  skipping season >#{rec[:season]}< NOT matched by filter"
         end
       end
       recs = filtered_recs
    end

    ## pass 3 - check & map; replace inline (string with data record)
    recs.each do |rec|
      league = find_league( rec[:league] )
      rec[:league] = league

      check_stage( rec[:stage] )   if rec[:stage]   ## note: only check for now (no remapping etc.)
    end

    recs
  end # method parse



  def self.normalize_seasons( season_or_seasons )     ## todo/check: add alias norm_seasons - why? why not?
      seasons = if season_or_seasons.is_a? String    ## wrap in array
                  [season_or_seasons]
                else  ## assume it's an array already
                   season_or_seasons
                end

      seasons.map { |season| SeasonUtils.key( season ) }
  end


  def self.split_league( str )   ## todo/check: rename to parse_league(s) - why? why not?
    ## split into league / stage / ... e.g.
    ##  => Österr. Bundesliga 2018/19, Regular Season
    ##  => Österr. Bundesliga 2018/19, Championship Round
    ##  etc.
    values = str.split( /[,<>‹›]/ )  ## note: allow , > < or › ‹ for now
    values = values.map { |value| value.strip }   ## remove all whitespaces
    values
  end

  def self.check_stage( name )
    known_stages = ['regular season',
                    'championship round',
                    'relegation round',
                    'play-offs'
                   ]

    if known_stages.include?( name.downcase )
       ## everything ok
    else
      puts "** !!! ERROR !!! no (league) stage match found for >#{name}<, add to (builtin) stages table; sorry"
      exit 1
    end
  end

  ## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  ### fix/todo: move find_league  to sportdb-league index use find_by! and find_by !!!!
  def self.find_league( name )
    league = nil
    m = catalog.leagues.match( name )
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
