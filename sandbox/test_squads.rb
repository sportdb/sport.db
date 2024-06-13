$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))

require 'sportdb/catalogs'



SportDb::Import.config.catalog_path = '../catalog/catalog.db'
SportDb::Import.config.players_path = '../catalog/players.db'

PLAYERS = SportDb::Import.catalog.players

puts "try Player.match_by:"
pp  PLAYERS.match_by( name: 'David Alaba')
pp  PLAYERS.match_by( name: 'Alaba')
pp  PLAYERS.match_by( name: 'Alaba', country: 'Austria' )
pp  PLAYERS.match_by( name: 'Alaba', country: 'A' )
pp  PLAYERS.match_by( name: 'Alaba', country: 'England' )
pp  PLAYERS.match_by( name: 'Alaba', year: 1992 )
pp  PLAYERS.match_by( name: 'Alaba', year: 1993 )

puts
pp  PLAYERS.match_by( name: 'Harry Kane' )
pp  PLAYERS.match_by( name: 'Kane' )

puts
pp  PLAYERS.match_by( name: 'Messi' )

puts
pp  PLAYERS.match_by( name: 'Mbappé' )
pp  PLAYERS.match_by( name: 'Mbappe' )



puts "bye"