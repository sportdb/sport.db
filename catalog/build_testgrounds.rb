### note: make sure to load latest sportdb/structs !!!  (allow key with numbers!)
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))


require 'sportdb/indexers'

## add/use fifa for index countries
require 'fifa'


CatalogDb.open( './grounds.db' )



countries = Fifa.countries
puts "  #{countries.size} countries"
#=> 241 countries

CatalogDb::CountryIndexer.new( countries )


CatalogDb::GroundIndexer.build( '../../../openfootball/stadiums' )
           
puts "bye"
