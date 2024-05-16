require_relative 'helper'



SportDb.open( './cl2018-19.db' )

SportDb.read( '../../../openfootball/europe-champions-league/2018-19/cl.txt' ) 
SportDb.read( '../../../openfootball/europe-champions-league/2018-19/cl_finals.txt' ) 


puts "table stats:"
SportDb.tables

puts "bye"
