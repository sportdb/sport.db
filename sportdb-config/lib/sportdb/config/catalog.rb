
module SportDb
  module Import


class Catalog
  def config() Import.config; end


  ## todo/check:  rename to country_mappings/index - why? why not?
  ##    or countries_by_code or countries_by_key
  def countries()      @countries      ||= build_country_index; end
  def national_teams() @national_teams ||= build_national_team_index; end
  def clubs()          @clubs          ||= build_club_index; end
  def teams()          @teams          ||= build_team_index; end
  def leagues()        @leagues        ||= build_league_index; end

  def events()         @events         ||= build_event_index; end
  def seasons()        @seasons        ||= build_season_index; end


  def build_team_index() TeamIndex.new;  end

  def build_country_index    ## todo/check: rename to setup_country_index or read_country_index - why? why not?
    CountryIndex.new( Fifa.countries )
  end

  def build_national_team_index
    ## auto-build national teams from Fifa.countries for now
    teams = []
    Fifa.countries.each do |country|
      team = NationalTeam.new( key:        country.code.downcase,  ## note: use country code (fifa)
                               name:       country.name,
                               code:       country.code,           ## note: use country code (fifa)
                               alt_names:  country.alt_names )
      team.country = country

      teams << team
    end

    NationalTeamIndex.new( teams )
  end

  def build_club_index
    ## unify team names; team (builtin/known/shared) name mappings
    ## cleanup team names - use local ("native") name with umlaut etc.
    ## todo/fix: add to teamreader
    ##              check that name and alt_names for a club are all unique (not duplicates)

    clubs = if config.clubs_dir   ## check if clubs_dir is defined / set (otherwise it's nil)
              ClubIndex.build( config.clubs_dir )
            else   ## no clubs_dir set - try using builtin from footballdb-clubs
              FootballDb::Import::build_club_index
            end

    if clubs.errors?
      puts ""
      puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      puts " #{clubs.errors.size} errors:"
      pp clubs.errors
      ## exit 1
    end

    clubs
  end # method build_club_index


  def build_league_index
    leagues = if config.leagues_dir   ## check if clubs_dir is defined / set (otherwise it's nil)
                LeagueIndex.build( config.leagues_dir )
              else   ## no leagues_dir set - try using builtin from footballdb-leagues
                FootballDb::Import.build_league_index
              end
  end


  def build_event_index
    if config.leagues_dir    ## (re)use leagues dir for now - add separate seasons_dir - why? why not?
      EventIndex.build( config.leagues_dir )
    else
      puts "!! WARN - no leagues_dir set; for now buit-in events in catalog - fix!!!!"
      EventIndex.new   ## return empty event index
    end
  end

  def build_season_index
    # note: for now always (re)use the events from the event (info) index
    SeasonIndex.new( events )
  end

end  # class Catalog

  end   # module Import
end   # module SportDb
