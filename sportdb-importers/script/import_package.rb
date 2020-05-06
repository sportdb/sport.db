##
#  use
#   $ ruby -I ./lib script/import_package.rb


require_relative 'boot'


SportDb.connect( adapter:  'sqlite3',
                 database: ':memory:' )
SportDb.create_all   ## build schema

puts "OK SportDb.create_all"
puts


FOOTBALLCSV_PATH  = '../../../footballcsv'

# path = "#{FOOTBALLCSV_PATH}/europe-champions-league"
# path = "#{FOOTBALLCSV_PATH}/england"
path = "#{FOOTBALLCSV_PATH}/austria"

pack = CsvPackage.new( path )
pack.import


puts "bye"
