##
#  use
#   $ ruby script/read_starter.rb


require_relative 'boot'

File.delete( './mauritius.db' )   if File.exist?( './mauritius.db' )


SportDb.open( './mauritius.db' )

## turn on logging to console
## ActiveRecord::Base.logger = Logger.new(STDOUT)


path = "#{OPENFOOTBALL_PATH}/league-starter"

pack = SportDb::Package.new( path )
pack.read_match


puts "table stats:"
SportDb.tables


puts 'bye'
