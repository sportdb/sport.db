require 'cocos'


require 'active_record'   ## todo: add sqlite3? etc.

require 'sportdb/structs'
require 'sportdb/catalogs'   # fix - catalogs pulls in foramts already!!
## require 'sportdb/formats'

require 'sportdb/indexers'      ## pull in indexers too - why? why not?


## our own code
require_relative 'players/schema'
require_relative 'players/models'

require_relative 'players/player_reader'
require_relative 'players/player_indexer'




####
#  db support

module CatalogDb
  module PersonDb     ## use nested PersonDb - why? why not?


def self.open( path='./players.db' )
    config = {
        adapter:  'sqlite3',
        database: path,
    }

    ##
    ## todo/fix - check - how to use
    ##    multiple db connections
    ActiveRecord::Base.establish_connection( config )
    # ActiveRecord::Base.logger = Logger.new( STDOUT )

    ## if sqlite3 add (use) some pragmas for speedups
    if config[:database] != ':memory:'
      ## note: if in memory database e.g. ':memory:' no pragma needed!!
      ## try to speed up sqlite
      ##   see http://www.sqlite.org/pragma.html
      con = ActiveRecord::Base.connection
      con.execute( 'PRAGMA synchronous=OFF;' )
      con.execute( 'PRAGMA journal_mode=OFF;' )
      con.execute( 'PRAGMA temp_store=MEMORY;' )
    end

    ##########################
    ### auto_migrate
    unless Model::Person.table_exists?
        CreateDb.new.up
    end
end

end    #  module PersonDb     ## use nested PersonDb - why? why not?
end    # module CatalogDb
