require_relative 'helper'



SportDb.open( './cl2017-18.db' )

SportDb.read( '../../../openfootball/europe-champions-league/2017-18/cl.txt' ) 
SportDb.read( '../../../openfootball/europe-champions-league/2017-18/cl_finals.txt' ) 


puts "table stats:"
SportDb.tables

puts "bye"
