require 'active_record'   ## todo: add sqlite3? etc.

require_relative 'schema'
require_relative 'models'


### note: make sure to load latest sportdb/structs !!!  (allow key with numbers!)
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))

require 'sportdb/structs'
require 'sportdb/formats'
require 'sportdb/catalogs'  ## todo/fix!!! - replace with new db/sqlite catalog machinery!!!
require 'fifa'


require_relative 'country_index'
require_relative 'national_team_index'
require_relative 'club_index'
require_relative 'league_index'



####
#  db support
def connect
    config = {
        adapter:  'sqlite3',
        database: './catalog.db',
    }

    # puts "configs before:"
    # pp ActiveRecord::Base.configurations

    ## ActiveRecord::Base.configurations = {    catalog: config  }

    # puts "configs after:"
    # pp ActiveRecord::Base.configurations
=begin
@configurations=
  [#<ActiveRecord::DatabaseConfigurations::HashConfig:0x000002be8a2001c0
    @configuration_hash={:adapter=>"sqlite3", :database=>"./catalog.db"},
    @env_name="catalog",
    @name="primary">]>
=end

    ActiveRecord::Base.establish_connection( config )
    # CatalogDb::Model::CatalogRecord.establish_connection( :catalog )
    # ActiveRecord::Base.logger = Logger.new( STDOUT )

    puts "configs after:"
    pp ActiveRecord::Base.configurations
    

    ## if sqlite3 add (use) some pragmas for speedups
    if config[:adapter]  == 'sqlite3'  &&
       config[:database] != ':memory:'
      ## note: if in memory database e.g. ':memory:' no pragma needed!!
      ## try to speed up sqlite
      ##   see http://www.sqlite.org/pragma.html
      con = ActiveRecord::Base.connection
      ## con = CatalogDb::Model::CatalogRecord.connection
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


=begin
  def build_club_history_index
    if config.clubs_dir    ## (re)use clubs dir for now  - why? why not?
      ClubHistoryIndex.build( config.clubs_dir )
    else
      puts "!! WARN - no clubs_dir set; for now NO built-in club histories in catalog; sorry - fix!!!!"
      ClubHistoryIndex.new   ## return empty history index
    end
  end
=end


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

CatalogDb::CountryIndex.new( countries )

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

CatalogDb::NationalTeamIndex.new( teams )


CatalogDb::LeagueIndex.build( '../../../openfootball/leagues' )
CatalogDb::ClubIndex.build( '../../../openfootball/clubs' )
           

puts "bye"
