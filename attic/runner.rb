

## remove for now generate ruby fixtures options

cmd.on( '-o', '--output PATH', "Output path (default is #{opts.output_path})" ) { |path| opts.output_path = path }
cmd.on( '-g', '--generate', 'Generate fixtures from template' ) { opts.generate = true }


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
    
### remove builtin data path?? no longer shipping with builtin fixtures

cmd.on( '--load', 'Use loader for builtin sports data' ) { opts.load = true }

