# encoding: utf-8

##############
# nb: for local testing use:
#    
#  ruby -I ../../github/sport.db.ruby/lib
#        ../../github/sport.db.ruby/lib/sportdb.rb
#        setup --delete --sport
#        --include ../../github/football.db


require 'gli'
 
include GLI::App

# our own code / additional for cli only

require 'logutils/db'
require 'sportdb/cli/opts'
  
 
program_desc 'sport.db command line tool'

version SportDb::VERSION


LogUtils::Logger.root.level = :info   # set logging level to info 
logger = LogUtils::Logger.root


=begin
### add to help use new sections

Examples:
    sportdb cl/teams cl/2012_13/cl                     # import champions league (cl)
    sportdb --create                                   # create database schema

More Examples:
    sportdb                                            # show stats (table counts, table props)
    sportdb -i ../sport.db/db cl/teams cl/2012_13/cl   # import champions league (cl) in db folder

Further information:
  http://geraldb.github.com/sport.db
=end


## todo: find a better name e.g. change to settings? config? safe_opts? why? why not?
opts = SportDb::Opts.new

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

desc '(Debug) Show debug messages'
switch [:verbose], negatable: false    ## todo: use -w for short form? check ruby interpreter if in use too?

desc 'Only show warnings, errors and fatal messages'
switch [:q, :quiet], negatable: false



def connect_to_db( options )
  puts SportDb.banner

  puts "working directory: #{Dir.pwd}"

  db_config = {
    :adapter  => 'sqlite3',
    :database => "#{options.db_path}/#{options.db_name}"
  }

  puts "Connecting to db using settings: "
  pp db_config

  ActiveRecord::Base.establish_connection( db_config )
  
  LogDb.setup  # start logging to db
end


desc 'Create DB schema'
command [:create] do |c|
  c.action do |g,o,args|
    
    connect_to_db( opts )
    
    LogDb.create
    WorldDb.create
    SportDb.create
    puts 'Done.'
  end # action
end # command create


desc "Create DB schema 'n' load all world and sports data"
arg_name 'NAME'   # optional setup profile name
command [:setup,:s] do |c|

  c.desc 'Sports data path'
  c.arg_name 'PATH'
  c.default_value opts.data_path
  c.flag [:i,:include]

  c.desc 'World data path'
  c.arg_name 'PATH'
  c.flag [:worldinclude]   ## todo: use --world-include - how? find better name? add :'world-include' ???

  c.action do |g,o,args|

    connect_to_db( opts )
 
    ## todo: document optional setup profile arg (defaults to all)
    setup = args[0] || 'all'
    
    LogDb.create
    WorldDb.create
    SportDb.create
    
    WorldDb.read_all( opts.world_data_path )
    SportDb.read_setup( "setups/#{setup}", opts.data_path )
    puts 'Done.'
  end # action
end  # command setup


desc 'Update all sports data'
arg_name 'NAME'   # optional setup profile name
command [:update,:up,:u] do |c|

  c.desc 'Sports data path'
  c.arg_name 'PATH'
  c.default_value opts.data_path
  c.flag [:i,:include]

  c.desc 'Delete all sports data records'
  c.switch [:delete], negatable: false 

  c.action do |g,o,args|

    connect_to_db( opts )

    ## todo: document optional setup profile arg (defaults to all)
    setup = args[0] || 'all'

    SportDb.delete! if o[:delete].present?

    SportDb.read_setup( "setups/#{setup}", opts.data_path )
    puts 'Done.'
  end # action
end  # command setup


desc 'Load sports fixtures'
arg_name 'NAME'   # multiple fixture names - todo/fix: use multiple option
command [:load, :l] do |c|

  c.desc 'Delete all sports data records'
  c.switch [:delete], negatable: false 

  c.action do |g,o,args|

    connect_to_db( opts )
    
    SportDb.delete! if o[:delete].present?

    reader = SportDb::Reader.new( opts.data_path )

    args.each do |arg|
      name = arg     # File.basename( arg, '.*' )
      reader.load( name )
    end # each arg

    puts 'Done.'
  end
end # command load

desc 'Show logs'
command :logs do |c|
  c.action do |g,o,args|

    connect_to_db( opts ) 
    
    LogDb::Models::Log.all.each do |log|
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
    
    puts 'Done.'
  end
end


desc 'Show props'
command :props do |c|
  c.action do |g,o,args|

    connect_to_db( opts )
    
    SportDb.props
    
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
    
    LogUtils::Logger.root.debug 'test debug msg'
    LogUtils::Logger.root.info 'test info msg'
    LogUtils::Logger.root.warn 'test warn msg'
    
    puts 'Done.'
  end
end



pre do |g,c,o,args|
  opts.merge_gli_options!( g )
  opts.merge_gli_options!( o )

  puts SportDb.banner

  if opts.verbose?
    LogUtils::Logger.root.level = :debug
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


exit run(ARGV)