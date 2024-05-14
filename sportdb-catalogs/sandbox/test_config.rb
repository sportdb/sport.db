$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))

require 'sportdb/catalogs'


SportDb::Import.configure do |config|
   puts "config:"
   pp config

   puts "  lang:          " + (config.lang || '<undefined>') 
   puts "  catalog_path:  " + (config.catalog_path || '<undefined>')

   config.catalog_path = "../catalog/catalog.db"
   puts "  catalog_path:  " + (config.catalog_path || '<undefined>')

   puts "catalog:"
   pp config.catalog
end




SportDb::Import.config.catalog_path = "../catalog/catalog.db"

Country      = CatalogDb::Metal::Country
League       = CatalogDb::Metal::League
NationalTeam = CatalogDb::Metal::NationalTeam
Club         = CatalogDb::Metal::Club

pp Country.count
pp League.count
pp NationalTeam.count
pp Club.count


puts "bye"