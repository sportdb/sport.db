##
#  use
#   $ ruby -I ./lib script/import_package.rb


require_relative 'boot'


LEAGUES = SportDb::Import.catalog.leagues


FOOTBALLCSV_PATH  = '../../../footballcsv'

# path = "#{FOOTBALLCSV_PATH}/europe-champions-league"
# path = "#{FOOTBALLCSV_PATH}/england"
path = "#{FOOTBALLCSV_PATH}/austria"

pack = CsvPackage.new( path )
pack.import


puts "bye"
