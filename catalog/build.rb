###
#
#  todo/fix - what to do with event info?
#    change to tier_key for lookup - why? why not?
#
#    ** !!! ERROR - too many matches (2) for league ENG 1:
# [<League CLUBS: eng_championship - Championship, England (ENG)>,
#  <League CLUBS: eng_premierleague - Premier League, England (ENG)>]





### note: make sure to load latest sportdb/structs !!!  (allow key with numbers!)
$LOAD_PATH.unshift( File.expand_path( '../parser/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-search/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-helpers/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))


require 'sportdb/indexers'

## todo/fix
##  move Package from format down for (re)use
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
require 'sportdb/formats'


## add/use fifa for index countries
require 'fifa'


if File.exist?( './catalog.db' )
    File.delete( './catalog.db' )
    sleep( 2 )  ## wait 2 secs before reopen file
end


CatalogDb.open( './catalog.db' )



## note: use world countries (incl. historic and non-members)!!!
countries = Fifa.world.countries
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

## CatalogDb::EventIndexer.read( '../../../openfootball/leagues' )


## note: grounds before clubs (clubs may reference grounds!!)
CatalogDb::GroundIndexer.read( '../../../openfootball/clubs' )


CatalogDb::ClubIndexer.read( '../../../openfootball/clubs' )



puts "bye"
