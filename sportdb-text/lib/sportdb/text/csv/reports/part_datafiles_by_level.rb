# encoding: utf-8


class DatafilesByLevelPart    ## add Pyramid to name - why? why not?

def initialize( datafiles, level )
  @all_datafiles = datafiles  ## lookup registry/hash for all datafiles (holds matchlists)
  @level         = level      ## holds level_line hash with season and team stats
end


def build
  season_keys = @level.seasons.keys

  buf = ''
  buf << "level #{@level.name} - #{season_keys.size} seasons:\n"

  ## sort season_keys - why? why not?
  season_keys.sort.reverse.each do |season_key|
    datafiles = @level.seasons[season_key]

    ## add header for multiple datafiles
    if datafiles.size > 1
      buf << "- "
      datafiles.each_with_index do |datafile,i|
         buf << ", "  if i > 0
         buf << "[`#{datafile}`](#{datafile})"
      end
      buf << " (#{datafiles.size})\n"
    end

    datafiles.each do |datafile|
        buf << "   " if datafiles.size > 1   ## note: add extra ident if multiple datafiles

        matchlist = @all_datafiles[ datafile ]

        buf << "- [`#{datafile}`](#{datafile}) => "
        buf << " #{matchlist.teams.size} teams, "
        buf << " #{matchlist.matches.size} matches, "
        buf << " #{matchlist.goals} goals, "
        if matchlist.rounds?
          buf << " #{matchlist.rounds} rounds, "
        else
          buf << " **WARN - unbalanced rounds - fix/double check?!**"
        end
        if matchlist.start_date? && matchlist.end_date?  ## note: start_date/end_date might be optional/missing
          buf << " #{matchlist.start_date.strftime( '%a %d %b %Y' )} - #{matchlist.end_date.strftime( '%a %d %b %Y' )}"
        else
          buf << "**WARN - start: ???, end: ???**"
        end
        buf << "\n"
    end
  end

  buf << "\n\n"
  buf
end # method build

alias_method :render, :build

end # class DatafilesByLevelPart
