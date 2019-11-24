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

    SportDb.create_all

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

    if o[:delete].present?
      SportDb.delete!
      SportDb.read_builtin    # NB: reload builtins (e.g. seasons etc.)
    end

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

    if o[:delete].present?
      SportDb.delete!
      SportDb.read_builtin    # NB: reload builtins (e.g. seasons etc.)
    end

    reader = SportDb::Reader.new( opts.data_path )

    args.each do |arg|
      name = arg     # File.basename( arg, '.*' )
      reader.load( name )
    end # each arg

    puts 'Done.'
  end
end # command load


if defined?( SportDb::Updater )   ## add only if Updater class loaded/defined

desc 'Pull - Auto-update event fixtures from upstream online sources'
command :pull do |c|
  c.action do |g,o,args|

    connect_to_db( opts )

    SportDb.update!

    puts 'Done.'
  end # action
end # command pull

end  ## if defined?( SportDb::Updater )
