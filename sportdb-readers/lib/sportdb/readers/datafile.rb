
require 'zip'


## check if zip file
##  e.g. is a file and matches name pattern/regex

## read (all) conf datafiles first
## read (all) match datafiles next


module Datafile

  CONF_RE  = %r{ /\.conf\.txt$
               }x

  MATCH_RE = %r{ /\d{4}-\d{2}        ## season folder e.g. /2019-20
                 /[a-z0-9_-]+\.txt$  ## txt e.g /1-premierleague.txt
              }x


class PackageBase

  ## note: "abstract" methods - each and read required in derived class !!!!

  def each_conf( &blk )   each( pattern: CONF_RE, &blk ); end
  def each_match( &blk )  each( pattern: MATCH_RE, &blk ); end

  def read_conf( &blk )   read( pattern: CONF_RE, &blk ); end
  def read_match( &blk )  read( pattern: MATCH_RE, &blk ); end
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



# pack = Datafile::DirPackage.new( './austria-master' )
pack = Datafile::ZipPackage.new( './dl/austria-master.zip' )
pack.read_conf do |name,txt|
  puts "reading conf datafile >#{name}<..."
  puts txt
end


pack.each_match do |entry|
  puts "reading match datafile >#{entry.name}<..."
end

pack.read_match do |name,txt|
  puts "reading match datafile >#{name}<..."
end




__END__
Zip::File.open('./dl/austria-master.zip') do |zipfile|
  # Handle entries one by one
  zipfile.each do |entry|
    if entry.directory?
      puts "#{entry.name} is a directory!"
    elsif entry.file?
      puts "#{entry.name} is a file!"

      # Read into memory
      # content = entry.get_input_stream.read

      # Output
      # puts content
    else
      puts "#{entry.name} is something unknown, oops!"
    end
  end
end
