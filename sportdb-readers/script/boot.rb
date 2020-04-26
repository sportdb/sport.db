## note: use the local version of sportdb gems
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-countries/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-leagues/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-clubs/lib' ))

$LOAD_PATH.unshift( File.expand_path( '../sportdb-match-formats/lib' ))

$LOAD_PATH.unshift( File.expand_path( '../sportdb-sync/lib' ))


## our own code
require 'sportdb/readers'


OPENFOOTBALL_PATH = '../../../openfootball'

## use (switch to) "external" datasets
SportDb::Import.config.leagues_dir = "#{OPENFOOTBALL_PATH}/leagues"
SportDb::Import.config.clubs_dir   = "#{OPENFOOTBALL_PATH}/clubs"
