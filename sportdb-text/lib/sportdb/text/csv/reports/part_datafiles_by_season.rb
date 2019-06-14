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
      buf << " #{matchlist.rounds} rounds, "    if matchlist.rounds?
      if matchlist.start_date? && matchlist.end_date?
        buf << " #{matchlist.start_date.strftime( '%a %-d %b %Y' )} - #{matchlist.end_date.strftime( '%a %-d %b %Y' )}"
      else
        buf << " start: ???, end: ???"
      end
      buf << "\n"

      buf << "  "  if datafiles.size > 1   ## add extra ident if multiple datafiles
      if matchlist.rounds?
        buf << "    - #{matchlist.teams.join(', ')}"
        buf << "\n"
      else
        buf << "    - **unbalanced rounds - add teams with matches played here**"
        buf << "\n"
      end


      ## find previous/last season if available for diff
      ## fix/todo: only works for single datafiles for now!!!
      ##   make more "generic" - how???
      if @prev_season
        prev_datafiles = @prev_season.levels[level_key]
        if prev_datafiles && datafiles.size == 1      ## note: level might be missing in prev season!!
          ## buf << "    - diff #{season_key} <=> #{prev_season_key}:\n"
          prev_matchlist = @all_datafiles[ prev_datafiles[0] ]  ## work with first datafile only for now

          diff_plus   = (matchlist.teams - prev_matchlist.teams).sort
          diff_minus  = (prev_matchlist.teams -  matchlist.teams).sort

          buf << "      - (++) new in season #{@season.name}: "
          buf << "(#{diff_plus.size}) #{diff_plus.join(', ')}\n"

          buf << "      - (--) out "
          if level_key == 1    ## todo: check level_key is string or int?
            buf << "down: "
          else
            buf << "up/down: "   ## assume up/down for all other levels in pyramid
          end
          buf << "(#{diff_minus.size}) #{diff_minus.join(', ')}\n"
          buf << "\n"
        end
      end

    end  # each datafile

## todo/fix: print teams with match played
=begin
team_usage_hash = build_team_usage_in_matches_txt( matches )
team_usage = team_usage_hash.to_a
## sort by matches_played and than by team_name !!!!
team_usage = team_usage.sort do |l,r|
 res = r[1] <=> l[1]     ## note: reverse order - bigger number first e.g. 30 > 28 etc.
 res = l[0] <=> r[0]  if res == 0
 res
end

buf_details << "  - #{team_usage.size} teams: "
team_usage.each do |rec|
team_name      = rec[0]
matches_played = rec[1]
buf_details << "#{team_name} (#{matches_played}) "
end
buf_details << "\n"
=end


    ## todo/fix:
    ##    add unknown (missing canonical mapping) teams!!!!

=begin
canonical_teams = SportDb::Import.config.teams  ## was pretty_print_team_names

## find all unmapped/unknown/missing teams
##   with no pretty print team names in league
names = []
team_usage.each do |rec|
team_name = rec[0]
names << team_name     if canonical_teams[team_name].nil?
end
names = names.sort   ## sort from a-z

if names.size > 0
buf_details << "    - #{names.size} teams unknown / missing / ???: "
buf_details << "#{names.join(', ')}\n"
end
=end

  end  # each level
  buf << "\n\n"
  buf
end # method build

alias_method :render, :build

end # class DatafilesBySeasonPart
