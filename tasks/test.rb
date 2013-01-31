
#########################
#  Fill up sport.db w/ football.db fixtures


##############################
## for testing 
##
## NB: use
#   rake -I ../world.db.ruby/lib -I ../sport.db.ruby/lib update



##########
# TODO: configure - copy to your rake file

#  INCLUDE_PATH = "../football.db"
  
#  BUILD_DIR = "./db"
  
#  SPORT_DB_PATH = "#{BUILD_DIR}/sport.db"


################

  DB_CONFIG = {
    :adapter   =>  'sqlite3',
    :database  =>  SPORT_DB_PATH
  }

  directory BUILD_DIR

 # task :clean do
 #   rm SPORT_DB_PATH if File.exists?( SPORT_DB_PATH )
 # end

  task :env => BUILD_DIR do
    pp DB_CONFIG
    ActiveRecord::Base.establish_connection( DB_CONFIG )
  end

 # task :create => :env do
 #   WorldDB.create
 # end

  task :import => :env do
    reader = SportDB::Reader.new
    
    reader.load_seasons_with_include_path( 'seasons', INCLUDE_PATH )
    
    reader.load_leagues_with_include_path( 'leagues',      INCLUDE_PATH )
    reader.load_leagues_with_include_path( 'leagues_club', INCLUDE_PATH, club: true )
  end
  


  AR_FIXTURES = []

  BR_FIXTURES = [
    ['br.2013', 'br/2013/cb' ]
  ]

  MX_FIXTURES = [
    ['mx.apertura.2012.2', 'mx/2012_apertura' ],
    ['mx.clausura.2013.1', 'mx/2013_clausura' ]
  ]


  AT_FIXTURES = [
    ['at.2011/12',     'at/2011_12/bl' ],
    ['at.cup.2011/12', 'at/2011_12/cup' ],
    ['at.2012/13',     'at/2012_13/bl', 'at/2012_13/bl2'],
    ['at.cup.2012/13', 'at/2012_13/cup']
  ]
  
  DE_FIXTURES = [
    ['de.2012/13',     'de/2012_13/bl' ]
  ]
  
  EN_FIXTURES = [
    ['en.2012/13',     'en/2012_13/pl' ]
  ]
  
  RO_FIXTURES = [
    ['ro.2012/13',     'ro/2012_13_l1' ]
  ]

  ### ar - Argentina
  task :ar => [:import] do
    import_club_fixtures_for_country( 'ar', AR_FIXTURES )
  end

  ### br - Brasil
  task :br => [:import] do
    import_club_fixtures_for_country( 'br', BR_FIXTURES )
  end
  
  ### mx - Mexico
  task :mx => [:import] do
    import_club_fixtures_for_country( 'mx', MX_FIXTURES )
  end
  
  #### at - Austria
  task :at => [:import] do
    import_club_fixtures_for_country( 'at', AT_FIXTURES )
  end
  
  #### de - Deutschland/Germany
  task :de => [:import] do
    import_club_fixtures_for_country( 'de', DE_FIXTURES )
  end

  #### en - England
  task :en => [:import] do
    import_club_fixtures_for_country( 'en', EN_FIXTURES )
  end

  #### ro - Romania
  task :ro => [:import] do
    import_club_fixtures_for_country( 'ro', RO_FIXTURES )
  end

  desc 'worlddb - test loading of builtin fixtures (update)'
  # task :update => [:en]
  task :update => [:at, :de, :en, :ro, :ar, :br, :mx]


  def import_club_fixtures_for_country( country_key, fixtures )
    country = SportDB::Models::Country.find_by_key!( country_key )
    
    reader = SportDB::Reader.new
    reader.load_teams_with_include_path( "#{country_key}/teams", INCLUDE_PATH, { club: true, country_id: country.id } )

    fixtures.each do |item|
      # assume first item is key
      # assume second item is event plus fixture
      # assume option third,etc are fixtures (e.g. bl2, etc.)
      event_key      = item[0]  # e.g. at.2012/13
      event_name     = item[1]  # e.g. at/2012_13/bl
      fixture_names  = item[1..-1]  # e.g. at/2012_13/bl, at/2012_13/bl2
      
      reader.load_event_with_include_path( event_name, INCLUDE_PATH )
      fixture_names.each do |fixture_name|
        reader.load_fixtures_with_include_path( event_key, fixture_name, INCLUDE_PATH )
      end
    end
  end
=begin

##################
# usage sample
##################

#### step 1) configure tasks in test.rb in your rake file

Rakefile:

INCLUDE_PATH = "../football.db"
  
BUILD_DIR = "./db"
  
SPORT_DB_PATH = "#{BUILD_DIR}/sport.db"


#### step 2) include tasks in test.rb

SPORT_DB_RUBY_PATH = "../sport.db.ruby"
WORLD_DB_RUBY_PATH = "../world.db.ruby"

require "#{WORLD_DB_RUBY_PATH}/lib/worlddb.rb"
require "#{SPORT_DB_RUBY_PATH}/lib/sportdb.rb"

require "#{SPORT_DB_RUBY_PATH}/tasks/test.rb"

Shell:

### step 3) call on command line

$ rake -I ../world.db.ruby/lib -I ../sport.db.ruby/lib update

=end
