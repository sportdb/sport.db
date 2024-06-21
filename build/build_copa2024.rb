require_relative 'helper'


database_path = './copa2024.db'

File.delete( database_path )   if File.exist?( database_path )


SportDb.open( database_path )
SportDb.read( '../../../openfootball/copa-america/2024--usa/copa.txt' ) 


puts "table stats:"
SportDb.tables

puts "bye"

