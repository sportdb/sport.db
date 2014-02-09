
#########################
#  Fill up sport.db w/ football.db fixtures


##############################
## for testing 
##
## NB: use
#   rake -I ../world.db.ruby/lib -I ../sport.db.ruby/lib update


include SportDB::Fixtures   # include fixture constants like WORLD_FIXTURES, EN_FIXTURES etc.


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
    reader.load_leagues_with_include_path( 'leagues_club', INCLUDE_PATH, { club: true } )
  end
  
  ### club europe (cl,el)
  task :club_europe => [:import] do
    import_fixtures( CLUB_EUROPE_TEAMS, CLUB_EUROPE_FIXTURES )
  end

  ### club america 
  task :club_america => [:import] do
    import_fixtures( CLUB_AMERICA_TEAMS, CLUB_AMERICA_FIXTURES )
  end
  
  task :europe  => [:import] do
    import_fixtures( EUROPE_TEAMS, EUROPE_FIXTURES )
  end

  task :america  => [:import] do
    import_fixtures( AMERICA_TEAMS, AMERICA_FIXTURES )
  end
  
  task :world  => [:import] do
    import_fixtures( WORLD_TEAMS, WORLD_FIXTURES )
  end

  ### ar - Argentina
  task :ar => [:import] do
    import_fixtures( AR_TEAMS, AR_FIXTURES )
  end

  ### br - Brasil
  task :br => [:import] do
    import_fixtures( BR_TEAMS, BR_FIXTURES )
  end
  
  ### mx - Mexico
  task :mx => [:import] do
    import_fixtures( MX_TEAMS, MX_FIXTURES )
  end
  
  #### at - Austria
  task :at => [:import] do
    import_fixtures( AT_TEAMS, AT_FIXTURES )
  end
  
  #### de - Deutschland/Germany
  task :de => [:import] do
    import_fixtures( DE_TEAMS, DE_FIXTURES )
  end

  #### en - England
  task :en => [:import] do
    import_fixtures( EN_TEAMS, EN_FIXTURES )
  end

  #### ro - Romania
  task :ro => [:import] do
    import_fixtures( RO_TEAMS, RO_FIXTURES )
  end



  desc 'worlddb - test loading of builtin fixtures (update)'
  task :update => [:world]
  # task :update => [:at, :de, :en, :ro, :ar, :br, :mx]



  def import_fixtures( teams, fixtures )
    reader = SportDB::Reader.new
    reader.load_with_include_path( teams, INCLUDE_PATH )
    reader.load_with_include_path( fixtures, INCLUDE_PATH )
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

