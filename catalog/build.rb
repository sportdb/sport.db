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

## pp countries
=begin
#<Sports::Country:0x000001d873349fc0
  @alt_names=["Deutschland [de]"],
  @code="GER",
  @key="de",
  @name="Germany",
  @tags=["fifa", "uefa"]>,
#<Sports::Country:0x000001d87334b4b0
  @alt_names=["Österreich [de]"],
  @code="AUT",
  @key="at",
  @name="Austria",
  @tags=["fifa", "uefa"]>,
#<Sports::Country:0x000001d87334ae70
  @alt_names=["Bosnia-Herzegovina", "Bosnia", "Bosnia-Herz."],
  @code="BIH",
  @key="ba",
  @name="Bosnia and Herzegovina",
  @tags=["fifa", "uefa"]>,  
 #<Sports::Country:0x000001d873342b30
  @alt_names=["IR Iran", "Islamic Republic of Iran"],
  @code="IRN",
  @key="ir",
  @name="Iran",
  @tags=["fifa", "afc", "cafa"]>,
 #<Sports::Country:0x000001d8727ea828
  @alt_names=[],
  @code="YUG",
  @key="yugoslavia",
  @name="Yugoslavia (-2003)",
  @tags=[]>,
=end

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
CatalogDb::ClubIndexer.build( '../../../openfootball/clubs' )
           

puts "bye"
