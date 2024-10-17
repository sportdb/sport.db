### note: make sure to load latest sportdb/structs !!!  (allow key with numbers!)
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-helpers/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-search/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))

# add formats for SportDb::Package
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
require 'sportdb/formats'


require 'sportdb/indexers'


## set catalog db (required for world search api)
SportDb::Import.config.catalog_path = './catalog.db'

## dump table stats and test country lookup
CatalogDb::Metal.tables


Country = Sports::Country



at = Country.find_by( code: 'at' )
pp at
pp at.names
pp at.adjs
pp at.codes

de = Country.find_by( code: 'de' )
pp de
pp de.names
pp at.adjs
pp de.codes

puts "at.1:"
pp CatalogDb::LeagueIndexer.gen_alt_codes( 'at.1', country: at )
puts "at.2:"
pp CatalogDb::LeagueIndexer.gen_alt_codes( 'at.2', country: at )
puts "at.3.sbg:"
pp CatalogDb::LeagueIndexer.gen_alt_codes( 'at.3.sbg', country: at )


puts "de.1:"
pp CatalogDb::LeagueIndexer.gen_alt_codes( 'de.1', country: de )
puts "de.4.bayern:"
pp CatalogDb::LeagueIndexer.gen_alt_codes( 'de.4.bayern', country: de )


puts "bye"