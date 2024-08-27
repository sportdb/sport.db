
module SportDb
module Import
  class EventInfoReader

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

        season = Season.parse( season_col )
        league = League.find!( league_col )


        dates = []
        if dates_col.nil? || dates_col.empty?
           ## do nothing; no dates - keep dates array empty
        else
          ## squish spaces
          dates_col = dates_col.gsub( /[ ]{2,}/, ' ' )  ## squish/fold spaces

          puts "#{league.name} (#{league.key}) | #{season.key} | #{dates_col}"

          ### todo/check:  check what parts "Aug 15" return ???
          ###                       short form for "Aug 15 -" - works?

          ## todo/fix!!! - check EventInfo.include?
          ##    now allow dates with only start_date too!! (WITHOUT end_date)
          parts = dates_col.split( /[ ]*[–-][ ]*/ )
          if parts.size == 1
            pp parts
            ## dates << DateFormats.parse( parts[0], start: Date.new( season.start_year, 1, 1 ), lang: 'en' )
            dates  << SportDb::Parser.parse_date( parts[0], start: Date.new( season.start_year, 1, 1 ) )
            pp dates
          elsif parts.size == 2
            pp parts
            ## dates << DateFormats.parse( parts[0], start: Date.new( season.start_year, 1, 1 ), lang: 'en' )
            ## dates << DateFormats.parse( parts[1], start: Date.new( season.end_year ? season.end_year : season.start_year, 1, 1 ), lang: 'en' )
            dates  << SportDb::Parser.parse_date( parts[0], start: Date.new( season.start_year, 1, 1 ) )
            dates  << SportDb::Parser.parse_date( parts[1], start: Date.new( season.end_year ? season.end_year : season.start_year, 1, 1 ) )
            pp dates

            ## assert/check if period is less than 365 days for now
            ## diff = dates[1].to_date.jd - dates[0].to_date.jd
            diff = dates[1].jd - dates[0].jd
            puts "#{diff}d"
            if diff > 365
              puts "!! ERROR - date range / period assertion failed; expected diff < 365 days"
              exit 1
            end
          else
            puts "!! ERRROR - expected data range / period - one or two dates; got #{parts.size}:"
            pp dates_col
            pp parts
            exit 1
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

