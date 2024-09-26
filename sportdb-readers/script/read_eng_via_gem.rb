##
#  use
#   $ ruby script/read_eng.rb



require 'sportdb/readers'

File.delete( './eng.db' )   if File.exist?( './eng.db' )


SportDb.open( './eng.db' )

# SportDb.connect( adapter:  'sqlite3',
#                  database: './eng.db' )
# SportDb.create_all   ## build schema

## turn on logging to console
## ActiveRecord::Base.logger = Logger.new(STDOUT)

OPENFOOTBALL_PATH = '../../../openfootball'


path = "#{OPENFOOTBALL_PATH}/england"

pack = SportDb::Package.new( path )
pack.read_match

## pack.read
## pack.read( season: '2012/13' )


puts "table stats:"
SportDb.tables


puts 'bye'
