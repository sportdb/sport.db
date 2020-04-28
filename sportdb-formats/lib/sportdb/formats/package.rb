
module SportDb
  class Package

    CONF_RE        = Datafile::CONF_RE
    CLUB_PROPS_RE  = Datafile::CLUB_PROPS_RE
    LEAGUES_RE     = Datafile::LEAGUES_RE
    CLUBS_RE       = Datafile::CLUBS_RE


    ## note: if pattern includes directory add here
    ##     (otherwise move to more "generic" datafile) - why? why not?
    MATCH_RE = %r{ /(?: \d{4}-\d{2}        ## season folder e.g. /2019-20
                      | \d{4}(--[^/]+)?    ## season year-only folder e.g. /2019 or /2016--france
                    )
                   /[a-z0-9_-]+\.txt$  ## txt e.g /1-premierleague.txt
                }x

    attr_reader :pack     ## allow access to embedded ("low-level") delegate package (or hide!?) - why? why not?

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
  end   # class Package


  class DirPackage < Package
    def initialize( path )   super( Datafile::DirPackage.new( path ) ); end
  end

  class ZipPackage < Package
    def initialize( path )   super( Datafile::ZipPackage.new( path ) ); end
  end
end   # module SportDb
