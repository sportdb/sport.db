
module SportDb
module Import


class EventInfo
    ##  "high level" info (summary) about event  (like a "wikipedia infobox")
    ##    use for checking dataset imports; lets you check e.g.
    ##    - dates within range
    ##    - number of teams e.g. 20
    ##    - matches played e.g. 380
    ##    - goals scored e.g. 937
    ##    etc.

    attr_reader :league,
                :season,
                :teams,
                :matches,
                :goals,
                :start_date,
                :end_date

    def initialize( league:, season:,
                    start_date: nil, end_date: nil,
                    teams:   nil,
                    matches: nil,
                    goals:   nil )

      @league      = league
      @season      = season

      @start_date  = start_date
      @end_date    = end_date

      @teams       = teams    ## todo/check: rename/use teams_count ??
      @matches     = matches  ## todo/check: rename/use match_count ??
      @goals       = goals
    end

    def include?( date )
       ## todo/fix: add options e.g.
       ##  - add delta/off_by_one or such?
       ##  - add strict (for) only return true if date range (really) defined (no generic auto-rules)

      ### note: for now allow off by one error (via timezone/local time errors)
      ##    todo/fix: issue warning if off by one!!!!
      if @start_date && @end_date
        date >= (@start_date-1) &&
        date <= (@end_date+1)
      else
        if @season.year?
           # assume generic rule
           ## same year e.g. Jan 1 - Dec 31; always true for now
           date.year == @season.start_year
        else
           # assume generic rule
           ##  July 1 - June 30 (Y+1)
           ##  - todo/check -start for some countries/leagues in June 1 or August 1 ????
           date >= Date.new( @season.start_year, 7, 1 ) &&
           date <= Date.new( @season.end_year, 6, 30 )
        end
      end
    end  # method include?
    alias_method :between?, :include?
  end # class EventInfo


  class EventInfoReader
    def catalog() Import.catalog; end


    def self.read( path )
      txt = File.open( path, 'r:utf-8') {|f| f.read }
      new( txt ).parse
    end

    def self.parse( txt )
      new( txt ).parse
    end

    def initialize( txt )
      @txt = txt
    end

    def parse
      recs = []

      parse_csv( @txt ).each do |row|
        league_col = row['League']
        season_col = row['Season'] || row['Year']
        dates_col  = row['Dates']

        season = Import::Season.new( season_col )
        league = catalog.leagues.find!( league_col )


        dates = []
        if dates_col.nil? || dates_col.empty?
           ## do nothing; no dates - keep dates array empty
        else
          ## squish spaces
          dates_col = dates_col.gsub( /[ ]{2,}/, ' ' )  ## squish/fold spaces

          puts "#{league.name} (#{league.key}) | #{season.key} | #{dates_col}"

          parts = dates_col.split( /[ ]*[–-][ ]*/ )
          if parts.size != 2
            puts "!! ERRROR - expected data range / period - two dates; got #{parts.size}:"
            pp dates_col
            pp parts
            exit 1
          else
            pp parts
            dates << DateFormats.parse( parts[0], start: Date.new( season.start_year, 1, 1 ), lang: 'en' )
            dates << DateFormats.parse( parts[1], start: Date.new( season.end_year ? season.end_year : season.start_year, 1, 1 ), lang: 'en' )
            pp dates

            ## assert/check if period is less than 365 days for now
            diff = dates[1].to_date.jd - dates[0].to_date.jd
            puts "#{diff}d"
            if diff > 365
              puts "!! ERROR - date range / period assertion failed; expected diff < 365 days"
              exit 1
            end
          end
        end


        teams_col    = row['Clubs'] || row['Teams']
        goals_col    = row['Goals']

        ## note: remove (and allow) all non-digits e.g. 370 goals, 20 clubs, etc.
        teams_col    = teams_col.gsub( /[^0-9]/, '' )    if teams_col
        goals_col    = goals_col.gsub( /[^0-9]/, '' )    if goals_col

        teams  =   (teams_col.nil? || teams_col.empty?) ? nil : teams_col.to_i
        goals  =   (goals_col.nil? || goals_col.empty?) ? nil : goals_col.to_i

        matches_col  = row['Matches']
        ## note: support additions in matches (played) e.g.
        #   132 + 63 Play-off-Spiele
        matches_col   = matches_col.gsub( /[^0-9+]/, '' )  if matches_col

        matches =  if matches_col.nil? || matches_col.empty?
                     nil
                   else
                     if matches_col.index( '+' )  ### check for calculations
                        ## note: for now only supports additions
                        matches_col.split( '+' ).reduce( 0 ) do |sum,str|
                          sum + str.to_i
                        end
                     else            ## assume single (integer) number
                        matches_col.to_i
                     end
                  end

        rec = EventInfo.new( league:     league,
                             season:     season,
                             start_date: dates[0],
                             end_date:   dates[1],
                             teams:      teams,
                             matches:    matches,
                             goals:      goals
                           )
        recs << rec
      end  # each row
      recs
    end  # method parse
  end  # class EventInfoReader


end ## module Import
end ## module SportDb

