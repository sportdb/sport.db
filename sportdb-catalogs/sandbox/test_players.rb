$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))

require 'sportdb/catalogs'

## add for now for EventInfo
require 'sportdb/formats'


Country      = CatalogDb::Metal::Country
City         = CatalogDb::Metal::City

League       = CatalogDb::Metal::League
NationalTeam = CatalogDb::Metal::NationalTeam
Club         = CatalogDb::Metal::Club
EventInfo    = CatalogDb::Metal::EventInfo

Ground       = CatalogDb::Metal::Ground

Player       = CatalogDb::Metal::Player


SportDb::Import.config.catalog_path = '../catalog/catalog.db'
SportDb::Import.config.players_path = '../catalog/players.db'



pp Country.count
pp City.count

pp League.count
pp NationalTeam.count
pp Club.count
pp EventInfo.count

pp Ground.count

puts "players:"
pp Player.count


puts "try Player.match_by:"
pp  Player.match_by( name: 'David Alaba')
pp  Player.match_by( name: 'Alaba')
pp  Player.match_by( name: 'Alaba', country: 'Austria' )
pp  Player.match_by( name: 'Alaba', country: 'England' )
pp  Player.match_by( name: 'Alaba', year: 1992 )
pp  Player.match_by( name: 'Alaba', year: 1993 )

puts
pp  Player.match_by( name: 'Harry Kane' )
pp  Player.match_by( name: 'Kane' )

puts
pp  Player.match_by( name: 'Messi' )

puts
pp  Player.match_by( name: 'Mbappé' )
pp  Player.match_by( name: 'Mbappe' )


puts "bye"