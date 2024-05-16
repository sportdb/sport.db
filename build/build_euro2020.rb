require_relative 'helper'



SportDb.open( './euro2020.db' )

SportDb.read( '../../../openfootball/euro/2020--europe/euro.txt' ) 


puts "table stats:"
SportDb.tables

puts "bye"

