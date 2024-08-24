########
## run / test sample for debugging; use
#    ruby script/read_debug.rb


require_relative 'boot'


File.delete( './debug.db' )   if File.exist?( './debug.db' )


SportDb.open( './debug.db' )


ENGLAND_PATH  = "#{OPENFOOTBALL_PATH}/england"
WORLDCUP_PATH = "#{OPENFOOTBALL_PATH}/worldcup"

## add for debugging
## SportDb::MatchReader.read( "#{ENGLAND_PATH}/2015-16/2-championship.txt" )

## SportDb::MatchReader.read( "#{WORLDCUP_PATH}/1930--uruguay/cup.txt" )
SportDb::MatchReader.read( "#{WORLDCUP_PATH}/1950--brazil/cup.txt" )


puts "table stats:"
SportDb.tables

puts 'bye'
