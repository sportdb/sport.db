require 'active_record'   ## todo: add sqlite3? etc.

require_relative 'schema'
require_relative 'models'


### note: make sure to load latest sportdb/structs !!!  (allow key with numbers!)
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))

require 'sportdb/structs'
require 'sportdb/formats'
require 'sportdb/catalogs'  ## todo/fix!!! - replace with new db/sqlite catalog machinery!!!
require 'fifa'

require_relative 'indexer'
require_relative 'country_indexer'
require_relative 'national_team_indexer'
require_relative 'club_indexer'
require_relative 'league_indexer'



####
#  db support
def connect
    config = {
        adapter:  'sqlite3',
        database: './catalog.db',
    }

    ActiveRecord::Base.establish_connection( config )
    # ActiveRecord::Base.logger = Logger.new( STDOUT )

    ## if sqlite3 add (use) some pragmas for speedups
    if config[:adapter]  == 'sqlite3'  &&
       config[:database] != ':memory:'
      ## note: if in memory database e.g. ':memory:' no pragma needed!!
      ## try to speed up sqlite
      ##   see http://www.sqlite.org/pragma.html
      con = ActiveRecord::Base.connection
      con.execute( 'PRAGMA synchronous=OFF;' )
      con.execute( 'PRAGMA journal_mode=OFF;' )
      con.execute( 'PRAGMA temp_store=MEMORY;' )
    end
end


def auto_migrate!
    connect
    unless CatalogDb::Model::Country.table_exists?
        CatalogDb::CreateDb.new.up
    end
end


auto_migrate!



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
