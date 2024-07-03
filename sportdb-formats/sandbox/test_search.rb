#######
# test search (struct convenience) helpers/methods

## note: use the local version of gems
$LOAD_PATH.unshift( File.expand_path( '../date-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../score-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-langs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))

## our own code
require 'sportdb/formats'


require 'sportdb/catalogs'

SportDb::Import.config.catalog_path = '../catalog/catalog.db'


Country      = Sports::Country
League       = Sports::League
NationalTeam = Sports::NationalTeam
Club         = Sports::Club


pp Country.find_by( code: 'A' )
pp Country.find_by( code: 'AT' )
pp Country.find_by( code: 'AUT' )
pp Country.find_by( code: 'E' )

pp Country.find_by( name: 'Austria' )
pp Country.find_by( name: 'Österreich' )

pp Country.parse_heading( 'Austria (at)' )
pp Country.parse_heading( 'Austria' )
pp Country.parse_heading( 'at' )
pp Country.parse_heading( 'Austria (AUT)' )
pp Country.parse_heading( 'Austria' )
pp Country.parse_heading( 'A' )


pp League.match_by( name: 'Bundesliga' )
pp League.match_by( name: 'ENG' )
pp League.match_by( name: 'ENG.1' )
pp League.match_by( name: 'ENG 1' )

pp League.match_by( name: 'Euro' )
pp League.match_by( name: 'Champions League' )
## keep pl for (re)use
pp pl = League.match_by( name: 'Premier League', country: 'England ')[0]

pp NationalTeam.find( 'Austria' )
pp NationalTeam.find( 'England' )


pp Club.match_by( name: 'Arsenal' )
pp Club.match_by( name: 'Arsenal', country: 'England' )
pp Club.match_by( name: 'Arsenal', league: pl )


puts "bye"