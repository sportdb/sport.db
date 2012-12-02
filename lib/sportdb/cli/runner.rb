
module SportDB

class Runner


## make models available in sportdb module by default with namespace
#  e.g. lets you use Team instead of Models::Team 
  include SportDB::Models

  def initialize
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO

    @opts    = Opts.new
  end

  attr_reader :logger, :opts

  def run( args )
    opt=OptionParser.new do |cmd|
    
      cmd.banner = "Usage: sportdb [options]"


      ## NB: reserve -c for use with -c/--config
      cmd.on( '--create', 'Create DB schema' ) { opts.create = true }
      cmd.on( '--setup', "Create DB schema 'n' load all builtin data" ) { opts.setup = true }

      cmd.on( '--world', "Populate world tables with builtin data (version #{WorldDB::VERSION})" ) { opts.world = true }
      cmd.on( '--sport', "Populate sport tables with builtin data" ) { opts.sport = true }


      cmd.on( '--delete', 'Delete all records' ) { opts.delete = true }
      
      ### todo: in future allow multiple search path??
      cmd.on( '-i', '--include PATH', "Data path (default is #{opts.data_path})" ) { |path| opts.data_path = path }

      cmd.on( '--load', 'Use loader for builtin sports data' ) { opts.load = true }

      cmd.on( '-e', '--event KEY', 'Event to load or generate' ) { |key| opts.event = key; }
      
      cmd.on( '-o', '--output PATH', "Output path (default is #{opts.output_path})" ) { |path| opts.output_path = path }
      cmd.on( '-g', '--generate', 'Generate fixtures from template' ) { opts.generate = true }


      cmd.on( '-v', '--version', "Show version" ) do
        puts SportDB.banner
        exit
      end

      cmd.on( "--verbose", "Show debug trace" )  do
        logger.datetime_format = "%H:%H:%S"
        logger.level = Logger::DEBUG
        
        ActiveRecord::Base.logger = Logger.new(STDOUT)
      end

      cmd.on_tail( "-h", "--help", "Show this message" ) do
        puts <<EOS

sportdb - sport.db command line tool, version #{VERSION}

#{cmd.help}

Examples:
    sportdb cl/teams cl/2012_13/cl                     # import champions league (cl)
    sportdb --create                                   # create database schema

More Examples:
    sportdb                                            # show stats (table counts, table props)
    sportdb -i ../sport.db/db cl/teams cl/2012_13/cl   # import champions league (cl) in db folder

Further information:
  http://geraldb.github.com/sport.db
  
EOS
        exit
      end
    end

    opt.parse!( args )
  
    puts SportDB.banner

    puts "working directory: #{Dir.pwd}"
 
    db_config = {
     :adapter  => 'sqlite3',
     :database => "#{opts.output_path}/sport.db"
    }
  
    puts "Connecting to db using settings: "
    pp db_config

    ActiveRecord::Base.establish_connection( db_config )
    
    if opts.setup?
      WorldDB.create
      SportDB.create
      WorldDB.read_all
      SportDB.load_all  # ruby (.rb) fixtures
      SportDB.read_all  # plain text (.txt) fixtures
    else

      if opts.create?
        WorldDB.create
        SportDB.create
      end

      if opts.world? || opts.sport?
        if opts.world?
          WorldDB.delete! if opts.delete?
          WorldDB.read_all
        end

        if opts.sport?
          SportDB.delete! if opts.delete?
          SportDB.load_all
          SportDB.read_all
        end
      else # no sport or world flag
        if opts.delete?
          SportDB.delete!
          WorldDB.delete!  # countries,regions,cities,tags,taggings,props
        end
      end

      if opts.event.present?
        if opts.generate?
          Templater.new( logger ).run( opts, args ) # export/generate ruby fixtures
        else
          Reader.new( logger ).run( opts, args )  # load/read plain text fixtures
        end
      else
        Loader.new( logger ).run( opts, args ) # load ruby fixtures
      end
    end

    SportDB.stats
    
    puts 'Done.'
    
  end   # method run

end # class Runner
end # module SportDB