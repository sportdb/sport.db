# encoding: utf-8


class TeamMappingsPart    ## change to TeamMapping(s)Part/Block/Partial/Builder or something - why? why not?

def initialize( team_names, country: nil )
  @team_names = team_names
  @country    = country
end


def build   ## todo/check: always use render as name - why? why not?

  ## show list of teams without known canoncial/pretty print name
  ##  note: skip duplicates for now
  missing_teams = []
  duplicate_teams = {}   ## check for duplicates (that is, different name same club)

  @team_names.each do |team_name|
    team = find_team( team_name )
 
    if team.nil?
       missing_teams << team_name
    else
      duplicate_teams[team] ||= []
      duplicate_teams[team] << team_name
    end
  end


  buf = ''

  if missing_teams.size > 0
    missing_teams = missing_teams.sort   ## sort from a-z

    buf << "#{missing_teams.size} missing / unknown / (???) teams:\n"
    buf << "#{missing_teams.join(', ')}\n"
    buf << "\n\n"

    ############################
    ## for easy update add cut-n-paste code snippet
    buf << "```\n"
    missing_teams.each do |team_name|
      buf << ("%-22s =>\n" % team_name)
    end
    buf << "```\n\n"
  end



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


  ## check for duplicate clubs (more than one mapping / name)
  buf << "\n\nduplicates:\n"
  duplicate_teams.each do |team, rec|
     if rec.size > 1
       buf << "- **#{team.name} (#{rec.size}) #{rec.join(' · ')}**\n"
     end
  end 
  buf << "\n\n"

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
