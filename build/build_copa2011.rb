require_relative 'helper'

SportDb.open( './copa2011.db' )
SportDb.read( '../../../openfootball/copa-america/2011--argentina/copa.txt' ) 


puts "table stats:"
SportDb.tables

puts "bye"

