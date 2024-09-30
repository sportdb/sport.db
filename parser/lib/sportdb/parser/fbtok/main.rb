
module Fbtok
def self.main( args=ARGV )

    opts = {
        debug: true,
        metal: false,
        file:  nil,
    }

    parser = OptionParser.new do |parser|
      parser.banner = "Usage: #{$PROGRAM_NAME} [options] PATH"


      parser.on( "-q", "--quiet",
                 "less debug output/messages - default is (#{!opts[:debug]})" ) do |debug|
        opts[:debug] = false
      end
      parser.on( "--verbose", "--debug",
                   "turn on verbose / debug output (default: #{opts[:debug]})" ) do |debug|
        opts[:debug] = true
      end

      parser.on( "--metal",
                     "turn off typed parse tree; show to the metal tokens"+
                       " (default: #{opts[:metal]})" ) do |metal|
        opts[:metal] = true
      end

      parser.on( "-f FILE", "--file FILE",
                    "read datafiles (pathspecs) via .csv file") do |file|
        opts[:file] = file
        ## note: for batch (massive) processing auto-set debug (verbose output) to false (as default)
        opts[:debug] = false
      end
    end
    parser.parse!( args )

    puts "OPTS:"
    p opts
    puts "ARGV:"
    p args


    ## todo/check - use packs or projects or such
    ##                instead of specs - why? why not?
    specs = []
    if opts[:file]
          recs = read_csv( opts[:file] )
          pp recs
          ##  note - make pathspecs relative to passed in file arg!!!
          basedir = File.dirname( opts[:file] )
          recs.each do |rec|
             paths = SportDb::Parser::Opts.find( rec['path'], dir: basedir )
             specs << [paths, rec]
          end
    else
       paths = if args.empty?
                 [
                   '../../../openfootball/euro/2021--europe/euro.txt',
                   '../../../openfootball/euro/2024--germany/euro.txt',
                 ]
              else
                ## check for directories
                ##   and auto-expand
                SportDb::Parser::Opts.expand_args( args )
              end
        specs << [paths, {}]
    end


    SportDb::Parser::Linter.debug = true    if opts[:debug]

    linter = SportDb::Parser::Linter.new


    specs.each_with_index do |(paths, rec),i|
       errors = []

       paths.each_with_index do |path,j|
          puts "==> [#{j+1}/#{paths.size}] reading >#{path}<..."
          linter.read( path, parse: !opts[:metal] )

          errors += linter.errors    if linter.errors?
       end

       if errors.size > 0
          puts
          pp errors
          puts
          puts "!!   #{errors.size} parse error(s) in #{paths.size} datafiles(s)"
       else
          puts
          puts "OK   no parse errors found in #{paths.size} datafile(s)"
       end

       ## add errors to rec via rec['errors'] to allow
       ##   for further processing/reporting
       rec['errors'] = errors
    end


###
## generate a report if --file option used
if opts[:file]

  buf = String.new

  buf << "# fbtok summary report - #{specs.size} dataset(s)\n\n"

  specs.each_with_index do |(paths, rec),i|
     errors = rec['errors']

     if errors.size > 0
       buf << "!! #{errors.size} ERROR(S)  "
     else
       buf << "   OK          "
     end
     buf << "%-20s" % rec['path']
     buf << " - #{paths.size} datafile(s)"
     buf << "\n"

     if errors.size > 0
         buf << errors.pretty_inspect
         buf << "\n"
     end
 end

  puts
  puts "SUMMARY:"
  puts buf

  #  maybe write out in the future?
  # basedir  = File.dirname( opts[:file] )
  # basename = File.basename( opts[:file], File.extname( opts[:file] ))
end



end  # method self.main
end  #  module Fbtok