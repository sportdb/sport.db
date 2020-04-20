## $:.unshift(File.dirname(__FILE__))

## minitest setup
require 'minitest/autorun'


## note: use the local version of sportdb gems
$LOAD_PATH.unshift( File.expand_path( '../sportdb-match-formats/lib' ))


## our own code
require 'sportdb/readers'




## use (switch to) "external" datasets
SportDb::Import.config.leagues_dir = "../../../openfootball/leagues"
SportDb::Import.config.clubs_dir   = "../../../openfootball/clubs"
