
require_relative 'helper'

database_path = './euro2020.db'

File.delete( database_path )   if File.exist?( database_path )


SportDb.open( database_path )

SportDb.read( '../../../openfootball/euro/2020--europe/euro.txt' ) 


puts "table stats:"
SportDb.tables

puts "bye"

