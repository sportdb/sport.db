require_relative 'helper'



SportDb.open( './euro2024.db' )
SportDb.read( '../../../openfootball/euro/2024--germany/euro.txt' ) 


puts "table stats:"
SportDb.tables

puts "bye"

