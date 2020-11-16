##########
#  setup load path
#     lets you use environments
#     e.g. dev/development or prod/production

require 'pp'




$RUBYLIBS_DEBUG = true
$RUBYCOCO_DEBUG = true    ## always include (NOT just in sportdb?)




### todo/check - move true values and debug? "upstream" to monos - why? why not??

TRUE_VALUES = [
  'true', 't',
  'yes', 'y',
  'on',
  '1',     # note: add 1 too
]

### include / check for ruby debug flag too - why? why not?
def debug?     ## always include (NOT just insportdb?)
  value = ENV['DEBUG']
  if value && TRUE_VALUES.include?( value.downcase )
    true
  else
    false
  end
end


## convenience pre-configured/pre-built shortcut - lets you use
##    require 'sportdb/setup'
##    SportDb::Boot.setup


module SportDb
module Boot
  def self.root
    ## note: uses a copy-n-paste version of Mono.root for now - why? why not?
    @@root ||= begin
            ## todo/fix:
            ##  check if windows - otherwise use /sites
            ##  check if root directory exists?
            if ENV['MOPATH']
              ## use expand path to make (assure) absolute path - why? why not?
              File.expand_path( ENV['MOPATH'] )
            elsif Dir.exist?( 'C:/Sites' )
              'C:/Sites'
            else
              '/sites'
            end
          end
  end

  def self.root=( path )
    ## use expand path to make (assure) absolute path - why? why not?
    @@root = File.expand_path( path )
  end


  def self.setup   ## setup load path
### note: for now always assume dev/development
###   add ENV check later or pass in as args or such

    puts "SportDb::Boot.root: >#{root}<"

    ## add football webget & sources too
    $LOAD_PATH.unshift( "#{root}/yorobot/sport.db.more/football-sources/lib" )
    $LOAD_PATH.unshift( "#{root}/yorobot/sport.db.more/webget-football/lib" )


    ### todo/fix: use an inline Gemfile and bundler's setup? why? why not?
    $LOAD_PATH.unshift( "#{root}/yorobot/sport.db.more/sportdb-exporters/lib" )
    $LOAD_PATH.unshift( "#{root}/yorobot/sport.db.more/sportdb-writers/lib" )
    $LOAD_PATH.unshift( "#{root}/yorobot/sport.db.more/sportdb-linters/lib" )

    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/sports/lib" )

    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/sportdb-importers/lib" )
    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/sportdb-readers/lib" )
    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/sportdb-sync/lib" )
    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/sportdb-models/lib" )
    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/sportdb-catalogs/lib" )

    ## todo/check:
    ##   add fifa, footballdb-leagues, footballdb-clubs too ???
    $LOAD_PATH.unshift( "#{root}/sportdb/football.db/footballdb-clubs/lib" )
    $LOAD_PATH.unshift( "#{root}/sportdb/football.db/footballdb-leagues/lib" )
    $LOAD_PATH.unshift( "#{root}/sportdb/football.db/fifa/lib" )

    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/sportdb-formats/lib" )
    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/sportdb-structs/lib" )
    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/sportdb-langs/lib" )
    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/score-formats/lib" )

    $LOAD_PATH.unshift( "#{root}/rubycoco/core/date-formats/lib" )
    $LOAD_PATH.unshift( "#{root}/rubycoco/core/alphabets/lib" )

    pp $:  # print load path
    end  # method setup
end # module Boot
end # module Sportdb



##
## todo/fix: add path support (W/O using global constants) for:
##    - SPORTDB_DIR       e.g. "#{SportDb::Boot.root}/sportdb"       -- path to libs
##    - OPENFOOTBALL_DIR  e.g. "#{SportDb::Boot.root}/openfootball"  -- path to datasets


### use something like SportDb::Path[:sportdb]
##                     SportDb.path( :sportdb )
##                     SportDb::Boot.sportdb_path or sportdb_dir or such???
##                     SportDb::Env.path( 'sportdb' )  ???
##                     SportDb::Env::SPORTDB_DIR ???
##                     or such - why? why not?
##
##  check rails path setup / style or others???


##################
### say hello - use version (meta/module) info
require 'sportdb/setup/version'
puts "#{SportDb::Module::Boot.banner} in (#{SportDb::Module::Boot.root})"
