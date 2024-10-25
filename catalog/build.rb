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


## add dummy country
dummy = Sports::Country.new( key: 'dmy', name: 'Dummy', code: 'DMY' )
CatalogDb::CountryIndexer.add( dummy )
## - add nil or undefined or such - why? why not?
## - add global/world or int'l or such - why? why not?


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

team = Sports::NationalTeam.new( key:  'dmy',
                                 name: 'N.N.',
                                 code: 'DMY' )
team.country = dummy
teams << team


CatalogDb::NationalTeamIndexer.add( teams )



CatalogDb::LeagueIndexer.read( '../../../openfootball/leagues' )

## change EventIndexer to LeagueSeason(s)Indexer  - why? why not?

## CatalogDb::EventIndexer.read( '../../../openfootball/leagues' )


## note: grounds before clubs (clubs may reference grounds!!)
CatalogDb::GroundIndexer.read( '../../../openfootball/clubs' )


CatalogDb::ClubIndexer.read( '../../../openfootball/clubs' )

## add place holder club (wiht dummy country)
club = Sports::Club.new( key: 'nn', name: 'N.N.' )
club.country = dummy

CatalogDb::ClubIndexer.add( club )


####
#
#  https://en.wikipedia.org/wiki/Nomen_nescio
#    Nomen nescio,
#     abbreviated to N.N., is used to signify an anonymous
#  or unnamed person. From Latin nomen – "name",
# and nescio – "I do not know", it literally means
# "I do not know the name".
#  The generic name Numerius Negidius used in Roman times
# was chosen partly because it shared initials with this phrase.
#
#
# N. N.    ### add dummy "placeholder" club / team
#          ##  Nomen nominandum, see https://de.wikipedia.org/wiki/N._N.

puts "bye"
