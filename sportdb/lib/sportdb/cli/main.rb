# encoding: utf-8

### NOTE: wrap gli config into a class
##  see github.com/davetron5000/gli/issues/153


module SportDb

  class Tool
     def initialize
       LogUtils::Logger.root.level = :info   # set logging level to info
     end

     def run( args )
       puts SportDbCli.banner
       Toolii.run( args )
     end
  end


  class Toolii
    extend GLI::App

   def self.logger=(value) @@logger=value; end
   def self.logger()       @@logger; end

   ## todo: find a better name e.g. change to settings? config? safe_opts? why? why not?
   def self.opts=(value)  @@opts = value; end
   def self.opts()        @@opts; end

   def self.connect_to_db( options )
     puts "working directory: #{Dir.pwd}"

     SportDb.connect( adapter: 'sqlite3',
                      database: "#{options.db_path}/#{options.db_name}" )

     LogDb.setup  # start logging to db (that is, save logs in logs table in db)
   end


logger = LogUtils::Logger.root
opts   = SportDb::Opts.new


program_desc 'sport.db command line tool'

version SportDbCli::VERSION


### global option (required)
## todo: add check that path is valid?? possible?

desc 'Database path'
arg_name 'PATH'
default_value opts.db_path
flag [:d, :dbpath]

desc 'Database name'
arg_name 'NAME'
default_value opts.db_name
flag [:n, :dbname]

desc 'Datafile'
arg_name 'FILE'
default_value opts.datafile
flag [:f, :datafile]

desc 'Leagues dir'
arg_name 'PATH'
default_value nil
flag [:'leagues-dir', :leaguesdir]

desc 'Clubs dir'
arg_name 'PATH'
default_value nil
flag [:'clubs-dir', :clubsdir]



desc '(Debug) Show debug messages'
switch [:verbose], negatable: false    ## todo: use -w for short form? check ruby interpreter if in use too?

desc 'Only show warnings, errors and fatal messages'
switch [:q, :quiet], negatable: false



desc 'Create DB schema'
command [:create] do |c|
  c.action do |g,o,args|

    connect_to_db( opts )

    SportDb.create_all

    puts 'Done.'
  end # action
end # command create


desc "Build DB (download/create/read); use ./Datafile - zips get downloaded to ./tmp"
command [:build,:b] do |c|

  c.action do |g,o,args|

    ## check if datafile exists, if NOT assume working dir (./) is a package
    if File.file?( opts.datafile )   ## note use file? (exist? will also check for directory/folder!!)
      datafile = Datafile::Datafile.load_file( opts.datafile )
      datafile.download  # datafile step 1 - download all datasets/zips

      connect_to_db( opts )

      SportDb.create_all

      datafile.read  # datafile step 2 - read all datasets
    else
      puts "no datafile >#{opts.datafile}< found; trying local build in >#{Dir.pwd}<"

      connect_to_db( opts )

      SportDb.create_all
      pack = SportDb::DirPackage.new( Dir.pwd )  ## note: pass in full path for now (and NOT ./) - why? why not?
      pack.read   # read all datasets
    end

    puts 'Done.'
  end # action
end  # command setup


desc "Read datasets; use ./Datafile - zips required in ./tmp"
command [:read,:r] do |c|

  c.action do |g,o,args|

    ## check if datafile exists, if NOT assume working dir (./) is a package
    if File.file?( opts.datafile )   ## note use file? (exist? will also check for directory/folder!!)
      connect_to_db( opts )

      datafile = Datafile::Datafile.load_file( opts.datafile )
      datafile.read
    else
      puts "no datafile >#{opts.datafile}< found; trying local read in >#{Dir.pwd}<"

      connect_to_db( opts )

      pack = SportDb::DirPackage.new( Dir.pwd )  ## note: pass in full path for now (and NOT ./) - why? why not?
      pack.read   # read all datasets
    end

    puts 'Done.'
  end # action
end  # command setup


desc "Download datasets; use ./Datafile - zips get downloaded to ./tmp"
command [:download,:dl] do |c|

  c.action do |g,o,args|

    # note: no database connection needed (check - needed for logs?? - not setup by default???)

    datafile = Datafile::Datafile.load_file( opts.datafile )
    datafile.download

    puts 'Done.'
  end # action
end  # command setup


