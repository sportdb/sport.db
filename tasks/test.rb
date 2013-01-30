
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
  
  #### mx - Mexico
  task :mx => [:import] do
    mx = SportDB::Models::Country.find_by_key!( 'mx' )
    
    reader = SportDB::Reader.new
    reader.load_teams_with_include_path( 'mx/teams', INCLUDE_PATH, { club: true, country_id: mx.id } )
    
    ## 2012 apertura season
    
    reader.load_event_with_include_path( 'mx/2012_apertura', INCLUDE_PATH )  
    reader.load_fixtures_with_include_path( 'mx.apertura.2012.2', 'mx/2012_apertura', INCLUDE_PATH )

    ## 2013 clausura season

    reader.load_event_with_include_path( 'mx/2013_clausura', INCLUDE_PATH )  
    reader.load_fixtures_with_include_path( 'mx.clausura.2013.1', 'mx/2013_clausura', INCLUDE_PATH )
  end
  
  
  #### at - Austria
  task :at => [:import] do
    at = SportDB::Models::Country.find_by_key!( 'at' )
    
    reader = SportDB::Reader.new
    reader.load_teams_with_include_path( 'at/teams', INCLUDE_PATH, { club: true, country_id: at.id } )
    
    ## 2011/12 season
    
    reader.load_event_with_include_path( 'at/2011_12/bl', INCLUDE_PATH )
    reader.load_event_with_include_path( 'at/2011_12/cup', INCLUDE_PATH )
    
    reader.load_fixtures_with_include_path( 'at.2011/12', 'at/2011_12/bl', INCLUDE_PATH )
    reader.load_fixtures_with_include_path( 'at.cup.2011/12', 'at/2011_12/cup', INCLUDE_PATH )
    
    ## 2012/13 season
    
    reader.load_event_with_include_path( 'at/2012_13/bl', INCLUDE_PATH )
    reader.load_event_with_include_path( 'at/2012_13/cup', INCLUDE_PATH )
    
    reader.load_fixtures_with_include_path( 'at.2012/13', 'at/2012_13/bl', INCLUDE_PATH )
    reader.load_fixtures_with_include_path( 'at.2012/13', 'at/2012_13/bl2', INCLUDE_PATH )
    reader.load_fixtures_with_include_path( 'at.cup.2012/13', 'at/2012_13/cup', INCLUDE_PATH )
    
  end

  desc 'worlddb - test loading of builtin fixtures (update)'
  task :update => [:at, :mx]

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
