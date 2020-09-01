##########
#  setup load path
#     lets you use environments
#     e.g. dev/development or production


## todo/fix: move later app/gem-family/-specific configs
##   to its own gem e.g. mono-sportdb or such - why? why not?



require_relative '../mono'


## convenience pre-configured/pre-built shortcut - lets you use
##    require 'mono/sportdb'
##    Mono.setup


module Mono
    def self.setup   ## setup load path
### note: for now always assume dev/development
###   add ENV check later or pass in as args or such

    puts "Mono.root: >#{root}<"

    $LOAD_PATH.unshift( "#{root}/yorobot/sport.db.more/sportdb-exporters/lib" )
    $LOAD_PATH.unshift( "#{root}/yorobot/sport.db.more/sportdb-writers/lib" )
    $LOAD_PATH.unshift( "#{root}/yorobot/sport.db.more/sportdb-linters/lib" )

    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/sports/lib" )

    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/sportdb-importers/lib" )
    ## todo - add readers, models, sync, etc.

    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/sportdb-catalogs/lib" )
    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/sportdb-formats/lib" )
    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/sportdb-structs/lib" )
    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/sportdb-langs/lib" )
    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/score-formats/lib" )
    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/date-formats/lib" )


    pp $:  # print load path
  end
end # module Mono


## todo/fix:
##   use
##   module Starter
##    module SportDb
##      def setup ...
##   end
##   end
##
## or such? and use Mono.extend - why? why not?
## module Mono
##   extend Starter::SportDb
## end

