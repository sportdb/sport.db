##  zip? not getting used? remove - why? why not?
  ZIP_RE = %r{ \.zip$
              }ix   ## note: allow .ZIP to (ignore case)
  def self.match_zip( path, pattern: ZIP_RE ) pattern.match( path ); end
  class << self    ## check if module << self is possible? (like class << self) - check if there's a better / more idomatic way??
    alias_method :match_zip?, :match_zip
    alias_method :zip?,       :match_zip
  end


      SEASON_DIR_RE = %r{^
                      (?: .+
                        /
                      )?    ## optional leading dirs
                     (?<season>#{SEASON})
                     (?=/)    ## note: MUST be follow by slash (/)
                    }x

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
        if m=SEASON_DIR_RE.match( entry.name )
          h[ m[0] ] ||= []
          h[ m[0] ] << entry
        else
          puts "!! ERROR: season match expected in entry name:"
          pp entry
          exit 1
        end
      end

      ##  todo/fix:  - add sort entries by name - why? why not?
      ## note: assume 1-,2- etc. gets us back sorted leagues
      ##  - use sort. (will not sort by default?)

      h.to_a    ## return as array (or keep hash) - why? why not?
    end # method match_by_season_dir

    def match_by_season( format: 'txt', start: nil )   ## change entries to datafile - why? why not?

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
        if m=SEASON_DIR_RE.match( entry.name )
          ## note: do NOT use complete path/match only captured season e.g. m[:season]
          season = Import::Season.new( m[:season] )  ## normalize season

          ## skip if start season before this season
          next if season_start && season_start.start_year > season.start_year

          h[ season.key ] ||= []
          h[ season.key ] << entry
        else
          puts "!! ERROR: season match expected in entry name:"
          pp entry
          exit 1
        end
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
