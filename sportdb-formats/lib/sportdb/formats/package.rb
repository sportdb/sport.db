
module SportDb
  class Package

    ## todo/fix:   make all regexes case-insensitive with /i option - why? why not?
    ##                e.g. .TXT and .txt
    ##   yes!! use /i option!!!!!

    CONF_RE = %r{  (?: ^|/ )               # beginning (^) or beginning of path (/)
        \.conf\.txt$
    }x

    ## leagues.txt or leagues_en.txt
    ##   remove support for en.leagues.txt - why? why not?
    LEAGUES_RE = %r{  (?: ^|/ )               # beginning (^) or beginning of path (/)
       (?: [a-z]{1,4}\. )?   # optional country code/key e.g. eng.clubs.wiki.txt
        leagues
          (?:_[a-z0-9_-]+)?
        \.txt$
    }x

    ## clubs.txt or clubs_en.txt
    ##   remove support for en.clubs.txt - why? why not?
    CLUBS_RE = %r{  (?: ^|/ )               # beginning (^) or beginning of path (/)
       (?: [a-z]{1,4}\. )?   # optional country code/key e.g. eng.clubs.txt
        clubs
          (?:_[a-z0-9_-]+)?
        \.txt$
    }x

    CLUBS_WIKI_RE = %r{  (?:^|/)               # beginning (^) or beginning of path (/)
        (?:[a-z]{1,4}\.)?   # optional country code/key e.g. eng.clubs.wiki.txt
       clubs
         (?:_[a-z0-9_-]+)?
       \.wiki\.txt$
    }x

    CLUB_PROPS_RE = %r{  (?: ^|/ )               # beginning (^) or beginning of path (/)
      (?: [a-z]{1,4}\. )?   # optional country code/key e.g. eng.clubs.props.txt
        clubs
          (?:_[a-z0-9_-]+)?
        \.props\.txt$
    }x

    ##  teams.txt or teams_history.txt
    TEAMS_RE = %r{  (?: ^|/ )               # beginning (^) or beginning of path (/)
                      teams
                        (?:_[a-z0-9_-]+)?
                      \.txt$
    }x

    ### season folder:
    ##            e.g. /2019-20   or
    ##  year-only e.g. /2019      or
    ##                 /2016--france
    SEASON_RE = %r{ (?:
                       \d{4}-\d{2}
                     | \d{4}(--[a-z0-9_-]+)?
                    )
                  }x
    SEASON = SEASON_RE.source    ## "inline" helper for embedding in other regexes - keep? why? why not?


    ## note: if pattern includes directory add here
    ##     (otherwise move to more "generic" datafile) - why? why not?
    MATCH_RE = %r{ (?: ^|/ )      # beginning (^) or beginning of path (/)
                       #{SEASON}
                     /[a-z0-9_-]+\.txt$  ## txt e.g /1-premierleague.txt
                }x

    MATCH_CSV_RE = %r{ (?: ^|/ )      # beginning (^) or beginning of path (/)
                         #{SEASON}
                       /[a-z0-9_.-]+\.csv$  ## note: allow dot (.) too e.g /eng.1.csv
                    }x

    ### add "generic" pattern to find all csv datafiles
    CSV_RE = %r{ (?: ^|/ )
                   [a-z0-9_.-]+\.csv$  ## note: allow dot (.) too e.g /eng.1.csv
               }x


    ## move class-level "static" finders to DirPackage (do NOT work for now for zip packages) - why? why not?

    def self.find( path, pattern )
      datafiles = []

      ## check all txt files
      ## note: incl. files starting with dot (.)) as candidates (normally excluded with just *)
      candidates = Dir.glob( "#{path}/**/{*,.*}.*" )
      pp candidates
      candidates.each do |candidate|
        datafiles << candidate    if pattern.match( candidate )
      end

      pp datafiles
      datafiles
   end


   def self.find_teams( path, pattern: TEAMS_RE )  find( path, pattern ); end
   def self.match_teams( path )  TEAMS_RE.match( path ); end

   def self.find_clubs( path, pattern: CLUBS_RE )            find( path, pattern ); end
   def self.find_clubs_wiki( path, pattern: CLUBS_WIKI_RE )  find( path, pattern ); end

   def self.match_clubs( path )       CLUBS_RE.match( path ); end
   def self.match_clubs_wiki( path )  CLUBS_WIKI_RE.match( path ); end
   def self.match_club_props( path, pattern: CLUB_PROPS_RE ) pattern.match( path ); end

   def self.find_leagues( path, pattern: LEAGUES_RE )  find( path, pattern ); end
   def self.match_leagues( path )  LEAGUES_RE.match( path ); end

   def self.find_conf( path, pattern: CONF_RE )  find( path, pattern ); end
   def self.match_conf( path )  CONF_RE.match( path ); end

   def self.find_match( path, format: 'txt' )
      if format == 'csv'
        find( path, MATCH_CSV_RE )
      else  ## otherwise always assume txt for now
        find( path, MATCH_RE )
      end
   end
   ## add match_match and match_match_csv  - why? why not?


   class << self
     alias_method :match_teams?, :match_teams
     alias_method :teams?,       :match_teams

     alias_method :match_clubs?, :match_clubs
     alias_method :clubs?,       :match_clubs

     alias_method :match_clubs_wiki?, :match_clubs_wiki
     alias_method :clubs_wiki?,       :match_clubs_wiki

     alias_method :match_club_props?, :match_club_props
     alias_method :club_props?,       :match_club_props

     alias_method :match_leagues?, :match_leagues
     alias_method :leagues?,       :match_leagues

     alias_method :match_conf?, :match_conf
     alias_method :conf?,       :match_conf
   end


    ## attr_reader :pack     ## allow access to embedded ("low-level") delegate package (or hide!?) - why? why not?
    attr_accessor :include, :exclude

    ## private helpers - like select returns true for keeping and false for skipping entry
    def filter_clause( filter, entry )
      if filter.is_a?( String )
        entry.name.index( filter ) ? true : false
      elsif filter.is_a?( Regexp )
        filter.match( entry.name )  ? true : false
      else  ## assume
        ## todo/check: pass in entry (and NOT entry.name) - why? why not?
        filter.call( entry )
      end
    end

    def filter( entry )
      if @include
        if filter_clause( @include, entry )   ## todo/check: is include a reserved keyword????
          true  ## todo/check: check for exclude here too - why? why not?
        else
          false
        end
      else
        if @exclude && filter_clause( @exclude, entry )
          false
        else
          true
        end
      end
    end


    def initialize( path_or_pack )
      @include = nil
      @exclude = nil

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


    def each( pattern:, &blk )
      @pack.each( pattern: pattern ) do |entry|
        next unless filter( entry )   ## lets you use include/exclude filters
        blk.call( entry )
      end
    end

    def each_conf( &blk )       each( pattern: CONF_RE, &blk ); end
    def each_match( format: 'txt', &blk )
      if format == 'csv'
         each( pattern: MATCH_CSV_RE, &blk );
      else
         each( pattern: MATCH_RE, &blk );
      end
    end
    def each_match_csv( &blk )  each( pattern: MATCH_CSV_RE, &blk ); end
    def each_csv( &blk )        each( pattern: CSV_RE, &blk );       end

    def each_club_props( &blk ) each( pattern: CLUB_PROPS_RE, &blk ); end

    def each_leagues( &blk )    each( pattern: LEAGUES_RE, &blk ); end
    def each_clubs( &blk )      each( pattern: CLUBS_RE, &blk ); end
    def each_clubs_wiki( &blk ) each( pattern: CLUBS_WIKI_RE, &blk ); end

    ## return all match datafile entries
    def match( format: 'txt' )
      ary=[]; each_match( format: format ) {|entry| ary << entry  }; ary;
    end
    alias_method :matches, :match


    ## todo/check:  rename/change to match_by_dir - why? why not?
    ##  still in use somewhere? move to attic? use match_by_season and delete by_season_dir? - why? why not?
    def match_by_season_dir( format: 'txt' )
      ##
      ## [["1950s/1956-57",
      ##    ["1950s/1956-57/1-division1.csv",
      ##     "1950s/1956-57/2-division2.csv",
      ##     "1950s/1956-57/3a-division3n.csv",
      ##     "1950s/1956-57/3b-division3s.csv"]],
      ##   ...]

      h = {}
      match( format: format ).each do |entry|
        season_path = File.dirname( entry.name )

        h[ season_path ] ||= []
        h[ season_path ] << entry
      end

      ##  todo/fix:  - add sort entries by name - why? why not?
      ## note: assume 1-,2- etc. gets us back sorted leagues
      ##  - use sort. (will not sort by default?)

      h.to_a    ## return as array (or keep hash) - why? why not?
    end # method match_by_season_dir

    def match_by_season( format: 'txt', start: nil )   ## change/rename to by_season_key - why? why not?

      ## todo/note: in the future - season might be anything (e.g. part of a filename and NOT a directory) - why? why not?

      ##  note: fold all sames seasons (even if in different directories)
      ##     into same datafile list e.g.
      ##   ["1957/58",
      ##     ["1950s/1957-58/1-division1.csv",
      ##      "1950s/1957-58/2-division2.csv",
      ##      "1950s/1957-58/3a-division3n.csv",
      ##      "1950s/1957-58/3b-division3s.csv"]],
      ## and
      ##   ["1957/58",
      ##      ["archives/1950s/1957-58/1-division1.csv",
      ##       "archives/1950s/1957-58/2-division2.csv",
      ##       "archives/1950s/1957-58/3a-division3n.csv",
      ##       "archives/1950s/1957-58/3b-division3s.csv"]],
      ##  should be together - why? why not?

      ####
      # Example package:
      # [["2012/13", ["2012-13/1-proleague.csv"]],
      #  ["2013/14", ["2013-14/1-proleague.csv"]],
      #  ["2014/15", ["2014-15/1-proleague.csv"]],
      #  ["2015/16", ["2015-16/1-proleague.csv"]],
      #  ["2016/17", ["2016-17/1-proleague.csv"]],
      #  ["2017/18", ["2017-18/1-proleague.csv"]]]

      ## todo/fix:  (re)use a more generic filter instead of start for start of season only

      ##  todo/fix: use a "generic" filter_season helper for easy reuse
      ##     filter_season( clause, season_key )
      ##   or better filter = SeasonFilter.new( clause )
      ##             filter.skip? filter.include? ( season_sason_key )?
      ##             fiteer.before?( season_key )  etc.
      ##              find some good method names!!!!
      season_start = start ? Import::Season.new( start ) : nil

      h = {}
      match( format: format ).each do |entry|
        ## note: assume last directory in datafile path is the season part/key
        season_q = File.basename( File.dirname( entry.name ))
        season   = Import::Season.new( season_q )  ## normalize season

        ## skip if start season before this season
        next if season_start && season_start.start_year > season.start_year

        h[ season.key ] ||= []
        h[ season.key ] << entry
      end

      ##  todo/fix:  - add sort entries by name - why? why not?
      ## note: assume 1-,2- etc. gets us back sorted leagues
      ##  - use sort. (will not sort by default?)

      ## sort by season
      ##   latest / newest first (and oldest last)

      h.to_a.sort do |l,r|    ## return as array (or keep hash) - why? why not?
        r[0] <=> l[0]
      end
    end # method match_by_season
  end   # class Package


  class DirPackage < Package
    def initialize( path )   super( Datafile::DirPackage.new( path ) ); end
  end

  class ZipPackage < Package
    def initialize( path )   super( Datafile::ZipPackage.new( path ) ); end
  end
end   # module SportDb
