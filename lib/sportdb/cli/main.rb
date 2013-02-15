# encoding: utf-8

require 'commander/import'
require 'sportdb'

program :name,  'sportdb'
program :version, SportDB::VERSION
program :description, "sport.db command line tool, version #{SportDB::VERSION}"


# default_command :help
default_command :load

program :help_formatter, Commander::HelpFormatter::TerminalCompact

## program :help, 'Examples', 'yada yada -try multi line later'

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
myopts = SportDB::Opts.new

### global option (required)
global_option '-i', '--include PATH', String, "Data path (default is #{myopts.data_path})"


def connect_to_db
  puts SportDB.banner

  puts "working directory: #{Dir.pwd}"
 
  db_config = {
    :adapter  => 'sqlite3',
    :database => "./sport.db"
  }
  
  puts "Connecting to db using settings: "
  pp db_config

  ActiveRecord::Base.establish_connection( db_config )
end


command :create do |c|
  c.syntax = 'sportdb create [options]'
  c.description = 'Create DB schema'
  c.action do |args, options|
    connect_to_db
    
    LogDB.create
    WorldDB.create
    SportDB.create
    puts 'Done.'
  end # action
end # command create

command :setup do |c|
  c.syntax = 'sportdb setup [options]'
  c.description = "Create DB schema 'n' load all data"

  c.option '--world', 'Populate world tables'
  ## todo: use --world-include - how? find better name?
  c.option '--worldinclude PATH', String, 'World data path'

  c.option '--sport', 'Populate sport tables'
  c.option '--delete', 'Delete all records'

  c.action do |args, options|
    connect_to_db
    myopts.merge_commander_options!( options )
    
    if options.world.present? || options.sport.present?
      
      ## todo: check order for reference integrity
      #  not really possible to delete world data if sport data is present
      #   delete sport first
      
      if options.delete.present?
        SportDB.delete! if options.sport.present?
        WorldDB.delete! if options.world.present?
      end
      
      if options.world.present?
        WorldDB.read_all( myopts.world_data_path )
      end
      if options.sport.present?
        SportDB.read_all( myopts.data_path )
      end

    else  # assume "plain" regular setup
      LogDB.create
      WorldDB.create
      SportDB.create
    
      WorldDB.read_all( myopts.world_data_path )
      SportDB.read_all( myopts.data_path )
    end
    puts 'Done.'
  end # action
end  # command setup

command :load do |c|
  ## todo: how to specify many fixutes <>... ??? in syntax
  c.syntax = 'sportdb load [options] <fixtures>'
  c.description = 'Load fixtures'

  c.option '-e', '--event KEY', String, 'Event to load'
  c.option '--delete', 'Delete all records'

  c.action do |args, options|
    connect_to_db
    myopts.merge_commander_options!( options )
    
    SportDB.delete! if options.delete.present?

    SportDB::Reader.new( logger ).run( myopts, args )  # load/read plain text fixtures
    
    puts 'Done.'
  end
end # command load


command :stats do |c|
  c.syntax = 'sportdb stats [options]'
  c.description = 'Show stats'
  c.action do |args, options|
    connect_to_db
    
    SportDB.stats
    
    puts 'Done.'
  end
end


command :test do |c|
  c.syntax = 'sportdb test [options]'
  c.description = 'Debug/test command suite'
  c.action do |args, options|
    puts "hello from test command"
    puts "args (#{args.class.name}):"
    pp args
    puts "options:"
    pp options
    puts "options.__hash__:"
    pp options.__hash__
    puts 'Done.'
  end
end
