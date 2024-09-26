##
#  use
#   $ ruby script/read_de.rb


require_relative 'boot'

File.delete( './de.db' )   if File.exist?( './de.db' )


SportDb.open( './de.db' )

## turn on logging to console
## ActiveRecord::Base.logger = Logger.new(STDOUT)


path = "#{OPENFOOTBALL_PATH}/deutschland"

pack = SportDb::Package.new( path )
pack.read_match

## pack.read
## pack.read( season: '2012/13' )


puts "table stats:"
SportDb.tables


puts 'bye'
