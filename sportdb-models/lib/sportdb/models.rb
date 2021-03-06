# core and stlibs  (note: get included via worlddb-models gem; see worlddb-models gem/lib)
require 'worlddb/models'     # NOTE: include worlddb-models gem (not cli tools gem, that is, worlddb)
require 'persondb/models'


# our own code

require 'sportdb/models/version'    # let version always go first

require 'sportdb/models/formats'
require 'sportdb/models/models/forward'

require 'sportdb/models/models/world/city'
require 'sportdb/models/models/world/country'
require 'sportdb/models/models/world/continent'
require 'sportdb/models/models/world/state'

require 'sportdb/models/models/assoc'
require 'sportdb/models/models/badge'
require 'sportdb/models/models/event'
require 'sportdb/models/models/goal'
require 'sportdb/models/models/ground'
require 'sportdb/models/models/group'
require 'sportdb/models/models/league'
require 'sportdb/models/models/lineup'
require 'sportdb/models/models/match'
require 'sportdb/models/models/person'
require 'sportdb/models/models/round'
require 'sportdb/models/models/season'
require 'sportdb/models/models/stage'
require 'sportdb/models/models/team'

require 'sportdb/models/models/stats/alltime_standing'
require 'sportdb/models/models/stats/event_standing'
require 'sportdb/models/models/stats/group_standing'

require 'sportdb/models/schema'       # note: requires sportdb/models (include SportDB::Models)

require 'sportdb/models/utils'   # e.g. MatchCursor

require 'sportdb/models/deleter'
require 'sportdb/models/stats'


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

  def self.auto_migrate!
    ### todo/fix:
    ##    check props table and versions!!!!!

    # first time? - auto-run db migratation, that is, create db tables
    unless LogDb::Model::Log.table_exists?
      LogDb.create     # add logs table
    end

    unless ConfDb::Model::Prop.table_exists?
      ConfDb.create    # add props table
    end


    unless TagDb::Model::Tag.table_exists?
      TagDb.create    # add tags & taggings tables
    end

    unless WorldDb::Model::Place.table_exists?
      WorldDb.create   # add places, & co. tables
    end

    unless PersonDb::Model::Person.table_exists?
      PersonDb.create  # add persons table
    end

    unless SportDb::Model::League.table_exists?
      SportDb.create
    end
  end # method auto_migrate!


  # delete ALL records (use with care!)
  def self.delete!
    puts '*** deleting sport table records/data...'
    Deleter.new.run
  end # method delete!


  def self.tables
    Stats.new.tables
  end


  def self.connect!( config={} )  # convenience shortcut w/ automigrate
    connect( config )
    auto_migrate!
  end

  def self.connect( config={} )
    if config.empty?
      puts "ENV['DATBASE_URL'] - >#{ENV['DATABASE_URL']}<"

      ### change default to ./sport.db ?? why? why not?
      db = URI.parse( ENV['DATABASE_URL'] || 'sqlite3:///sport.db' )

      config =  if db.scheme == 'postgres'
                    { adapter: 'postgresql',
                      host:     db.host,
                      port:     db.port,
                      username: db.user,
                      password: db.password,
                      database: db.path[1..-1],
                      encoding: 'utf8'
                    }
                  else # assume sqlite3
                    { adapter:  db.scheme,       # sqlite3
                      database: db.path[1..-1]   # sport.db (NB: cut off leading /, thus 1..-1)
                    }
                  end
    else
      ## note: for compatibility lets you also pass-in/use string keys
      ##   e.g. YAML.load uses/returns always string keys - always auto-convert to symbols
      config = config.symbolize_keys
    end


    ## todo/check/fix: move jruby "hack" to attic - why? why not?
    ## todo/check: use if defined?( JRUBY_VERSION ) instead ??
    ## if RUBY_PLATFORM =~ /java/ && config[:adapter] == 'sqlite3'
      # quick hack for JRuby sqlite3 support via jdbc
    ##  puts "jruby quick hack - adding jdbc libs for jruby sqlite3 database support"
    ##  require 'jdbc/sqlite3'
    ##  require 'active_record/connection_adapters/jdbc_adapter'
    ##  require 'active_record/connection_adapters/jdbcsqlite3_adapter'
    ## end

    puts "Connecting to db using settings: "
    pp config
    ActiveRecord::Base.establish_connection( config )
    # ActiveRecord::Base.logger = Logger.new( STDOUT )

    ## if sqlite3 add (use) some pragmas for speedups
    if config[:adapter]  == 'sqlite3'  &&
       config[:database] != ':memory:'
      ## note: if in memory database e.g. ':memory:' no pragma needed!!
      ## try to speed up sqlite
      ##   see http://www.sqlite.org/pragma.html
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



module SportDb
  module Model
##################
#  add alias why? why not?
#
#  more aliases to consider:
#   - Tournament for Event?
#   - Cup for League?
#   - Roster for Lineup?
#   - Stadium for Ground?  - why? why not?


Competition = Event
Comp        = Event

LineUp = Lineup
Squad  = Lineup

Game = Match  ## add (old) alias - why? why not?
  end # module Model
end # module SportDb



## say hello
puts SportDb::Module::Models.banner


