## note: use the local version of gems
$LOAD_PATH.unshift( File.expand_path( '../sportdb-langs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-readers/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-sync/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-models/lib' ))


## our own code
require 'sportdb/catalogs'
require 'sportdb/formats'

require 'sportdb/readers'


SportDb::Import.config.catalog_path = '../catalog/catalog.db'

puts "  #{CatalogDb::Metal::Country.count} countries"
puts "  #{CatalogDb::Metal::Club.count} clubs"
puts "  #{CatalogDb::Metal::NationalTeam.count} national teams"
puts "  #{CatalogDb::Metal::League.count} leagues"



