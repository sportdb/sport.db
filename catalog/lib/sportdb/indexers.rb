require 'cocos'


require 'active_record'   ## todo: add sqlite3? etc.

require 'sportdb/structs'
require 'sportdb/search'
require 'sportdb/helpers'  ## pulls in search
## require 'sportdb/formats'


## our own code
require_relative 'indexers/schema'
require_relative 'indexers/models'

require_relative 'indexers/indexer'
require_relative 'indexers/country_indexer'
require_relative 'indexers/national_team_indexer'
require_relative 'indexers/club_indexer'
require_relative 'indexers/league_indexer'
require_relative 'indexers/event_indexer'

require_relative 'indexers/ground_indexer'


####
#  db support

module CatalogDb

##
##  configuration support for options
##    e.g. use (world) city (records)? or "vanilla" strings
##              city = true|false
##
##
class Configuration
    ### note - by default use (world) city (records)
    ##           and not "vanilla" strings
    def city?()  defined?(@city) ? @city : true; end
    def city=(value) @city = value; end
end # class Configuration

## lets you use
##   CatalogtDb.configure do |config|
##      config.city = false
##   end
def self.configure()  yield( config ); end
def self.config()  @config ||= Configuration.new;  end




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



## add more (catalog/reference) dbs (schemas) support
require_relative 'dbs/leagues'
require_relative 'dbs/clubs'

require_relative 'players/schema'
require_relative 'players/models'
require_relative 'players/player_reader'
require_relative 'players/player_indexer'

require_relative 'players/player_update_reader'
require_relative 'players/player_update_indexer'
require_relative 'players/national_squad_reader'