desc "Build DB w/ quick starter Datafile templates"
arg_name 'NAME'   # optional setup profile name
command [:new,:n] do |c|

  c.action do |g,o,args|

    ## todo: required template name (defaults to eng2019-20) -- was worldcup2018
    setup = args[0] || 'eng2019-20'

    worker = Fetcher::Worker.new
    worker.copy( "https://github.com/openfootball/datafile/raw/master/#{setup}.rb", './Datafile' )

    ## todo/check: use custom datafile (opts.datafile) if present? why? why not?

    ## step 2: same as command build (todo - reuse code)
    datafile = Datafile::Datafile.load_file( './Datafile' )
    datafile.download  # datafile step 1 - download all datasets/zips

    connect_to_db( opts )  ### todo: check let connect go first?? - for logging (logs) to db  ???

    SportDb.create_all

    datafile.read  # datafile step 2 - read all datasets

    puts 'Done.'
  end # action
end  # command setup


desc 'Start web service (HTTP JSON API)'
arg_name 'NAME'   # optional setup profile name
command [:serve,:server,:s] do |c|

  c.action do |g,o,args|

    ## todo: document optional script arg (defaults to service)
    script = args[0] || 'service'

    ## todo/fix: add support for (default) Service (with no extension)

    script_path = "#{script}.rb"     ## auto-add .rb extension

    unless File.exist?( script_path ) ## if file doesn't exist try to fetch service script
      script_path = "./#{script}.rb"   ## use / save script in local (current) working dir/folder
      worker = Fetcher::Worker.new
      ## note: lets use http:// instead of https:// for now - lets us use person proxy (NOT working w/ https for now)
      worker.copy( "http://github.com/sportdb/sport.db.service/raw/master/#{script}.rb", script_path )
    end


    code = File.open( script_path, 'r:utf-8' ) { |f| f.read }

    connect_to_db( opts )

    SportDb.tables   ## print table stats

    SportDbService.class_eval( code )  ## note: MUST use class_eval (do NOT use instance_eval)  !!!

    puts "dump routes:"
    pp SportDbService.routes

    puts "starting server..."
    SportDbService.run!

    puts 'Done.'
  end
end # command serve




desc 'Show logs'
command :logs do |c|
  c.action do |g,o,args|

    connect_to_db( opts )

    LogDb::Model::Log.all.each do |log|
      puts "[#{log.level}] -- #{log.msg}"
    end

    puts 'Done.'
  end
end


desc 'Show stats'
command :stats do |c|
  c.action do |g,o,args|

    connect_to_db( opts )

    SportDb.tables
    WorldDb.tables

    puts 'Done.'
  end
end


desc 'Show props'
command :props do |c|
  c.action do |g,o,args|

    connect_to_db( opts )

    ### fix: SportDb.props
    ##  use ConfDb.props or similar!!!

    puts 'Done.'
  end
end


desc '(Debug) Test command suite'
command :test do |c|
  c.action do |g,o,args|

    puts "hello from test command"
    puts "args (#{args.class.name}):"
    pp args
    puts "o (#{o.class.name}):"
    pp o
    puts "g (#{g.class.name}):"
    pp g

    logger = LogUtils::Logger.root
    logger.debug 'test debug msg'
    logger.info 'test info msg'
    logger.warn 'test warn msg'

    puts 'Done.'
  end
end



pre do |g,c,o,args|
  opts.merge_gli_options!( g )
  opts.merge_gli_options!( o )

  puts SportDbCli.banner

  if opts.verbose?
    LogUtils::Logger.root.level = :debug
  end


  if opts.clubs_dir?
    puts "  setting clubs_dir to >#{opts.clubs_dir}<"
    SportDb::Import.config.clubs_dir = opts.clubs_dir
  end

  if opts.leagues_dir?
    puts "  setting leagues_dir to >#{opts.leagues_dir}<"
    SportDb::Import.config.leagues_dir = opts.leagues_dir
  end


  logger.debug "Executing #{c.name}"
  true
end

post do |global,c,o,args|
  logger.debug "Executed #{c.name}"
  true
end


on_error do |e|
  puts
  puts "*** error: #{e.message}"

  if opts.verbose?
    puts e.backtrace
  end

  false # skip default error handling
end


### exit run(ARGV)  ## note: use Toolii.run( ARGV ) outside of class

  end  # class Toolii
end  # module SportDb
