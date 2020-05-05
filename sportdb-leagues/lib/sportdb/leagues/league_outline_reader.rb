# encoding: utf-8


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
      ## todo/fix: use proper node field names!!!!
      node_type = node[0]   ## e.g. :h1, :h2, :l, etc.
      node_text = node[1]

      if node_type == :h1
        ## check for league (and stage) and season
        heading = node_text
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
      elsif node_type == :l   ## regular (text) line
        line = node_text
        ## note: skip lines if no heading seen
        if secs.empty?
          puts "** !!! WARN - skipping line (no heading) >#{line}<"
        else
          secs[-1][:lines] << line
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
         if filter.include?( Import::Season.new( sec[:season] ).key )
           filtered_secs << sec
         else
           puts "  skipping season >#{sec[:season]}< NOT matched by filter"
         end
       end
       secs = filtered_secs
    end

    ## pass 3 - check & map; replace inline (string with data struct record)
    secs.each do |sec|
      sec[:season] = Import::Season.new( sec[:season ] )
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
      seasons = if season_or_seasons.is_a?( String )   ## wrap in array
                  [season_or_seasons]
                else  ## assume it's an array already
                   season_or_seasons
                end

      seasons.map { |season| Import::Season.new( season ).key }
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

  def check_stage( name )
    known_stages = ['regular season',
                    'championship round',
                    'relegation round',
                    'play-offs'
                   ]

    if known_stages.include?( name.downcase )
       ## everything ok
    else
      puts "** !!! ERROR - no (league) stage match found for >#{name}<, add to (builtin) stages table; sorry"
      exit 1
    end
  end

 end # class LeagueOutlineReader

end # module SportDb
