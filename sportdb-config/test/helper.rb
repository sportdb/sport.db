## note: use the local version of sportdb gems
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-countries/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-leagues/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-clubs/lib' ))

$LOAD_PATH.unshift( File.expand_path( '../footballdb-leagues/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../footballdb-clubs/lib' ))

## minitest setup

require 'minitest/autorun'


## our own code

require 'sportdb/config'


SportDb::Import.config.clubs_dir   = '../../../openfootball/clubs'
SportDb::Import.config.leagues_dir = '../../../openfootball/leagues'
