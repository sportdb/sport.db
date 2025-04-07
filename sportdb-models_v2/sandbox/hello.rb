###
#  to run use
#    $ ruby sandbox/hello.rb


$LOAD_PATH.unshift( './lib' )
## our own code
require 'sportdb/models_v2'



#################################
# setup db -> schema / tables

SportDbV2.open_mem  # was setup_in_memory_db

## test helpers here
## SportDb.delete!
SportDbV2.tables


include SportDbV2::Models

## add teams
rapid      = Team.create!( name: "Rapid" )
austria    = Team.create!( name: "Austria" )

bundesliga = League.create!( name: "Bundesliga" ) 

at1  = Event.create!( league: bundesliga, season: '2024/25',
                      name: "Austria | Bundesliga" )
pp at1

m1 = Match.create!( league: bundesliga,
                    season: '2024/25', 
                    team1: rapid, team2: austria )
pp m1


pp at1.matches
pp m1.team1_name
pp m1.team2_name
pp m1.event

puts "---"
SportDbV2.tables



puts "bye"