## note: use the local version of sportdb gems
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-search/lib' ))


$LOAD_PATH.unshift( './lib' )
require 'sportdb/search'

## use (switch to) "external" datasets
SportDb::Import.config.catalog_path = "../catalog/catalog.db"

## print/dump stats
CatalogDb::Metal.tables



Country      = Sports::Country
League       = Sports::League
LeaguePeriod = Sports::LeaguePeriod


pp League.match_by( name: 'English Premier League' )
pp League.match_by( name: 'Euro' )
pp League.match_by( name: 'Premier League',
                           country: 'eng' )
pp League.match_by( name: 'Premier League',
                           country: 'England' )

## try new by code machinery
pp League.match_by( code: 'ENG PL' )
pp League.match_by( code: 'ENG PL', country: 'England' )

pp League.match_by( code: 'ENG 1' )
pp League.match_by( code: 'ENG 2' )


## pp League.find( 'ENG 1' )
## pp League.find( 'ENG 2' )


pp League.match_by( code: 'AT 1' )
pp League.match_by( code: 'EURO' )

pp League.match( 'AT 1' )  # e.g. match_by_name_or_code
pp League.match( 'ENG PL' )
pp League.match( 'Premier League' )
pp League.match( 'Premier League',  country: 'eng' )



###
#   try (league) periods  (require season)
pp LeaguePeriod.find_by( code: 'eng.1', season: '2024/25' )
pp LeaguePeriod.find_by( code: 'eng.1', season: '1991/92' )
pp LeaguePeriod.find_by( code: 'eng.1', season: '1888/89' )

pp LeaguePeriod.find_by( name: 'English Premier League', season: '2024/25' )
pp LeaguePeriod.find_by( name: 'Österr. Bundesliga', season: '2024/25' )


puts "bye"