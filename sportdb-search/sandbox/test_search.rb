$LOAD_PATH.unshift( './lib' )
require 'sportdb/search'


Country = Sports::Country
Club    = Sports::Club
League  = Sports::League
Ground  = Sports::Ground


pp Club.match_by( name: 'arsenal' )
pp Club.match_by( name: 'xxx' )
pp Club.match_by( name: 'liverpool' )

pp Club.match_by( name: 'az' )
pp Club.match_by( name: 'bayern' )



pp Country.find_by( name: 'austria' )
pp Country.find_by( name: 'deutschland' )
pp Country.find_by( name: 'iran' )

pp Country.find( 'austria' )
pp Country.find( 'at' )


pp Country[ 'austria' ]   # deprecate .[] - why? why not?
pp Country[ 'at' ]        # deprecate .[] - why? why not?



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
pp League.match_by( code: 'AT 1' )
pp League.match_by( code: 'EURO' )

pp League.match( 'AT 1' )  # e.g. match_by_name_or_code
pp League.match( 'ENG PL' )
pp League.match( 'Premier League' )
pp League.match( 'Premier League',  country: 'eng' )



pp Club.match_by( name: 'Preussen Münster' )

pp Club.match_by( name: 'Arsenal', country: 'eng' )
pp Club.match_by( name: 'Arsenal', country: 'Argentina' )


pp Club.match_by( name: 'Arsenal', country: 'eng' )



pp Ground.match_by( name: 'Waldstadion' )
pp Ground.match_by( name: 'Waldstadion', country: 'de' )
pp Ground.match_by( name: 'Waldstadion', city: 'Frankfurt' )

pp Ground.match_by( name: 'Stade de France' )
pp Ground.match_by( name: 'Stade de France', city: 'Paris' )
pp Ground.match_by( name: 'Stade de France', city: 'Saint-Denis' )


puts "bye"