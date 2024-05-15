

require 'active_record'   ## todo: add sqlite3? etc.

require 'sportdb/structs'
require 'sportdb/catalogs'
require 'sportdb/formats'


## our own code
require_relative 'indexers/schema'
require_relative 'indexers/models'

require_relative 'indexers/indexer'
require_relative 'indexers/country_indexer'
require_relative 'indexers/national_team_indexer'
require_relative 'indexers/club_indexer'
require_relative 'indexers/league_indexer'



####
#  db support

module CatalogDb


def self.open( path='./catalog.db' )
    config = {
        adapter:  'sqlite3',
        database: path,
    }

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
    unless Model::Country.table_exists?
        CreateDb.new.up
    end

    ##  quick hack???  
    ## note: set "system" catalog to use this db too
    ##   required for all non-country indexers!!!!!

    ## todo/fix - check how and if possible with :memory: ??
    ##   can share connection to memory db? how?
    SportDb::Import.config.catalog_path = path
    ## check records counts
    puts "  #{Metal::Country.count} countries" 
    puts "  #{Metal::League.count} leagues" 
end
end    # module CatalogDb

