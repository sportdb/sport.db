

module Datafile


  ## todo/fix: move regex patterns upstream to datafile in sportdb-formats!!

  CONF_RE  = %r{ /\.conf\.txt$
               }x

  MATCH_RE = %r{ /\d{4}-\d{2}        ## season folder e.g. /2019-20
                 /[a-z0-9_-]+\.txt$  ## txt e.g /1-premierleague.txt
              }x

  ZIP_RE = %r{ \.zip$
            }x
  def self.match_zip( path, pattern: ZIP_RE ) pattern.match( path ); end



class PackageBase

  ## note: "abstract" methods - each and read required in derived class !!!!

  def each_conf( &blk )   each( pattern: CONF_RE, &blk ); end
  def each_match( &blk )  each( pattern: MATCH_RE, &blk ); end

  def read_conf( season:, sync: )
    read( pattern: CONF_RE ) do |name,txt|
      SportDb.parse_conf( season: season, sync: sync )
    end
  end
  def read_match( season:, sync: )
    read( pattern: MATCH_RE ) do |name, txt|
      SportDb.parse_match( season: season, sync: sync )
    end
  end
end   # class PackageBase



class DirPackage < PackageBase    ## todo/check: find a better name e.g. UnzippedPackage, FilesystemPackage, etc. - why? why not?

  def initialize( path )
    @path = path   ## rename to root_path or base_path or somehting - why? why not?
  end


  def each_file( pattern: )    ## todo/check: rename to glob or something - why? why not?
    ## note: incl. files starting with dot (.)) as candidates (normally excluded with just *)
    Dir.glob( "#{@path}/**/{*,.*}.txt" ).each do |path|
      ## todo/fix: (auto) skip and check for directories
      if pattern.match( path )
        yield( path)
      else
        ## puts "  skipping >#{path}<"
      end
    end
  end


  Entry = Struct.new( :name )

  def each( pattern: )   ## todo/check: rename to each_entry - why? why not?
    each_file( pattern: pattern ) do |path|
      ## fix: split path like a "virtual" zip like entry
      yield( Entry.new( path ) )
    end
  end

  def read( pattern: )
    each_file( pattern: pattern ) do |path|
      txt = File.open( path, 'r:utf-8').read
      yield( path, txt )  ## only pass along txt - why? why not? or pass along entry and not just entry.name?
    end
  end
end  # class DirPackage



## helper wrapper for datafiles in zips
class ZipPackage < PackageBase
  def initialize( path )
    @path = path
  end


  def each( pattern: )
    Zip::File.open( @path ) do |zipfile|
      zipfile.each do |entry|
        if entry.directory?
          next ## skip
        elsif entry.file?
          if pattern.match( entry.name )
            yield( entry )
          else
            ## puts "  skipping >#{entry.name}<"
          end
        else
          puts "** !! ERROR !! #{entry.name} is unknown zip file type, sorry"
          exit 1
        end
      end
    end
  end

  def read( pattern: )
    each( pattern: pattern ) do |entry|
      txt = entry.get_input_stream.read
      ##  puts "** encoding: #{txt.encoding}"  #=> encoding: ASCII-8BIT
      txt = txt.force_encoding( Encoding::UTF_8 )
      yield( "#{@path}!/#{entry.name}", txt )    ## only pass along txt - why? why not? or pass along entry and not just entry.name?
    end
  end
end  # class ZipPackage
end  # module Datafile
