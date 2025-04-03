
# our own code
require_relative 'models_v2/version'    # let version always go first

=begin
require_relative 'models/formats'
require_relative 'models/models/forward'

require_relative 'models/models/world/city'
require_relative 'models/models/world/country'
require_relative 'models/models/world/continent'
require_relative 'models/models/world/state'

require_relative 'models/models/assoc'
require_relative 'models/models/badge'
require_relative 'models/models/event'
require_relative 'models/models/goal'
require_relative 'models/models/ground'
require_relative 'models/models/group'
require_relative 'models/models/league'
require_relative 'models/models/lineup'
require_relative 'models/models/match'
require_relative 'models/models/person'
require_relative 'models/models/round'
require_relative 'models/models/season'
require_relative 'models/models/stage'
require_relative 'models/models/team'

require_relative 'models/models/stats/alltime_standing'
require_relative 'models/models/stats/event_standing'
require_relative 'models/models/stats/group_standing'

require_relative 'models/schema'       # note: requires sportdb/models (include SportDB::Models)

require_relative 'models/utils'   # e.g. MatchCursor

require_relative 'models/deleter'
require_relative 'models/stats'
=end


module SportDbV2

  def self.create
    CreateDb.new.up
    ConfDb::Model::Prop.create!( key: 'db.schema.sport.version', value: VERSION )
  end

  def self.create_all
    ## build schema - convenience helper
    LogDb.create
    ConfDb.create
    SportDbV2.create
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

    unless SportDbV2::Model::League.table_exists?
      SportDbV2.create
    end
  end # method auto_migrate!

=begin
  # delete ALL records (use with care!)
  def self.delete!
    puts '*** deleting sport table records/data...'
    Deleter.new.run
  end # method delete!
=end

  def self.tables
    Stats.new.tables
  end


  ###  use/change to **config - to allow "inline" conif with keywords
  ##          (without enclosing {}) - why? why not?
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



  def self.open( path )  ## shortcut for sqlite only
    config = {
      adapter:  'sqlite3',
      database: path  # e.g. ':memory', './sport.db'
    }
    connect!( config )
  end

  def self.setup_in_memory_db
    # Database Setup & Config
    ##  add logger as option - why? why not?
    ##  e.g.  open_mem( logger: true ) or
    ##         always possible to add logger "manually" before 
    ##         thus, no need for option/flag really ??
    ## ActiveRecord::Base.logger = Logger.new( STDOUT )
    ## ActiveRecord::Base.colorize_logging = false  - no longer exists - check new api/config setting?
   
    config = {
      adapter:  'sqlite3',
      database: ':memory:'
    }
    connect( config )

    ## build schema
    create_all
  end # setup_in_memory_db (using SQLite :memory:)


  ###########
  #   add more aliases/alt names for in memory db - why? why not?
  ##    rename to open_mem for canonical name - why? why not?
  class << self
     alias_method :open_mem,       :setup_in_memory_db
     alias_method :open_memory,    :setup_in_memory_db
     alias_method :open_in_memory, :setup_in_memory_db
  end
end  # module SportDb


## say hello
puts SportDbV2::Module::Models.banner


