# encoding: utf-8


class TeamMappingsPart    ## change to TeamMapping(s)Part/Block/Partial/Builder or something - why? why not?

def initialize( team_mapping )
  @team_mapping = team_mapping
end


def build   ## todo/check: always use render as name - why? why not?

  buf = String.new('')

  buf << "\n\n"
  buf << "```\n"


  @team_mapping.each do |team_name,team|
    if team
       if team.historic?
         buf << "xxx "   ### check if year is in name?
       else
         buf << "    "
       end

       buf << "%-26s" %  team_name
       if team.name != team_name
         buf << " => %-25s |" % team.name
       else
         buf << (" #{' '*28} |")
       end  
      
       if team.city
         buf << " #{team.city}"
         buf << " (#{team.district})"   if team.district
       else
         buf << " ?  "
       end

       if team.geos
         buf << ",  #{team.geos.join(' › ')}"
       end

       # alt_team_names =  team.alt_names
       #
       # buf << ('%-26s  ' % team_name)
       # if team_name == team.name
       #  ## do (print) nothing
       # else
       #  buf << "=> #{team.name}"
       #  if alt_team_names.size >= 1
       #     buf << "  (#{alt_team_names.size}) "
       #     buf << alt_team_names.join(' · ')
       #  end
       # end
       #
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
       buf << "!!! #{team_name} (???)"
    end
    buf << "\n"
  end
  buf << "```\n\n"

  buf
end  # method build

alias_method :render, :build

end # class TeamMappingsPart
