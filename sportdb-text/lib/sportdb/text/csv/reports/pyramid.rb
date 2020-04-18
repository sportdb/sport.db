# encoding: utf-8


class CsvPyramidReport    ## change to CsvTeamsUpDown/Diff/Level/Report - why? why not?


   class TeamLine
     attr_reader :name,
                 :levels

     def initialize( name )
       @name    = name
       @levels  = {}    ## holds seasons by level
     end

     def update( level:, season: )
       ##  use seasons to track datafile count as value - why? why not?
       ##   fix/todo: store datafiles in season - why? why not?
       ##   - use [].size to check how many datafiles per season?
       seasons = @levels[ level ] ||= Hash.new(0)
       seasons[ season ] += 1
     end
   end   # class TeamLine



   class SeasonLine
     attr_reader :name,
                 :levels

     def initialize( name )
       @name    = name
       @levels  = {}    ## holds datafiles by level
     end

     def update( level:, datafile: )
       ##  use seasons to track datafile count as value - why? why not?
       datafiles = @levels[ level ] ||= []
       datafiles << datafile
     end
   end   # class SeasonLine


   class LevelLine
     attr_reader  :name, :seasons, :teams     ## add :name - why? why not?

     def initialize( name )
       @name     = name.to_s  ## (auto-)convert to string (better always pass-in a string!!!)

       @seasons  = {}   ## count for now all datafiles for season
                        ##   note: allow multiple datafiles per season
       @teams    = {}   ## count for now all seasons of teams
     end

     def update_season( season, datafile: )
        @seasons[ season ] ||= []
        @seasons[ season ] << datafile
     end

     def update_team( team, season: '?' )
         @teams[ team ] ||= []
         @teams[ team ] << season   unless @teams[ team ].include?( season )
     end
   end   # class LevelLine



def initialize( pack )
  @pack = pack    # CsvPackage e.g.pack = CsvPackage.new( repo, path: path )
end


def build
  all_teams     = {}   ## holds TeamLine records
  all_seasons   = {}   ## holds SeasonLine records
  all_levels    = {}   ## holds LevelLine records -- collect all seasons by level and all seasons of teams by level
  all_datafiles = {}   ## holds Matchlist objects - keyed by datafile name/path


  season_entries = @pack.find_entries_by_season

  ## note: sort season - latest first
  ##  todo/fix: use File.basename() for sort  - allows subdirs e.g. 1980s, archive etc.
  season_entries.sort { |l,r| r[0] <=> l[0] }.each do |season_entry|
    season_dir   = season_entry[0]
    season_files = season_entry[1]    ## .csv (data)files

    season_files.each_with_index do |season_file,i|
      ## note: assume last directory is the season (season folder)
      season = File.basename( File.dirname( season_file ) )   # get eg. 2011-12
      puts "  season=>#{season}<"

      season_file_basename = File.basename( season_file, '.csv' )    ## e.g. 1-bundesliga, 3a-division3-north etc.

      level = LevelUtils.level( season_file_basename )   ## note: returns (always) a number!!!

      ###########################################################
      ## keep track of statistics with "line" records for level, season, team, etc.
      matches   = CsvMatchReader.read( @pack.expand_path( season_file ) )

      if matches.size == 0
        puts "!! error - no matches found in datafile: #{season_file}"
        pp matches
        exit 1
      end

      matchlist = SportDb::Import::Matchlist.new( matches )
      all_datafiles[season_file] = matchlist


      level_line = all_levels[ level ] ||= LevelLine.new( level )
      level_line.update_season( season, datafile: season_file )

      season_line = all_seasons[ season ] ||= SeasonLine.new( season )
      season_line.update( level: level, datafile: season_file )


      matchlist.teams.each do |team|
        team_line = all_teams[ team ] ||= TeamLine.new( team )
        team_line.update( level: level, season: season )

        level_line.update_team( team, season: season )
      end
    end
  end


  ## pp all_seasons
  ## pp all_teams
  ## pp all_levels


  ##########################
  ## print / analyze

  buf = ''
  buf << "#{all_seasons.keys.size} seasons, "
  buf << "#{all_levels.keys.size} levels (#{all_levels.keys.join(' ')}), "
  buf << "#{all_teams.keys.size} teams "
  buf << "in #{all_datafiles.keys.size} datafiles"
  buf << "\n\n"

  ## todo: add no of datafiles  (and no of matches too??)


  ## loop 1) summary
  all_levels.keys.each do |level_key|
    level = all_levels[level_key]
    buf << LevelPart.new( level ).build
  end


=begin
  ## loop 2) datafiles
  datafile_keys.each do |datafile_key|
    matchlist = all_datafiles[datafile_key]
    rounds = matchlist.rounds? ? matchlist.rounds : '???'
    buf << "#{datafile_key} - "
    buf << "#{matchlist.teams.size} teams, #{matchlist.matches.size} matches, #{rounds} rounds"
    buf << "\n"
  end
  buf << "\n\n"
=end


  buf << "\n## Datafiles by Level\n\n"
  ## loop 2) datafile quick (one-line) summary grouped by level
  all_levels.keys.each do |level_key|
    level = all_levels[level_key]
    buf << DatafilesByLevelPart.new( all_datafiles, level ).build
  end

  buf << "\n## Datafiles by Season\n\n"
  ## loop 3) datafile summary with details grouped by season
  all_seasons.keys.each do |season_key|
    prev_season_key = SeasonUtils.prev( season_key )

    season          = all_seasons[season_key]
    prev_season     = all_seasons[prev_season_key]
    buf << DatafilesBySeasonPart.new( all_datafiles, season, prev_season ).build
  end


  # puts "[debug] all_seasons:"
  # pp all_seasons

  buf
end # method build

alias_method :render, :build



def save( path )
  File.open( path, 'w:utf-8' ) do |f|
    f.write build
  end
end


end # class CsvPyramidReport
