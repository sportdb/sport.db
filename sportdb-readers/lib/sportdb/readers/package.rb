
module SportDb
  class Package

    CONF_RE        = Datafile::CONF_RE
    CLUB_PROPS_RE  = Datafile::CLUB_PROPS_RE
    LEAGUES_RE     = Datafile::LEAGUES_RE
    CLUBS_RE       = Datafile::CLUBS_RE


    ## note: if pattern includes directory add here (otherwise move to more "generic" datafile) - why? why not?
    MATCH_RE = %r{ /(?: \d{4}-\d{2}        ## season folder e.g. /2019-20
                      | \d{4}              ## season year-only folder e.g. /2019
                    )
                   /[a-z0-9_-]+\.txt$  ## txt e.g /1-premierleague.txt
                }x


    attr_reader :pack     ## allow access to embedded ("low-level") delegate package

    def initialize( path_or_pack )
      if path_or_pack.is_a?( Datafile::Package )
        @pack = path_or_pack
      else   ## assume it's a (string) path
        path = path_or_pack
        if !File.exist?( path )  ## file or directory
          puts "** !!! ERROR !!! file NOT found >#{path}<; cannot open package"
          exit 1
        end

        if File.directory?( path )
          @pack = Datafile::DirPackage.new( path )     ## delegate to "generic" package
        elsif File.file?( path ) && File.extname( path ) == '.zip'  # note: includes dot (.) eg .zip
          @pack = Datafile::ZipPackage.new( path )
        else
          puts "** !!! ERROR !!! cannot open package - directory or file with .zip extension required"
          exit 1
        end
      end
    end

    def each_conf( &blk )       @pack.each( pattern: CONF_RE, &blk ); end
    def each_match( &blk )      @pack.each( pattern: MATCH_RE, &blk ); end
    def each_club_props( &blk ) @pack.each( pattern: CLUB_PROPS_RE, &blk ); end

    def each_leagues( &blk )    @pack.each( pattern: LEAGUES_RE, &blk ); end
    def each_clubs( &blk )      @pack.each( pattern: CLUBS_RE, &blk ); end


    def read_leagues
      each_leagues do |entry|
        SportDb.parse_leagues( entry.read )
      end
    end

    def read_clubs
      each_clubs do |entry|
        SportDb.parse_clubs( entry.read )
      end
    end


    def read_club_props( sync: true )   ## todo/fix: remove sync!! - why? why not?
      each_club_props do |entry|
        SportDb.parse_club_props( entry.read, sync: sync )
      end
    end

    def read_conf( *names,
                   season: nil, sync: true )
      if names.empty?   ## no (entry) names passed in; read in all
        each_conf do |entry|
          SportDb.parse_conf( entry.read, season: season, sync: sync )
        end
      else
        names.each do |name|
          entry = @pack.find( name )
          SportDb.parse_conf( entry.read, season: season, sync: sync )
        end
      end
    end

    def read_match( *names,
                    season: nil, sync: true )
      if names.empty?   ## no (entry) names passed in; read in all
        each_match do |entry|
          SportDb.parse_match( entry.read, season: season, sync: sync )
        end
      else
        names.each do |name|
          entry = @pack.find( name )
          SportDb.parse_match( entry.read, season: season, sync: sync )
        end
      end
    end


    def read( *names,
              season: nil, sync: true )
      if names.empty?   ##  read all datafiles
        read_leagues()
        read_clubs()
        read_club_props( sync: sync )   ## todo/fix: remove sync - why? why not?
        read_conf( season: season, sync: sync )
        read_match( season: season, sync: sync )
      else
        names.each do |name|
          entry = @pack.find( name )
          ## fix/todo: add read_leagues, read_clubs too!!!
          if Datafile.match_conf( name )      ## check if datafile matches conf(iguration) naming (e.g. .conf.txt)
            SportDb.parse_conf( entry.read, season: season, sync: sync )
          elsif Datafile.match_club_props( name )
            SportDb.parse_club_props( entry.read, sync: sync )
          else   ## assume "regular" match datafile
            SportDb.parse_match( entry.read, season: season, sync: sync )
          end
        end
      end
    end
  end   # class Package


  class DirPackage < Package
    def initialize( path )   super( Datafile::DirPackage.new( path ) ); end
  end

  class ZipPackage < Package
    def initialize( path )   super( Datafile::ZipPackage.new( path ) ); end
  end

end   # module SportDb
