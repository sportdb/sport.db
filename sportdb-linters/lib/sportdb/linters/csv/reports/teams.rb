# encoding: utf-8


class CsvTeamsReport    ## change to CsvPackageTeamsReport - why? why not?


# attr_reader  :errors,    ## use errors, warnings - why? why not?
#              :warnings

attr_reader  :team_names,
             :missing_teams,
             :duplicate_teams,
             :usage_teams,
             :levels,
             :team_mapping


def initialize( pack, country: nil )
  @pack    = pack    # CsvPackage e.g.pack = CsvPackage.new( repo, path: path )

  if country.is_a?( String ) || country.is_a?( Symbol )
    ## convert to country record
    ## todo/fix: check / assert NOT nil; country record returned
    @country = SportDb::Import.config.countries[ country.to_s ]
  else
    @country = country
  end

  @errors     = []   ## e.g. missing team names - use - why? why not?
  @warnings   = []   ## e.g. duplicate team names - use - why? why not?

  @team_names = []
  @missing_teams = []
  @duplicate_teams = {}
  @usage_teams = {}
  @levels = {}

  @team_mapping = {}
end


def prepare
  @errors     = []   ## e.g. missing team names
  @warnings   = []   ## e.g. duplicate team names

  @team_names = []
  @missing_teams = []
  @duplicate_teams = {}
  @usage_teams = {}
  @levels = {}

  @team_mapping = {}


  ## find all teams and generate a map w/ all teams n some stats
  teams = SportDb::Import::TeamUsage.new
  levels = Hash.new(0)   ## keep a counter of levels usage (more than one level?)

  season_entries = @pack.find_entries_by_season
  season_entries.each do |season_entry|
    season       = season_entry[0]    ## note: holds season key e.g. '2011/12'
    season_files = season_entry[1]    ## .csv (data)files

    season_files.each_with_index do |season_file,i|
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


  ## use all team names from team usage stats (all used teams)
  team_names = teams.to_a.map { |t| t.team }
  ## provide a usage lookup by team name
  usage_teams = teams.to_a.reduce({}) { |h,t| h[t.team]=t; h }

  ## show list of teams without known canoncial/pretty print name
  ##  note: skip duplicates for now
  team_mapping    = {}

  missing_teams   = []
  duplicate_teams = {}   ## check for duplicates (that is, different name same club)

  team_names.each do |team_name|
    team = find_team( team_name )

    team_mapping[team_name] = team

    if team.nil?
      missing_teams << team_name
    else
      duplicate_teams[team] ||= []
      duplicate_teams[team] << team_name
    end
  end

  ## remove all non-duplicate entries e.g. size == 1
  duplicate_teams = duplicate_teams.reduce({}) do |h,(k,v)|
                                                 h[k]=v  if v.size > 1
                                                 h
                                               end

  @team_names      = team_names
  @missing_teams   = missing_teams
  @duplicate_teams = duplicate_teams
  @usage_teams     = usage_teams
  @levels          = levels

  @team_mapping    = team_mapping
end

