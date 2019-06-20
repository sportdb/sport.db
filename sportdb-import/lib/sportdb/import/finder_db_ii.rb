# encoding: utf-8



def find_teams( team_names, country: )
  recs = []

  ## add/find teams
  team_names.each do |team_name|
    ## remove spaces too (e.g. Man City => mancity)
    ## remove dot (.) too e.g. St. Polten => stpolten
    ##        amp (& too e.g. Brighton & Hove Albion FC = brightonhove...
    ##        numbers  1. FC Kaiserslautern:
    ## team_key  = team_name.downcase.gsub( /[0-9&. ]/, '' )
    ## fix: reuse ascify from sportdb

    ## remove all non-ascii a-z chars
    team_key  = team_name.downcase.gsub( /[^a-z]/, '' )


    puts "add team: #{team_key}, #{team_name}:"

    team = SportDb::Model::Team.find_by( title: team_name )
    if team.nil?
       team = SportDb::Model::Team.create!(
         key:   team_key,
         title: team_name,
         country_id: country.id
       )
    end
    pp team
    recs << team
  end

  recs  # return activerecord team objects
end


def find_event( league:, season: )
  ## add event
  ##  key = 'en.2017/18'
  event = SportDb::Model::Event.find_by( league_id: league.id, season_id: season.id  )
  if event.nil?
    ## quick hack/change later !!
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
