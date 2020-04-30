## note: use the local version of sportdb gems
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-countries/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-teams/lib' ))


## minitest setup

require 'minitest/autorun'


## our own code
require 'footballdb/clubs/auto'
