# encoding: utf-8


class TeamMappingsPart    ## change to TeamMapping(s)Part/Block/Partial/Builder or something - why? why not?

def initialize( team_names, country: nil )
  @team_names = team_names
  @country    = country
end


def build   ## todo/check: always use render as name - why? why not?

  buf = String.new('')

  buf << "\n\n"
  buf << "```\n"


  @team_names.each do |team_name|
    team = find_team( team_name )
    if team
       alt_team_names =  team.alt_names

       buf << ('%-26s  ' % team_name)
       if team_name == team.name
         ## do (print) nothing
       else
         buf << "=> #{team.name}"
         if alt_team_names.size >= 1
            buf << "  (#{alt_team_names.size}) "
            buf << alt_team_names.join(' · ')
         end
       end
       # elsif alt_team_names.size == 1
       #  buf << "=> #{alt_team_names[0]}"
       # elsif alt_team_names.size > 1
       #  ## sort by lenght (smallest first)
       #  alt_team_names_sorted = alt_team_names.sort { |l,r| l.length <=> r.length }
       #  buf << "=> (#{alt_team_names.size}) #{alt_team_names_sorted.join(' • ')}"
       # else
       #  ## canonical name is mapping name - do not repeat/print for now
       # end
    else
       buf << " x #{team_name} (???)"
    end
    buf << "\n"
  end
  buf << "```\n\n"

  buf
end  # method build

alias_method :render, :build


#####
#  private helpers
def find_team( team_name )
  team_index = SportDb::Import.config.clubs

  if @country
    team = team_index.find_by( name: team_name, country: @country )
  else ## try global match
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

end # class TeamMappingsPart
