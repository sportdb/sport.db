#######
# test linter

## note: use the local version of gems
$LOAD_PATH.unshift( File.expand_path( '../date-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../score-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../parser/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../quick/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))

## our own code
require 'sportdb/formats'


SportDb::Import.config.catalog_path = '../catalog/catalog.db'


path = '../../../openfootball\england/2024-25/1-premierleague.txt'
linter = SportDb::QuickMatchLinter.new( read_text( path ) )
matches = linter.parse



puts "bye"