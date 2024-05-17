
require_relative 'helper'

database_path = './euro.db'

File.delete( database_path )   if File.exist?( database_path )


SportDb.open( database_path )

SportDb.read( '../../../openfootball/euro/2020--europe/euro.txt' ) 
SportDb.read( '../../../openfootball/euro/2024--germany/euro.txt' ) 


puts "table stats:"
SportDb.tables

puts "bye"

