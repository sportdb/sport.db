## note: use the local version of sportdb gems
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-countries/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-leagues/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-teams/lib' ))

$LOAD_PATH.unshift( File.expand_path( '../sportdb-match-formats/lib' ))

$LOAD_PATH.unshift( File.expand_path( '../sportdb-config/lib' ))


## minitest setup
require 'minitest/autorun'


## our own code
require 'sportdb/sync'
