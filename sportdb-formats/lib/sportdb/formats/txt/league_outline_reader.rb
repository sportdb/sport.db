

module SportDb

## shared "higher-level" outline reader
##  todo: add CountryOutlineReader - why? why not?

class LeagueOutlineReader   ## todo/check - rename to LeaguePageReader / LeaguePageOutlineReader - why? why not?

  def self.read( path, season: nil )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ) {|f| f.read }
    parse( txt, season: season )
  end

  def self.parse( txt, season: nil )
    new( txt ).parse( season: season )
  end


  def initialize( txt )
    @txt = txt
  end

  def parse( season: nil )
    secs=[]     # sec(tion)s
    OutlineReader.parse( @txt ).each do |node|
      if node[0] == :h1
        ## check for league (and stage) and season
        heading = node[1]
        values = split_league( heading )
        if m=values[0].match( LEAGUE_SEASON_HEADING_RE )
          puts "league >#{m[:league]}<, season >#{m[:season]}<"

           secs << { league: m[:league],
                     season: m[:season],
                     stage:  values[1],     ## note: defaults to nil if not present
                     lines:  []
                   }
        else
          puts "** !!! ERROR - cannot match league and season in heading; season missing?"
          pp heading
          exit 1
        end
      elsif node[0] == :p   ## paragraph with (text) lines
        lines = node[1]
        ## note: skip lines if no heading seen
        if secs.empty?
          puts "** !!! WARN - skipping lines (no heading):"
          pp lines
        else
          ## todo/check: unroll paragraphs into lines or pass along paragraphs - why? why not?
          secs[-1][:lines] += lines
        end
      else
        puts "** !!! ERROR - unknown line type; for now only heading 1 for leagues supported; sorry:"
        pp node
        exit 1
      end
    end


    ## pass 2 - filter seasons if filter present
    if season
       filtered_secs = []
       filter = norm_seasons( season )
       secs.each do |sec|
         if filter.include?( Season.parse( sec[:season] ).key )
           filtered_secs << sec
         else
           puts "  skipping season >#{sec[:season]}< NOT matched by filter"
         end
       end
       secs = filtered_secs
    end

    ## pass 3 - check & map; replace inline (string with data struct record)
    secs.each do |sec|
      sec[:season] = Season.parse( sec[:season ] )
      sec[:league] = catalog.leagues.find!( sec[:league] )

      check_stage( sec[:stage] )   if sec[:stage]   ## note: only check for now (no remapping etc.)
    end

    secs
  end # method parse



  def catalog() Import.catalog; end    ## shortcut convenience helper

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


  def norm_seasons( season_or_seasons )     ## todo/check: add alias norm_seasons - why? why not?

      seasons = if season_or_seasons.is_a?( Array )  # is it an array already
                  season_or_seasons
                elsif season_or_seasons.is_a?( Range )  # e.g. Season(1999)..Season(2001) or such
                  season_or_seasons.to_a
                else  ## assume - single entry - wrap in array
                  [season_or_seasons]
                end

      seasons.map { |season| Season( season ).key }
  end


  def split_league( str )   ## todo/check: rename to parse_league(s) - why? why not?
    ## split into league / stage / ... e.g.
    ##  => Österr. Bundesliga 2018/19, Regular Season
    ##  => Österr. Bundesliga 2018/19, Championship Round
    ##  etc.
    values = str.split( /[,<>‹›]/ )  ## note: allow , > < or › ‹ for now
    values = values.map { |value| value.strip }   ## remove all whitespaces
    values
  end


  # note: normalize names e.g. downcase and remove all non a-z chars (e.g. space, dash, etc.)
  KNOWN_STAGES = [
    'Regular Season',
    'Regular Stage',
    'Championship Round',
    'Championship Playoff',  # or Championship play-off
    'Relegation Round',
    'Relegation Playoff',
    'Play-offs',
    'Playoff Stage',
    'Grunddurchgang',
    'Finaldurchgang - Qualifikationsgruppe',
    'Finaldurchgang - Qualifikation',
    'Finaldurchgang - Meistergruppe',
    'Finaldurchgang - Meister',
    'EL Play-off',
    'Europa League Play-off',
    'Europa-League-Play-offs',
    'Europa League Finals',
    'Playoffs - Championship',
    'Playoffs - Europa League',
    'Playoffs - Europa League - Finals',
    'Playoffs - Relegation',
    'Playoffs - Challenger',
    'Finals',
    'Match 6th Place',  # e.g. Super League Greece 2012/13

    'Apertura',
    'Apertura - Liguilla',
    'Clausura',
    'Clausura - Liguilla',

  ].map {|name| name.downcase.gsub( /[^a-z]/, '' ) }


  def check_stage( name )
    # note: normalize names e.g. downcase and remove all non a-z chars (e.g. space, dash, etc.)
    if KNOWN_STAGES.include?( name.downcase.gsub( /[^a-z]/, '' ) )
       ## everything ok
    else
      puts "** !!! ERROR - no (league) stage match found for >#{name}<, add to (builtin) stages table; sorry"
      exit 1
    end
  end

 end # class LeagueOutlineReader

end # module SportDb
