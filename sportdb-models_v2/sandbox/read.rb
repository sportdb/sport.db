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


path = "/sports/openfootball/austria/2023-24/1-bundesliga.txt"
SportDbV2::MatchReader.read( path )
    
path = "/sports/openfootball/austria/2023-24/cup.txt"
SportDbV2::MatchReader.read( path )

path = "/sports/openfootball/euro/2024--germany/euro.txt"
SportDbV2::MatchReader.read( path )


puts "---"
pp SportDbV2::Model::Team.all
puts "---"
pp SportDbV2::Model::Event.all
puts "---"


SportDbV2.tables



puts "bye"