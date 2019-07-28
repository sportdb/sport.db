# encoding: utf-8



def find_or_create_clubs!( names, league:, season: nil)
  ## note: season is for now optinal (and unused) - add/use in the future!!!

  recs = []

  ## add/find teams
  names.each do |name|

    m = SportDb::Import.config.clubs.match( name )
    if m.nil?
       ## todo/check: exit if no match - why? why not?
       puts "!!! *** ERROR *** no matching club found for >#{name}< - add to clubs setup"
       exit 1
    else
      if m.size == 1
        club_data = m[0]
      else   ## assume more than one (>1) match
           ## resolve conflict - find best match - how?
           if league.country
             ## try match / filter by country
             country_key = league.country.key  ## e.g. eng, de, at, br, etc.
             m2 = m.select { |c| c.country.key == country_key }
             if m2.size == 1
               club_data = m2[0]
             else
               puts "!!! *** ERROR *** no clubs or too many matching clubs found for country >#{country_key}< and >#{name}< - cannot resolve conflict / find best match (automatic):"
               pp m
               exit 1
             end
           else
             puts "!!! *** ERROR *** too many matching clubs found for >#{name}< - cannot resolve conflict / find best match (automatic)"
             pp m
             exit 1
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
    club_key  = club_data.name.downcase.gsub( /[^a-z]/, '' )


    ## puts "add club: #{club_key}, #{club_data.name}, #{club_data.country.name} (#{club_data.country.key}):"
    puts "add club: #{club_key}, #{club_data.name}"
    pp club_data
    if name != club_data.name
      puts "  using mapping from >#{name}< to => >#{club_data.name}<"
    end

    club = SportDb::Model::Team.find_by( title: club_data.name )
    if club.nil?
       club = SportDb::Model::Team.create!(
         key:        club_key,
         title:      club_data.name,
         country_id: SportDb::Importer::Country.find_or_create_builtin!( club_data.country.key ).id,
         club:       true,
         national:   false  ## check -is default anyway - use - why? why not?
         ## todo/fix: add city if present - why? why not?
       )
    end
    pp club
    recs << club
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
