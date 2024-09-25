##
#  use
#   $ ruby script/read_at.rb


require_relative 'boot'

File.delete( './austria.db' )   if File.exist?( './austria.db' )


SportDb.open( './austria.db' )

# SportDb.connect( adapter:  'sqlite3',
#                  database: './eng.db' )
# SportDb.create_all   ## build schema

## turn on logging to console
## ActiveRecord::Base.logger = Logger.new(STDOUT)


path = "#{OPENFOOTBALL_PATH}/austria"

pack = SportDb::Package.new( path )
pack.read_match

## pack.read
## pack.read( season: '2012/13' )


puts "table stats:"
SportDb.tables


puts 'bye'
