######
# teams/clubs normalize helper
#   todo/check/fix:  move upstream for (re)use  - why? why not?


########
# helpers
#   normalize team names
#
#  todo/fix:  for reuse move to sportdb-catalogs
#                use normalize  - add to module/class ??
##
##  todo/fix: check league - if is national_team or clubs or intl etc.!!!!



def normalize( matches, league:, season: nil )
  league = Sports::League.find!( league )
  country = league.country

  ## todo/fix: cache name lookups - why? why not?
  matches.each do |match|
     team1 = Sports::Club.find_by!( name: match.team1,
                                    country: country )
     team2 = Sports::Club.find_by!( name: match.team2,
                                    country: country )

     if season
       team1_name = team1.name_by_season( season )
       team2_name = team2.name_by_season( season )
     else
       team1_name = team1.name
       team2_name = team2.name
     end

     puts "#{match.team1} => #{team1_name}"  if match.team1 != team1_name
     puts "#{match.team2} => #{team2_name}"  if match.team2 != team2_name

     match.update( team1: team1_name )
     match.update( team2: team2_name )
  end
  matches
end


## ----

 ########
  # helper
  #   normalize team names
  def normalize( matches, league: )
    matches = matches.sort do |l,r|
      ## first by date (older first)
      ## next by matchday (lowwer first)
      res =   l.date <=> r.date
      res =   l.round <=> r.round   if res == 0
      res
    end


    league = SportDb::Import.catalog.leagues.find!( league )
    country = league.country

    ## todo/fix: cache name lookups - why? why not?
    matches.each do |match|
       team1 = SportDb::Import.catalog.clubs.find_by!( name: match.team1,
                                                       country: country )
       team2 = SportDb::Import.catalog.clubs.find_by!( name: match.team2,
                                                       country: country )

       puts "#{match.team1} => #{team1.name}"  if match.team1 != team1.name
       puts "#{match.team2} => #{team2.name}"  if match.team2 != team2.name

       match.update( team1: team1.name )
       match.update( team2: team2.name )
    end
    matches
  end


