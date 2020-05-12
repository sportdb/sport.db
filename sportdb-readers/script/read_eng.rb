##
#  use
#   $ ruby -I ./lib script/read_eng.rb


require_relative 'boot'

File.delete( './eng.db' )   if File.exist?( './eng.db' )

SportDb.connect( adapter:  'sqlite3',
                 database: './eng.db' )
SportDb.create_all   ## build schema

## turn on logging to console
## ActiveRecord::Base.logger = Logger.new(STDOUT)


path = "#{OPENFOOTBALL_PATH}/england"

pack = SportDb::Package.new( path )
pack.read_match

## pack.read
## pack.read( season: '2012/13' )

puts 'bye'
