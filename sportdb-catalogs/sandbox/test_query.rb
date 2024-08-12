$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))

require 'sportdb/catalogs'

## add for now for EventInfo
require 'sportdb/formats'


Country      = CatalogDb::Metal::Country
League       = CatalogDb::Metal::League
NationalTeam = CatalogDb::Metal::NationalTeam
Club         = CatalogDb::Metal::Club
EventInfo    = CatalogDb::Metal::EventInfo

Ground       = CatalogDb::Metal::Ground


SportDb::Import.config.catalog_path = "../catalog/catalog.db"


pp Country.count
pp League.count
pp NationalTeam.count
pp Club.count
pp EventInfo.count

pp Ground.count


# pp EventInfo.find_by( league: 'at.1', season: '2018/19' )
# pp EventInfo.find_by( league: 'at.1', season: '2122/23' )

# pp EventInfo.seasons( 'at.1' )
# pp EventInfo.seasons( 'eng.1' )

# pp EventInfo.find_season( date: '2018-11-11', league: 'at.1' )
# pp EventInfo.find_season( date: '2122-11-11', league: 'at.1' )



pp Club.match_by( name: 'arsenal' )
pp Club.match_by( name: 'xxx' )
pp Club.match_by( name: 'liverpool' )

pp Club.match_by( name: 'az' )
pp Club.match_by( name: 'bayern' )


pp Country.find_by_name( 'austria' )
pp Country.find_by_name( 'deutschland' )
pp Country.find_by_name( 'iran' )

pp Country.find_by_name_or_code( 'austria' )
pp Country.find_by_name_or_code( 'at' )


# pp Country[ 'austria' ]  deprecate .[] - why? why not?
# pp Country[ 'at' ]       deprecate .[] - why? why not?


pp League.match_by_name( 'English Premier League' )
pp League.match_by_name( 'Euro' )
pp League.match_by_name( 'Premier League',
                           country: 'eng' )
pp League.match_by_name( 'Premier League',
                           country: 'England' )

## try new by code machinery
pp League.match_by_code( 'ENG PL' )
pp League.match_by_code( 'ENG PL', country: 'England' )
pp League.match_by_code( 'ENG 1' )
pp League.match_by_code( 'AT 1' )
pp League.match_by_code( 'EURO' )

pp League.match_by_name_or_code( 'AT 1' )
pp League.match_by_name_or_code( 'ENG PL' )
pp League.match_by_name_or_code( 'Premier League' )
pp League.match_by_name_or_code( 'Premier League',
                                  country: 'eng' )



pp Club.match_by( name: 'Preussen Münster' )

pp Club.match_by( name: 'Arsenal', country: 'eng' )
pp Club.match_by( name: 'Arsenal', country: 'Argentina' )


pp Club.match_by( name: 'Arsenal', country: 'eng' )



pp Ground.match_by( name: 'Waldstadion' )
pp Ground.match_by( name: 'Waldstadion', country: 'de' )
pp Ground.match_by( name: 'Waldstadion', city: 'Frankfurt' )

puts "---"

pp Ground.match_by( name: 'Stade de France' )
pp Ground.match_by( name: 'Stade de France', city: 'Paris' )
pp Ground.match_by( name: 'Stade de France', city: 'Saint-Denis' )



puts "bye"
