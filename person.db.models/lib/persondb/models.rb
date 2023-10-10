# encoding: utf-8

require 'logger'

# 3rd party gems / libs
require 'worlddb/models'    # note: let worlddb pull in all 3rd party gems / libs (do NOT duplicate here)


### our own code

require 'persondb/version'  # let it always go first
require 'persondb/schema'

require 'persondb/models/forward'

require 'persondb/models/world/city'
require 'persondb/models/world/state'
require 'persondb/models/world/country'

require 'persondb/models/person'
require 'persondb/reader'



module PersonDb

  def self.test_data_path
    "#{root}/test/data"
  end


  def self.create
    CreateDb.new.up

    Model::Prop.create!( key: 'db.schema.person.version', value: VERSION )
  end

  def self.delete!
    ## fix/todo: move into deleter class (see worlddb,sportdb etc.)
    Model::Person.delete_all
  end

  def self.tables
    ## fix/todo: move into stats class (see worlddb,sportdb etc.)
    puts "  #{Model::Person.count} persons"
  end

  def self.setup_in_memory_db
    # Database Setup & Config

    ActiveRecord::Base.logger = Logger.new( STDOUT )
    ## ActiveRecord::Base.colorize_logging = false  - no longer exists - check new api/config setting?

    ## NB: every connect will create a new empty in memory db
    ActiveRecord::Base.establish_connection(
                                  adapter:  'sqlite3',
                                  database: ':memory:' )

    ## build schema
    LogDb.create
    ConfDb.create
    TagDb.create
    WorldDb.create
    PersonDb.create
  end  # method setup_in_memory_db


end  # module PersonDb

# say hello
puts PersonDb.banner  if defined?($RUBYLIBS_DEBUG) && $RUBYLIBS_DEBUG
