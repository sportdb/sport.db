
module SportDb
class Parser


###
## note - Opts Helpers for now nested inside Parser - keep here? why? why not?
class Opts

    SEASON_RE = %r{ (?:
                       \d{4}-\d{2}
                     | \d{4}(--[a-z0-9_-]+)?
                    )
                  }x
    SEASON = SEASON_RE.source    ## "inline" helper for embedding in other regexes - keep? why? why not?


    ## note: if pattern includes directory add here
    ##     (otherwise move to more "generic" datafile) - why? why not?
    ##   update - note include/allow dot (.) too
    ##               e.g. 2024-25/at.1.txt
    ##                        change to at_1 or uefa_cl or such - why? why not?
    MATCH_RE = %r{ (?: ^|/ )      # beginning (^) or beginning of path (/)
                       #{SEASON}
                     /[a-z0-9_.-]+\.txt$  ## txt e.g /1-premierleague.txt
                }x


def self.find( path, dir: nil )
    ## check - rename dir
    ##          use root_dir or work_dir or cd or such - why? why not?

    datafiles = []

    ## note: normalize path - use File.expand_path ??
    ##    change all backslash to slash for now
    ## path = path.gsub( "\\", '/' )
    path =  if dir
              File.expand_path( path, File.expand_path( dir ))
            else
              File.expand_path( path )
            end

    ## check all txt files
    ## note: incl. files starting with dot (.)) as candidates
    ##     (normally excluded with just *)
    candidates = Dir.glob( "#{path}/**/{*,.*}.txt" )
    ## pp candidates
    candidates.each do |candidate|
      datafiles << candidate    if MATCH_RE.match( candidate )
    end

    ## pp datafiles
    datafiles
end


def self.expand_args( args )
    paths = []

    args.each do |arg|
        ## check if directory
        if Dir.exist?( arg )
            datafiles = find( arg )
            puts
            puts "  found #{datafiles.size} match txt datafiles in #{arg}"
            pp datafiles
            paths += datafiles
        else
              ## assume it's a file
            paths << arg
        end
    end

    paths
end
end  # class Opts


end   # class Parser
end   # module SportDb