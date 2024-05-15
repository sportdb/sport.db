require_relative 'helper'



SportDb.connect( adapter:  'sqlite3',
                 database: './euro2020.db' )
SportDb.create_all   

SportDb.read( '../../../openfootball/euro/2020--europe/euro.txt' ) 


puts "table stats:"
SportDb.tables

puts "bye"

