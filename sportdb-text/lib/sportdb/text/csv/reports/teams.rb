# encoding: utf-8


class CsvTeamsReport    ## change to CsvPackageTeamsReport - why? why not?


def initialize( pack )
  @pack = pack    # CsvPackage e.g.pack = CsvPackage.new( repo, path: path )
end


def build
  ###
  ## todo - add count for seasons by level !!!!!
  ##   e.g. level 1 - 25 seasons, 2 - 14 seasons, etc.

  ## find all teams and generate a map w/ all teams n some stats
  teams = SportDb::Struct::TeamUsage.new
  levels = Hash.new(0)   ## keep a counter of levels usage (more than one level?)

  season_entries = @pack.find_entries_by_season
  season_entries.each do |season_entry|
    season_dir   = season_entry[0]
    season_files = season_entry[1]    ## .csv (data)files

    season_files.each_with_index do |season_file,i|
      ## note: assume last directory is the season (season folder)
      season = File.basename( File.dirname( season_file ) )   # get eg. 2011-12
      puts "  season=>#{season}<"

      season_file_basename = File.basename( season_file, '.csv' )    ## e.g. 1-bundesliga, 3a-division3-north etc.

      ## use level naming convention e.g.:
      ##   1-liga, 01-liga =>  1
      ##   1a-liga, 1b-liga => 1
      ##   liga  =>  999     -- note: use 999 for undefined/unknown level !!!
      level = LevelUtils.level( season_file_basename )   ## note: returns (always) a number!!!

      levels[level] += 1   ## keep track of level usage

      matches   = CsvMatchReader.read( @pack.expand_path( season_file ) )

      teams.update( matches, season: season, level: level )
    end
  end


  canonical_teams = SportDb::Import.config.teams  ## was pretty_print_team_names


  buf = ''
  buf << "## Teams\n\n"

  ary = teams.to_a

  buf << "```\n"
  buf << "  #{ary.size} teams:\n"

  ary.each_with_index do |t,j|
    buf << ('  %5s  '   % "[#{j+1}]")
    if canonical_teams[t.team]   ## add marker e.g. (*) for pretty print team name
      team_name_with_marker = "#{t.team}"    ## add (*) - why? why not?
    else
      team_name_with_marker = " x #{t.team} (???)"
    end
    ### todo/fix: add pluralize (match/matches) - check: pluralize method in rails?
    buf << ('%-30s  '   % team_name_with_marker)
    buf << (':: %4d matches in ' % t.matches)
    buf << ('%3d seasons' % t.seasons.size)

    ## note: only add levels breakdown if levels.size greater (>1)
    ##  note: use "global" levels tracker
    if levels.size > 1

      buf << " / #{t.levels.size} levels - "
      ## note: format levels in aligned blocks (10-chars wide)
      levels.each do |level_key,_|
         level = t.levels[ level_key ]
         if level
           level_buf = "#{level_key} (#{level.seasons.size})"
           buf << level_buf
           buf << " " * (10-level_buf.length)    ## fill up to 10
         else
           buf << "   x "
           buf << " " * 5
         end
      end
    end

    buf << "\n"
  end
  buf << "```\n"
  buf << "\n\n"



  ## use all team names from team usage stats (all used teams)
  team_names = teams.to_a.map { |t| t.team }

  buf << "### Team Name Mappings\n\n"
  buf << TeamMappingsPart.new( team_names ).build
  buf << "\n\n"


  buf << "### Teams by City\n\n"
  buf << TeamsByCityPart.new( team_names ).build
  buf << "\n\n"



  ## show details
  buf << "### Season\n\n"

  ary = teams.to_a
  ary.each do |t|
    buf << "- "
    if canonical_teams[t.team]   ## add marker e.g. (*) for pretty print team name
      team_name_with_marker = "**#{t.team}**"    ## add (*) - why? why not?
    else
      team_name_with_marker = "x #{t.team} (???)"
    end
    buf << "#{team_name_with_marker} - #{t.seasons.size} #{pluralize('season',t.seasons.size)} in #{t.levels.size} #{pluralize('level',t.levels.size)}\n"
    levels.each do |level_key,_|
       level = t.levels[ level_key ]
       if level
         buf << "  - #{level_key} (#{level.seasons.size}): "
         buf << SeasonUtils.pretty_print( level.seasons )
         buf << "\n"
       end
    end

    ## add levels up/down line e.g. ⇑ (2) / ⇓ (1):  1 ⇑2 2 ⇓1 1 ⇑2 2 2 2
    if t.levels.size > 1
      buf << "  - "
      buf << SeasonUtils.pretty_print_levels( t.levels )
      buf << "\n"
    end
  end
  buf << "\n"

  buf
end # method build
alias_method :render, :build




def save( path )
  File.open( path, 'w:utf-8' ) do |f|
    f.write build
  end
end



#### private helpers
private

def pluralize( noun, counter )
   if counter == 1
     noun
   else
     "#{noun}s"
   end
end


end # class CsvTeamsReport
