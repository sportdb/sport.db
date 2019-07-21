# encoding: utf-8



def find_or_create_clubs!( team_names, league:, season: nil)
  ## note: season is for now optinal (and unused) - add/use in the future!!!

  ## todo/fix:
  ##   move (core) match clubs / team names to sportdb config!!!!

  recs = []

  ## add/find teams
  team_names.each do |team_name|

    ## todo/fix: use a single lookup for canonical and alt names - why? why not?
    ##   give coanonical name (always) preference - why? why not?

    ## check if match (built-in) canonical club name
    team_data = SportDb::Import.config.teams[ team_name ]
    if team_data.nil?    ## try alternative name
       ## todo/fix:  use team_mappings[] instead of fetch!!
       team_data_candidates = SportDb::Import.config.team_mappings.fetch( team_name )
       if team_data_candidates.nil?
         ## todo/check: exit if no match - why? why not?
         puts "!!! *** ERROR *** no match club found for >#{team_name}< - add to clubs setup"
         exit 1
       else
         if team_data_candidates.size > 1
           ## resolve conflict - find best match - how?
           if league.country
             ## try match / filter by country
             country_key = league.country.key  ## e.g. eng, de, at, br, etc.
             team_data_candidates_ii = team_data_candidates.select { |t| t.country.key == country_key }
             if team_data_candidates_ii.size == 1
               team_data = team_data_candidates_ii[0]
             else
               puts "!!! *** ERROR *** no clubs or too many matching clubs found for country >#{country_key}< and >#{team_name}< - cannot resolve conflict / find best match (automatic):"
               pp team_data_candidates_ii
               exit 1
             end
           else
             puts "!!! *** ERROR *** too many matching clubs found for >#{team_name}< - cannot resolve conflict / find best match (automatic)"
             exit 1
           end
         else
           team_data = team_data_candidates[0]
         end
       end
    end

    ## remove spaces too (e.g. Man City => mancity)
    ## remove dot (.) too e.g. St. Polten => stpolten
    ##        amp (& too e.g. Brighton & Hove Albion FC = brightonhove...
    ##        numbers  1. FC Kaiserslautern:
    ## team_key  = team_name.downcase.gsub( /[0-9&. ]/, '' )
    ## fix: reuse ascify from sportdb - why? why not?

    ## remove all non-ascii a-z chars
    team_key  = team_data.name.downcase.gsub( /[^a-z]/, '' )


    puts "add team: #{team_key}, #{team_data.name}:"
    if team_name != team_data.name
      puts "  using mapping from >#{team_name}< to => >#{team_data.name}<"
    end

    team = SportDb::Model::Team.find_by( title: team_data.name )
    if team.nil?
       team = SportDb::Model::Team.create!(
         key:        team_key,
         title:      team_data.name,
         country_id: SportDb::Importer::Country.find_or_create_builtin!( team_data.country.key ).id,
         club:       true,
         national:   false  ## check -is default anyway - use - why? why not?
         ## todo/fix: add city if present - why? why not?
       )
    end
    pp team
    recs << team
  end

  recs  # return activerecord team objects
end


def find_or_create_event( league:, season: )
  ## add event
  ##  key = 'en.2017/18'
  event = SportDb::Model::Event.find_by( league_id: league.id, season_id: season.id  )
  if event.nil?
    ## quick hack/change later !!
    ##  todo/fix: check season  - if is length 4 (single year) use 2017, 1, 1
    ##                               otherwise use 2017, 7, 1
    ##  start_at use year and 7,1 e.g. Date.new( 2017, 7, 1 )
    year = season.key[0..3].to_i  ## eg. 2017-18 => 2017
    event = SportDb::Model::Event.create!(
       league_id: league.id,
       season_id: season.id,
       start_at:  Date.new( year, 7, 1 )
     )
  end
  pp event
  event
end
