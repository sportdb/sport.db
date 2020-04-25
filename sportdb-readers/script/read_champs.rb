##
#  use
#   $ ruby -I ./lib script/read_champs.rb

## note: use the local version of sportdb gems
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-countries/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-leagues/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-clubs/lib' ))

$LOAD_PATH.unshift( File.expand_path( '../sportdb-match-formats/lib' ))

$LOAD_PATH.unshift( File.expand_path( '../sportdb-sync/lib' ))


## our own code
require 'sportdb/readers'


## use (switch to) "external" datasets
SportDb::Import.config.leagues_dir = "../../../openfootball/leagues"
SportDb::Import.config.clubs_dir   = "../../../openfootball/clubs"


SportDb.connect( adapter:  'sqlite3',
                 database: './champs.db' )
SportDb.create_all   ## build schema

## turn on logging to console
ActiveRecord::Base.logger = Logger.new(STDOUT)


path = "../../../openfootball/europe-champions-league"

pack = SportDb::Package.new( path )
pack.read_match

## pack.read
## pack.read( season: '2012/13' )

