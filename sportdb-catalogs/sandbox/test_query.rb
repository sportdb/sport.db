$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))

require 'sportdb/catalogs'



Country      = CatalogDb::Metal::Country
League       = CatalogDb::Metal::League
NationalTeam = CatalogDb::Metal::NationalTeam
Club         = CatalogDb::Metal::Club


pp Country.count
pp League.count
pp NationalTeam.count
pp Club.count


pp Club.match( 'arsenal' )
pp Club.match( 'xxx' )
pp Club.match( 'liverpool' )

pp Club.match( 'az' )
pp Club.match( 'bayern' )


pp Country.find_by_name( 'austria' )
pp Country.find_by_name( 'deutschland' )
pp Country.find_by_name( 'iran' )

# pp Country[ 'austria' ]  deprecate .[] - why? why not?
# pp Country[ 'at' ]       deprecate .[] - why? why not?


pp League.match( 'English Premier League' )
pp League.match( 'Euro' )
pp League.match_by( name: 'Premier League',
                    country: 'eng' )
pp League.match_by( name: 'Premier League',
                    country: 'England' )
 


pp Club.match( 'Preussen Münster' )

pp Club.match_by( name: 'Arsenal', country: 'eng' )
pp Club.match_by( name: 'Arsenal', country: 'Argentina' )


pp Club.find_by( name: 'Arsenal', country: 'eng' )

puts "bye"
