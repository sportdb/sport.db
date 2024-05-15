require_relative 'helper'



SportDb.connect( adapter:  'sqlite3',
                 database: './euro2024.db' )
SportDb.create_all   

SportDb.read( '../../../openfootball/euro/2024--germany/euro.txt' ) 


puts "table stats:"
SportDb.tables

puts "bye"

