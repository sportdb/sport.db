### note: make sure to load latest sportdb/structs !!!  (allow key with numbers!)
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))


require 'sportdb/indexers'

## add/use fifa for index countries
require 'fifa'


CatalogDb.open( './catalog.db' )



countries = Fifa.countries
puts "  #{countries.size} countries"
#=> 241 countries

CatalogDb::CountryIndexer.new( countries )

## auto-build national teams from Fifa.countries for now
teams = []
countries.each do |country|
    team = Sports::NationalTeam.new( key:        country.code.downcase,  ## note: use country code (fifa)
                                name:       country.name,
                                code:       country.code,           ## note: use country code (fifa)
                               alt_names:  country.alt_names )
    team.country = country

    teams << team
end

CatalogDb::NationalTeamIndexer.new( teams )


CatalogDb::LeagueIndexer.build( '../../../openfootball/leagues' )
CatalogDb::EventIndexer.build( '../../../openfootball/leagues' )

CatalogDb::ClubIndexer.build( '../../../openfootball/clubs' )
           

CatalogDb::GroundIndexer.build( '../../../openfootball/stadiums' )

puts "bye"
