# encoding: utf-8



class CsvPackage

  attr_reader :name, :path

  def initialize( path, filter: nil )
     @filter = filter   ## allow optional filter e.g. filter by country etc.

     ## todo/check: make path (always) absolute (using expand_path())- why? why not?
     ## e.g convert eng-england  to ./eng-england
     ##   always add ./ to path if empty (not specified) - why? why not?

     @path = File.expand_path( path )
     @name = File.basename( @path )

     dirname  = File.dirname( @path )   ## note: returns ./ if name is without dirs e.g. eng-england etc.
     path_exp = "#{dirname}/#{@name}"   # note: should be the same as name - use name itself!!! - why? why not
     
     fail "assert failed - path #{path} do NOT match #{path_exp} =! #{@path}"  unless path_exp == @path
  end


  def expand_path( name )    ## rename to real_path or full_path - why? why not? - check zip gem what is the convention?
    File.expand_path( name, @path )
  end


  ### assume /1998-99/ =>   or
  ##         /1998/    =>
  ##   for directory/folder format for seasons / years for now
  ##    note: uses shell glob (NOT regex) pattern
  SEASON_PATTERNS = [
    '[0-9][0-9][0-9][0-9]-[0-9][0-9]',  ## e.g. /1998-99/
    '[0-9][0-9][0-9][0-9]'              ## e.g  /1999/  - note: will NOT include /1990s etc.
  ]

  def find_entries_by_season_dir   ## change entries to datafile - why? why not?
    # note: use find_entry_by_season to get datafiles by season (without full "physical" directory path)

    ##
    ## [["1950s/1956-57",
    ##    ["1950s/1956-57/1-division1.csv",
    ##     "1950s/1956-57/2-division2.csv",
    ##     "1950s/1956-57/3a-division3n.csv",
    ##     "1950s/1956-57/3b-division3s.csv"]], 
    ##   ...]

    entries = []

    ## note: use full package path as root path
    ##  e.g. ./o/be-belgium or something
    root_path = @path
    pp root_path

    season_paths = Dir.glob( "#{root_path}/**/{#{SEASON_PATTERNS.join(',')}}" )
    season_paths.each_with_index do |season_path,i|

      ## note: cut-off in_root (to pretty print path)
      season_path_rel = season_path[root_path.length+1..-1]

      puts "season path [#{i+1}/#{season_paths.size}]: >#{season_path_rel}< (#{season_path}):"

      season = [season_path_rel, []]

      ## note: assume 1-,2- etc. gets us back sorted leagues
      ##  - use sort. (will not sort by default)
      datafile_paths = Dir.glob( "#{season_path}/*.csv").sort
      datafile_paths.each_with_index do |datafile_path,j|

        ## note: cut-off in_root (to pretty print path)
        datafile_path_rel = datafile_path[root_path.length+1..-1]
        puts "   datafile [#{j+1}/#{datafile_paths.size}]: >#{datafile_path_rel}< (#{datafile_path})"

        season[1] << datafile_path_rel
      end  # each datafile_paths
      entries << season
    end # each season_paths
    entries
  end


  def find_entries_by_season   ## change entries to datafile - why? why not?
    ## todo/note: in the future - season might be anything (e.g. part of a filename and NOT a directory)

    ### todo/fix:
    ##    fold all sames seasons (even if in different directories)
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

    entries = []
    ####
    # Example package:
    # [["2012/13", ["2012-13/1-proleague.csv"]],
    #  ["2013/14", ["2013-14/1-proleague.csv"]],
    #  ["2014/15", ["2014-15/1-proleague.csv"]],
    #  ["2015/16", ["2015-16/1-proleague.csv"]],
    #  ["2016/17", ["2016-17/1-proleague.csv"]],
    #  ["2017/18", ["2017-18/1-proleague.csv"]]]


   ## note: use full package path as root path
   ##  e.g. ./o/be-belgium or something
   root_path = @path
   pp root_path


   season_paths = Dir.glob( "#{root_path}/**/{#{SEASON_PATTERNS.join(',')}}" )
   season_paths.each_with_index do |season_path,i|

     season_basename = File.basename( season_path )
     puts "season folder [#{i+1}/#{season_paths.size}]: >#{season_basename}< (#{season_path}):"

     season_key      = SeasonUtils.key( season_basename )
     season = [season_key, []]

     ## note: assume 1-,2- etc. gets us back sorted leagues
     ##  - use sort. (will not sort by default)
     datafile_paths = Dir.glob( "#{season_path}/*.csv").sort
     datafile_paths.each_with_index do |datafile_path,j|
         if @filter
           datafile_basename = File.basename( datafile_path )
           ## allow (support) match by string or regexp for now
           next  if @filter.is_a?(String) && datafile_basename.start_with?( @filter ) == false
           next  if @filter.is_a?(Regexp) && @filter.match( datafile_basename ) == nil
         end

         ## note: cut-off in_root (to pretty print path)
         datafile_path_rel = datafile_path[root_path.length+1..-1]
         puts "   datafile [#{j+1}/#{datafile_paths.size}]: >#{datafile_path_rel}< (#{datafile_path})"

         season[1] << datafile_path_rel
     end  # each datafile_paths

      ## note only add if season has entries
      entries << season      if season[1].size > 0
    end # each season_paths
    entries
  end # method find_entries_by_season


  def find_entries_by_season_n_division

     entries = {}
     ####
     # Example package:
     ##  note: uses season key (e.g. 2012/13 and NOT 2012-13)
     ##        AND uses division key (as string) and NOT level key e.g. "3 and not 3
     ##             possible division keys include "3a", "3b", "2n", "2s", etc.
     # { "2012/13" => { "1" => ["2012-13/1-proleague.csv"] },
     #   "2013/14" => { "1" => ["2013-14/1-proleague.csv"] },
     #   "2014/15" => { "1" => ["2014-15/1-proleague.csv"] },
     #   "2015/16" => { "1" => ["2015-16/1-proleague.csv"] },
     #   "2016/17" => { "1" => ["2016-17/1-proleague.csv"] },
     #   "2017/18" => { "1" => ["2017-18/1-proleague.csv"] }
     # }

    find_entries_by_season.each do |season_key, datafiles|

      #   e.g. 2012-13   => 2012/13
      #    or  2012-2013 => 2012/13
      season = entries[ season_key ] ||= {}


      ## note: assume 1-,2- etc. gets us back sorted leagues
      ##  - todo/check: use sort. (will not sort by default) - why? why not?
      datafiles.each_with_index do |datafile,i|
          puts "   season #{season_key} datafile [#{i+1}/#{datafiles.size}]: >#{datafile}<"

          ## get level/tier for datafile
          ##  todo/fix:
          ##    allow datafiles without level/tier   - use "x" or something for key -why? why not?
          ##    allow datafiles with level/tier AND divisions e.g. 3a,3b, 2n,2s, etc.
          ##      - note: always use division as string for lookup!!

          ## get level/tier (division really)
          basename       = File.basename( datafile, '.csv' ) ## todo/check .csv correct?
          division_key   = LevelUtils.division( basename )

          ## todo/fix:  check if divison is present
          ##              if not use '?' - why? why not?
          season[ division_key ] ||= []
          season[ division_key ] <<  datafile
      end  # each datafiles

    end # each entries
    entries
  end # method find_entries_by_season_n_division


  def find_entries_by_code_n_season_n_division
    ## note: code might be country code e.g. eng, sco, at, de, etc.
    ##   or champ or something

    entries = {}
    find_entries_by_season.each do |season_key, datafiles|

      ## note: assume 1-,2- etc. gets us back sorted leagues
      ##  - todo/check: use sort. (will not sort by default) - why? why not?
      datafiles.each_with_index do |datafile,i|
          puts "   season #{season_key} datafile [#{i+1}/#{datafiles.size}]: >#{datafile}<"

          ## get level/tier for datafile
          ##  todo/fix:
          ##    allow datafiles without level/tier   - use "x" or something for key -why? why not?
          ##    allow datafiles with level/tier AND divisions e.g. 3a,3b, 2n,2s, etc.
          ##      - note: always use division as string for lookup!!

          ## get level/tier (division really)
          basename = File.basename( datafile, '.csv' ) ## todo/check .csv correct?

          ## try to get (county) code (key) and division (key) from datafile basename
          m = nil     ## m => (regex) match data object
          code_key, division_key = if (m=basename.match( /^
                                           (?<code>[a-z]{2,3})
                                              \.
                                           (?<div>\d{1,2}[a-z]?)
                                              (?:\.|$)/x ))    ## e.g. eng.1
                [m[:code], m[:div]]
              elsif (m=basename.match( /^
                                  (?<div>\d{1,2}[a-z]?)-/x ))
                ['?', m[:div]]
              elsif (m=basename.match( /^
                                  (?<code>[a-z]{2,})
                                       $/x ))   ## all lowercase e.g. eng, champs, etc.
                [m[:code], '?']
              else
                ## return ? for undefined / unknown division - why? why not?
                ['?', '?']
              end

         code   = entries[ code_key ] ||= {}
         season = code[ season_key ] ||= {}

         season[ division_key ] ||= []
         season[ division_key ] <<  datafile
      end  # each datafiles

    end # each entries
    entries
  end # method find_entries_by_code_n_season_n_division

end # class CsvPackage
