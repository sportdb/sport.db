########
## run / test sample for debugging; use
#    ruby script/read_debug.rb


require_relative 'boot'


File.delete( './debug.db' )   if File.exist?( './debug.db' )


SportDb.open( './debug.db' )


AUSTRIA_PATH       = "#{OPENFOOTBALL_PATH}/austria"
ENGLAND_PATH       = "#{OPENFOOTBALL_PATH}/england"
ITALY_PATH         = "#{OPENFOOTBALL_PATH}/italy"
ARGENTINA_PATH     = "#{OPENFOOTBALL_PATH}/south-america/argentina"
BRAZIL_PATH        = "#{OPENFOOTBALL_PATH}/south-america/brazil"

WORLDCUP_PATH      = "#{OPENFOOTBALL_PATH}/worldcup"

## add for debugging
## SportDb::MatchReader.read( "#{ENGLAND_PATH}/2015-16/2-championship.txt" )

## SportDb::MatchReader.read( "#{WORLDCUP_PATH}/1930--uruguay/cup.txt" )
## SportDb::MatchReader.read( "#{WORLDCUP_PATH}/1950--brazil/cup.txt" )
## SportDb::MatchReader.read( "#{ENGLAND_PATH}/2024-25/1-premierleague.txt" )

## samples with auto-create clubs
# SportDb::MatchReader.read( "#{AUSTRIA_PATH}/2022-23/cup.txt" )
# SportDb::MatchReader.read( "#{ENGLAND_PATH}/2008-09/4-league2.txt" )
# SportDb::MatchReader.read( "#{ITALY_PATH}/2020-21/cup.txt" )
# SportDb::MatchReader.read( "#{ARGENTINA_PATH}/2024/1-primeradivision.txt" )
SportDb::MatchReader.read( "#{BRAZIL_PATH}/2024/1-serieb.txt" )


puts "table stats:"
SportDb.tables

puts 'bye'
