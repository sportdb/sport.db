

module Datafile


  ## todo/fix: move regex patterns upstream to datafile in sportdb-formats!!

  CONF_RE  = %r{ /\.conf\.txt$
               }x

  MATCH_RE = %r{ /\d{4}-\d{2}        ## season folder e.g. /2019-20
                 /[a-z0-9_-]+\.txt$  ## txt e.g /1-premierleague.txt
              }x

  CLUBS_PROPS_RE = %r{  (?:^|/)               # beginning (^) or beginning of path (/)
                         (?:[a-z]{1,4}\.)?   # optional country code/key e.g. eng.clubs.props.txt
                        clubs\.props\.txt$
                     }x
  def self.match_clubs_props( path, pattern: CLUBS_PROPS_RE ) pattern.match( path ); end

  ZIP_RE = %r{ \.zip$
            }x
  def self.match_zip( path, pattern: ZIP_RE ) pattern.match( path ); end



class PackageBase

  ## note: "abstract" methods - each and read required in derived class !!!!

  def each_conf( &blk )   each( pattern: CONF_RE, &blk ); end
  def each_match( &blk )  each( pattern: MATCH_RE, &blk ); end



  def read_clubs_props
    each_read( pattern: CLUBS_PROPS_RE ) do |name, txt|
      ## todo/fix:  add/use SportDb.parse_club_props helper !!!!!!
      SportDb::Import::ClubPropsReader.parse( txt )
    end
  end

  def read_conf( *names,
                 season: nil, sync: true )
    if names.empty?   ## no (entry) names passed in; read in all
      each_read( pattern: CONF_RE ) do |name, txt|
        SportDb.parse_conf( txt, season: season, sync: sync )
      end
    else
      names.each do |name|
        txt = read_entry( name )
        SportDb.parse_conf( txt, season: season, sync: sync )
      end
    end
  end

  def read_match( *names,
                  season: nil, sync: true )
    if names.empty?   ## no (entry) names passed in; read in all
      each_read( pattern: MATCH_RE ) do |name, txt|
        SportDb.parse_match( txt, season: season, sync: sync )
      end
    else
      names.each do |name|
        txt = read_entry( name )
        SportDb.parse_match( txt, season: season, sync: sync )
      end
    end
  end


  def read( *names,
            season: nil, sync: true )
    if names.empty?   ##  read all datafiles
      read_clubs_props()   if sync
      read_conf( season: season, sync: sync )
      read_match( season: season, sync: sync )
    else
      names.each do |name|
        txt = read_entry( name )
        ## fix/todo: add read_clubs_props too!!!
        if Datafile.match_conf( name )      ## check if datafile matches conf(iguration) naming (e.g. .conf.txt)
          SportDb.parse_conf( txt, season: season, sync: sync )
        else                                ## assume "regular" match datafile
          SportDb.parse_match( txt, season: season, sync: sync )
        end
      end
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
        yield( path )
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

  def read_entry( name )
    txt = File.open( "#{@path}/#{name}", 'r:utf-8').read
    txt
  end

  def each_read( pattern: )
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
          puts "** !! ERROR !! #{entry.name} is unknown zip file type in >#{@path}<, sorry"
          exit 1
        end
      end
    end
  end


  def match_entry( name )
    ## todo/fix:  use Zip::File.glob or find_entry or ?  why? why not?

    pattern = %r{ #{Regexp.escape( name )}    ## match string if ends with name
                   $
                }x

    entries = []
    Zip::File.open( @path ) do |zipfile|
      zipfile.each do |entry|
        if entry.directory?
          next ## skip
        elsif entry.file?
          if pattern.match( entry.name )
            entries << entry
          end
        else
          puts "** !! ERROR !! #{entry.name} is unknown zip file type in >#{@path}<, sorry"
          exit 1
        end
      end
    end
    entries
  end

  def read_entry( name )
     entries = match_entry( name )
     if entries.empty?
       puts "** !!! ERROR !!! zip entry >#{name}< not found in >#{@path}<; sorry"
       exit 1
     elsif entries.size > 1
       puts "** !!! ERROR !!! ambigious zip entry >#{name}<; found #{entries.size} entries in >#{@path}<:"
       pp entries
       exit 1
     else
       entry = entries[0]
       txt = entry.get_input_stream.read
       ##  puts "** encoding: #{txt.encoding}"  #=> encoding: ASCII-8BIT
       txt = txt.force_encoding( Encoding::UTF_8 )
     end
  end


  def each_read( pattern: )
    each( pattern: pattern ) do |entry|
      txt = entry.get_input_stream.read
      ##  puts "** encoding: #{txt.encoding}"  #=> encoding: ASCII-8BIT
      txt = txt.force_encoding( Encoding::UTF_8 )
      yield( "#{@path}!/#{entry.name}", txt )    ## only pass along txt - why? why not? or pass along entry and not just entry.name?
    end
  end
end  # class ZipPackage
end  # module Datafile
