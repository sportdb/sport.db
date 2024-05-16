require_relative 'helper'

SportDb.open( './copa2024.db' )
SportDb.read( '../../../openfootball/copa-america/2024--usa/copa.txt' ) 


puts "table stats:"
SportDb.tables

puts "bye"

