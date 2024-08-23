module Sports

class EventInfo
    ##  "high level" info (summary) about event
    ##    (like a "wikipedia infobox")
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

end  # module Sports
