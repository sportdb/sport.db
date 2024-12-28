
module Fbgen
def self.main( args=ARGV )

opts = {
  source_path: [],
  dry:      false,
  debug:    true,
  file:     nil,
}

parser = OptionParser.new do |parser|
  parser.banner = "Usage: #{$PROGRAM_NAME} [options] [args]"

    parser.on( "--dry",
                "dry run; do NOT write - default is (#{opts[:dry]})" ) do |dry|
      opts[:dry] = true
    end
    parser.on( "-q", "--quiet",
               "less debug output/messages - default is (#{!opts[:debug]})" ) do |debug|
      opts[:debug] = false
    end

    parser.on( "-I DIR", "--include DIR",
                "add directory to (source) search path - default is (#{opts[:source_path].join(',')})") do |dir|
      opts[:source_path] += path
    end

    parser.on( "-f FILE", "--file FILE",
                "read leagues (and seasons) via .csv file") do |file|
      opts[:file] = file
    end
end
parser.parse!( args )



if opts[:source_path].empty? &&
  File.exist?( '/sports/cache.api.fbdat')  &&
  File.exist?( '/sports/cache.wfb' )
    opts[:source_path] << '/sports/cache.api.fbdat'
    opts[:source_path] << '/sports/cache.wfb'
end


if opts[:source_path].empty?
  opts[:source_path] = ['.']    ## use ./ as default
end

source_path = opts[:source_path]


puts "OPTS:"
p opts
puts "ARGV:"
p args


datasets =   if opts[:file]
                  read_datasets( opts[:file] )
             else
                  parse_datasets_args( args )
             end

puts "datasets:"
pp datasets



root_dir =  './o'
puts "  (output) root_dir: >#{root_dir}<"


### step 0 - validate and fill-in seasons etc.
validate_datasets!( datasets, source_path: source_path )

## step 1 - generate
datasets.each do |league_key, seasons|
    puts "==> gen #{league_key} - #{seasons.size} seasons(s)..."

    league_info = Writer::LEAGUES[ league_key ]
    pp league_info

    seasons.each do |season|
      filename = "#{season.to_path}/#{league_key}.csv"
      path = find_file( filename, path: source_path )

      ## get matches
      puts "  ---> reading matches in #{path} ..."
      matches = SportDb::CsvMatchParser.read( path )
      puts "     #{matches.size} matches"

      ## build
      txt = SportDb::TxtMatchWriter.build( matches )
      puts txt   if opts[:debug]

      league_name  = league_info[ :name ]      # e.g. Brasileiro Série A
      league_name =  league_name.call( season )   if league_name.is_a?( Proc )  ## is proc/func - name depends on season

      buf = String.new
      buf << "= #{league_name} #{season}\n\n"
      buf << txt

      outpath = "#{root_dir}/foot/#{season.to_path}/#{league_key}.txt"

      if opts[:dry]
        puts "   (dry) writing to >#{outpath}<..."
      else
        write_text( outpath, buf )
      end
    end
end
end  # method self.main



def self.find_file( filename, path: )
    path.each do |src_dir|
       path = "#{src_dir}/#{filename}"
       return path   if File.exist?( path )
    end

    ##  fix - raise file not found error!!!
    nil  ## not found - raise filenot found error - why? why not?
end


### use a function for (re)use
###   note - may add seasons in place!! (if seasons is empty)
def self.validate_datasets!( datasets, source_path: )
  datasets.each do |dataset|
    league_key, seasons = dataset

    league_info = Writer::LEAGUES[ league_key ]
    if league_info.nil?
      puts "!! ERROR - no league (config) found for >#{league_key}<; sorry"
      exit 1
    end


    if seasons.empty?
      ## simple heuristic to find current season
      [ Season( '2024/25'), Season( '2024') ].each do |season|
         filename = "#{season.to_path}/#{league_key}.csv"
         path = find_file( filename, path: source_path )
         if path
            seasons = [season]
            dataset[1] = seasons
            break
         end
      end

      if seasons.empty?
        puts "!! ERROR - no latest auto-season via source found for #{league_key}; sorry"
        exit 1
      end
    end

    ## check source path too upfronat - why? why not?
    seasons.each do |season|
         filename = "#{season.to_path}/#{league_key}.csv"
         path = find_file( filename, path: source_path )

         if path.nil?
           puts "!! ERROR - no source found for #{filename}; sorry"
           exit 1
         end
    end
  end
  datasets
end
end  # module Fbgen
