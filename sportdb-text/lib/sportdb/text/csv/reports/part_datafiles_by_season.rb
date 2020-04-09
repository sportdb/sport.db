# encoding: utf-8


class DatafilesBySeasonPart    ## add Pyramid to name - why? why not?

def initialize( datafiles, season, prev_season )
  @all_datafiles = datafiles  ## lookup registry/hash for all datafiles (holds matchlists)
  @season        = season     ## season holds datafiles (grouped) by level
  @prev_season   = prev_season   # used for calculating diff (for teams etc.)
end


def build
  buf = ''
  buf << "#{@season.name} - #{@season.levels.size} levels (#{@season.levels.keys.join(' ')})"
  buf << "\n"

  @season.levels.keys.each do |level_key|
    buf << "  - #{level_key}:"
    datafiles = @season.levels[level_key]

    ## add header for multiple datafiles
    if datafiles.size > 1
      buf << " "
      datafiles.each_with_index do |datafile,i|
         buf << ", "  if i > 0
         buf << "[`#{datafile}`](#{datafile})"
      end
      buf << " (#{datafiles.size})\n"
    end

    datafiles.each_with_index do |datafile,i|
      buf << "    -" if datafiles.size > 1   ## extra list item and ident if multiple datafiles

      buf << " [`#{datafile}`](#{datafile}) - "

      ## find matchlist by datafile name
      matchlist = @all_datafiles[ datafile ]
      buf << " #{matchlist.teams.size} teams, "
      buf << " #{matchlist.matches.size} matches, "
      buf << " #{matchlist.goals} goals, "
      if matchlist.stages.size > 1
        buf << " #{matchlist.stages.size} stages (#{matchlist.stages.join(' · ')}), "
      else
        buf << " #{matchlist.rounds} rounds, "    if matchlist.rounds?
      end
      if matchlist.has_dates?
        buf << " #{matchlist.dates_str}"
      else
        buf << " start: ???, end: ???"
      end
      buf << "\n"

   

      buf << "  "  if datafiles.size > 1   ## add extra ident if multiple datafiles
  
      if matchlist.stages.size == 1
        if matchlist.rounds?
          buf << "    - #{matchlist.teams.join(', ')}"
          buf << "\n"
        else
          buf << "    - **unbalanced rounds #{matchlist.match_counts_str} matches played × team**"
          buf << "      #{build_team_usage( matchlist.team_usage )}"
          buf << "\n"
        end
      else ## assume more than one stage 

        matchlist.stage_usage.each do |stage_name,stage|
          buf << "    - #{stage_name} :: "
          buf << " #{stage.teams.size} teams, "
          buf << " #{stage.matches} matches, "
          buf << " #{stage.goals} goals, "
          
          if ['Regular'].include?(stage_name)
            ## note: (auto-)check balanced rounds only if assuming "simple" regular season 
            if stage.rounds?
              buf << " #{stage.rounds} rounds, "
            else
              buf << " **WARN - unbalanced rounds** #{stage.match_counts_str} matches played × team, "
            end
          else
            buf << " #{stage.match_counts_str} matches played × team, "
          end

          if stage.has_dates?  ## note: start_date/end_date might be optional/missing
            buf << " #{stage.dates_str} (#{stage.days}d)"
          else
            buf << "**WARN - start: ???, end: ???**"
          end
          buf << "\n"

          if stage.rounds?
            buf << "        - #{matchlist.teams.join(', ')}"
            buf << "\n"
          else
            buf << "        - #{build_team_usage( stage.team_usage )}"
            buf << "\n"
          end  
        end
      end
    end  # each datafile
  end  # each level
  buf << "\n\n"
  buf
end # method build

alias_method :render, :build


####
# helper methods

def build_team_usage( team_usage )
   ## teams by match count

   ## sort by matches_played and than by team_name !!!!
   team_usage = team_usage.to_a.sort do |l,r|
    res = r[1] <=> l[1]     ## note: reverse order - bigger number first e.g. 30 > 28 etc.
    res = l[0] <=> r[0]  if res == 0
    res
   end
   
   buf = String.new('')
   team_usage.each do |rec|
      buf << "#{rec[0]} (#{(rec[1])}) "
   end
   buf
end


end # class DatafilesBySeasonPart
