##
#  use
#   $ ruby script/read_euro.rb


require_relative 'boot'


File.delete( './euro.db' )   if File.exist?( './euro.db' )


SportDb.open( './euro.db' )

# SportDb.connect( adapter:  'sqlite3',
#                  database: './euro.db' )
# SportDb.create_all   ## build schema

## turn on logging to console
## ActiveRecord::Base.logger = Logger.new(STDOUT)


path = "#{OPENFOOTBALL_PATH}/euro"

pack = SportDb::Package.new( path )
pack.read_match


puts "table stats:"
SportDb.tables


puts 'bye'
