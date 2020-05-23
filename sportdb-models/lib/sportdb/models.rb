# encoding: utf-8


# core and stlibs  (note: get included via worlddb-models gem; see worlddb-models gem/lib)
require 'worlddb/models'     # NOTE: include worlddb-models gem (not cli tools gem, that is, worlddb)
require 'persondb/models'


# our own code

require 'sportdb/version'    # let version always go first

require 'sportdb/patterns'
require 'sportdb/models/forward'
require 'sportdb/models/world/city'
require 'sportdb/models/world/country'
require 'sportdb/models/world/continent'
require 'sportdb/models/world/state'
require 'sportdb/models/assoc'
require 'sportdb/models/assoc_assoc'
require 'sportdb/models/badge'
require 'sportdb/models/event'
require 'sportdb/models/event_ground'
require 'sportdb/models/event_team'
require 'sportdb/models/game'
require 'sportdb/models/goal'
require 'sportdb/models/ground'
require 'sportdb/models/group'
require 'sportdb/models/group_team'
require 'sportdb/models/league'
require 'sportdb/models/person'
require 'sportdb/models/roster'
require 'sportdb/models/round'
require 'sportdb/models/season'
require 'sportdb/models/stage'
require 'sportdb/models/stage_team'
require 'sportdb/models/team'
require 'sportdb/models/team_compat'   ### fix/todo: move to compat gem !!!!!


require 'sportdb/models/stats/alltime_standing'
require 'sportdb/models/stats/alltime_standing_entry'
require 'sportdb/models/stats/event_standing'
require 'sportdb/models/stats/event_standing_entry'
require 'sportdb/models/stats/group_standing'
require 'sportdb/models/stats/group_standing_entry'

require 'sportdb/models/utils'   # e.g. GameCursor


require 'sportdb/schema'       # NB: requires sportdb/models (include SportDB::Models)


require 'sportdb/calc'       # fix/todo: obsolete - replace w/ standings
require 'sportdb/standings'

require 'sportdb/deleter'
require 'sportdb/stats'


module SportDb

  def self.create
    CreateDb.new.up
    ConfDb::Model::Prop.create!( key: 'db.schema.sport.version', value: VERSION )
  end

  def self.create_all
    ## build schema - convenience helper
    LogDb.create
    ConfDb.create
    TagDb.create
    WorldDb.create
    PersonDb.create
    SportDb.create
  end

  # delete ALL records (use with care!)
  def self.delete!
    puts '*** deleting sport table records/data...'
    Deleter.new.run
  end # method delete!


  def self.tables
    Stats.new.tables
  end


  def self.connect( config={} )

    if config.empty?
      puts "ENV['DATBASE_URL'] - >#{ENV['DATABASE_URL']}<"

      ### change default to ./sport.db ?? why? why not?
      db = URI.parse( ENV['DATABASE_URL'] || 'sqlite3:///sport.db' )

      if db.scheme == 'postgres'
        config = {
          adapter: 'postgresql',
          host: db.host,
          port: db.port,
          username: db.user,
          password: db.password,
          database: db.path[1..-1],
          encoding: 'utf8'
        }
      else # assume sqlite3
       config = {
         adapter: db.scheme, # sqlite3
         database: db.path[1..-1] # sport.db (NB: cut off leading /, thus 1..-1)
      }
      end
    end

    ## todo/check: use if defined?( JRUBY_VERSION ) instead ??
    if RUBY_PLATFORM =~ /java/ && config[:adapter] == 'sqlite3'
      # quick hack for JRuby sqlite3 support via jdbc
      puts "jruby quick hack - adding jdbc libs for jruby sqlite3 database support"
      require 'jdbc/sqlite3'
      require 'active_record/connection_adapters/jdbc_adapter'
      require 'active_record/connection_adapters/jdbcsqlite3_adapter'
    end

    puts "Connecting to db using settings: "
    pp config
    ActiveRecord::Base.establish_connection( config )
    # ActiveRecord::Base.logger = Logger.new( STDOUT )

    ## if sqlite3 add (use) some pragmas for speedups
    if config[:adapter] == 'sqlite3'
      ## check/todo: if in memory e.g. ':memory:' no pragma needed!!
      con = ActiveRecord::Base.connection
      con.execute( 'PRAGMA synchronous=OFF;' )
      con.execute( 'PRAGMA journal_mode=OFF;' )
      con.execute( 'PRAGMA temp_store=MEMORY;' )
    end
  end


  def self.setup_in_memory_db

    # Database Setup & Config
    ActiveRecord::Base.logger = Logger.new( STDOUT )
    ## ActiveRecord::Base.colorize_logging = false  - no longer exists - check new api/config setting?

    connect( adapter:  'sqlite3',
             database: ':memory:' )

    ## build schema
    create_all
  end # setup_in_memory_db (using SQLite :memory:)


end  # module SportDb


## say hello
puts SportDb::Module::Models.banner   if defined?($RUBYLIBS_DEBUG) && $RUBYLIBS_DEBUG
