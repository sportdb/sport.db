$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))

require 'sportdb/catalogs'


CatalogDb::Metal.tables


Country      = CatalogDb::Metal::Country
League       = CatalogDb::Metal::League
NationalTeam = CatalogDb::Metal::NationalTeam
Club         = CatalogDb::Metal::Club

pp Country.count
pp League.count
pp NationalTeam.count
pp Club.count

## note - defaults to build in catalog.db on first call
puts
CatalogDb::Metal.tables


puts "bye"
