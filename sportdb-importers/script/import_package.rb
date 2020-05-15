##
#  to run use:
#    ruby -I ./lib script/import_package.rb


require_relative 'boot'


SportDb.connect( adapter:  'sqlite3',
                 database: ':memory:' )
SportDb.create_all   ## build schema

puts "OK SportDb.create_all"
puts


FOOTBALLCSV_PATH  = '../../../footballcsv'

CHAMPS_PATH  = "#{FOOTBALLCSV_PATH}/europe-champions-league"
ENGLAND_PATH = "#{FOOTBALLCSV_PATH}/england"
AUSTRIA_PATH = "#{FOOTBALLCSV_PATH}/austria"

# path = AUSTRIA_PATH
# SportDb.read_csv( path )

SportDb.read_csv( "#{AUSTRIA_PATH}/2012-13/at.1.csv" )
SportDb.read_csv( "#{AUSTRIA_PATH}/2013-14/at.1.csv" )

puts "bye"
