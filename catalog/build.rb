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

CatalogDb::CountryIndexer.add( countries )

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

CatalogDb::NationalTeamIndexer.add( teams )


CatalogDb::LeagueIndexer.read( '../../../openfootball/leagues' )

## change EventIndexer to LeagueSeason(s)Indexer  - why? why not?
CatalogDb::EventIndexer.read( '../../../openfootball/leagues' )


## note: grounds before clubs (clubs may reference grounds!!)
CatalogDb::GroundIndexer.read( '../../../openfootball/clubs' )


CatalogDb::ClubIndexer.read( '../../../openfootball/clubs' )
           


puts "bye"
