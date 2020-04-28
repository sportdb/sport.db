##
#  use
#   $ ruby -I ./lib script/read_euro.rb


require_relative 'boot'


SportDb.connect( adapter:  'sqlite3',
                 database: './euro.db' )
SportDb.create_all   ## build schema

## turn on logging to console
## ActiveRecord::Base.logger = Logger.new(STDOUT)


path = "#{OPENFOOTBALL_PATH}/euro-cup"

pack = SportDb::Package.new( path )
pack.read_match


puts 'bye'