def build
  prepare

  ###
  ## todo - add count for seasons by level !!!!!
  ##   e.g. level 1 - 25 seasons, 2 - 14 seasons, etc.

  buf = String.new('')
  buf << "## Teams\n\n"

  if missing_teams.size > 0
    missing_teams_sorted = missing_teams.sort   ## sort from a-z

    buf << "#{missing_teams_sorted.size} missing / unknown / (???) teams:\n"
    buf << "#{missing_teams_sorted.join(', ')}\n"
    buf << "\n\n"

    ############################
    ## for easy update add cut-n-paste code snippet
    buf << "```\n"
    missing_teams_sorted.each do |team_name|
      buf << ("%-22s\n" % team_name)
    end
    buf << "```\n\n"
  end

  ## check for duplicate clubs (more than one mapping / name)
  if duplicate_teams.size > 0
    buf << "\n\n"
    buf << "#{duplicate_teams.size} duplicates:\n"
    duplicate_teams.each do |team, rec|
      buf << "- **#{team.name}** (#{rec.size}) #{rec.join(' · ')}\n"
    end
    buf << "\n\n"
  end



  buf << "```\n"
  buf << "  #{usage_teams.size} teams:\n"

  usage_teams.each_with_index do |(_,t),j|
    buf << ('  %5s  '   % "[#{j+1}]")

    ### todo/fix: add pluralize (match/matches) - check: pluralize method in rails?
    buf << ('%-30s  '   % t.team)
    buf << (":: %4d matches in " % t.matches)

    buf << ("%3d " % t.seasons.size)
    buf << pluralize('season', t.seasons.size)

    ## note: only add levels breakdown if levels.size greater (>1)
    ##  note: use "global" levels tracker
    if levels.size > 1

      buf << " / #{t.levels.size} "
      buf << pluralize('level', t.levels.size)
      buf << " - "

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


  buf << "### Team Name Mappings\n\n"
  buf << TeamMappingsPart.new( team_mapping ).build
  buf << "\n\n"


  # buf << "### Teams by City\n\n"
  # buf << TeamsByCityPart.new( team_mapping ).build
  # buf << "\n\n"


  ## show details
  buf << "### Season\n\n"

  usage_teams.each do |_,t|
    buf << "- "
    buf << build_team_seasons( t.team, t, levels )

    ## add levels up/down line e.g. ⇑ (2) / ⇓ (1):  1 ⇑2 2 ⇓1 1 ⇑2 2 2 2
    if t.levels.size > 1
      buf << "  - "
      buf << SeasonUtils.pretty_print_levels( t.levels )
      buf << "\n"
    end
  end
  buf << "\n"



  if missing_teams.size > 0
    buf << "```\n"
    buf << "#{missing_teams.size} missing:\n"
    missing_teams.sort.each_with_index do |team_name, i|  ## sort from a-z
      buf << "[#{i+1}] **#{team_name}**\n"
      t = usage_teams[ team_name ]
      buf << build_team_seasons( team_name, t, levels )
      buf << "\n"
    end
    buf << "```\n\n"
  end


  ## check for duplicate clubs (more than one mapping / name)
  if duplicate_teams.size > 0
    buf << "\n\n"
    buf << "```\n"
    buf << "#{duplicate_teams.size} duplicates:\n"
    duplicate_teams.each_with_index do |(team, rec), i|
        buf << "[#{i+1}] **#{team.name}** (#{rec.size}) #{rec.join(' · ')}\n"
        rec.each do |team_name|
          t = usage_teams[ team_name ]
          buf << build_team_seasons( team_name, t, levels )
        end
        buf << "\n"
    end
    buf << "```\n"
    buf << "\n\n"
  end


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
def build_team_seasons( team_name, t, levels )
  buf = String.new('')
  buf << "#{team_name} - #{t.seasons.size} #{pluralize('season',t.seasons.size)} in #{t.levels.size} #{pluralize('level',t.levels.size)}\n"
  levels.each do |level_key,_|
     level = t.levels[ level_key ]
     if level
       buf << "  - #{level_key} (#{level.seasons.size}): "
       buf << SeasonUtils.pretty_print( level.seasons )
       buf << "\n"
     end
  end
  buf
end


def pluralize( noun, counter )
   if counter == 1
     noun
   else
     "#{noun}s"
   end
end

def find_team( team_name )
  team_index = SportDb::Import.config.clubs

  ##  todo/fix: move team_parts machinery lookup into index itself for reuse!!!!

  ## check for country in names; split in parts
  ##   AC Milan › ITA
  team_parts = team_name.split( /[<>‹›]/ )  ## note: allow > < or › ‹
  team_parts = team_parts.map { |part| part.strip }   ## remove all (surrounding) whitespaces

  ## note: valid country part must be LAST and always UPPERCASE e.g. ITA, etc. for now
  country, name = if team_parts.size > 1 && team_parts[-1] =~ /^[A-Z]+$/
              ## assume last entry is country
              country_key = team_parts[-1]
              ## convert to country record
              ## todo/fix: check / assert NOT nil; country record returned
              country = SportDb::Import.config.countries[ country_key ]
              if country.nil?
                puts "!! ERROR: team name >#{team_name}< - no matching country found for >#{country_key}<"
                exit 1
              end
              [country, team_parts[0]]
            else   ## fallback - use default country (note: might be nil)
              [@country, team_name]
            end


  if country
    team = team_index.find_by( name: name, country: country )
  else ## try global match - fail for now!! - why? why not?
    puts "!! ERROR: team name >#{team_name}< - no country specified BUT required, sorry"
    exit 1

    m = team_index.match( team_name )
    if m.nil?
      ## puts "** !!! WARN !!! no match for club >#{name}<"
      team = nil
    elsif m.size > 1
      puts "** !!! ERROR !!! too many matches (#{m.size}) for club >#{name}<:"
      pp m
      exit 1
    else   # bingo; match - assume size == 1
      team = m[0]
    end
  end

  team
end


end # class CsvTeamsReport
