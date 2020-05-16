# encoding: utf-8


class TeamsByCityPart    ## change to TeamCityPart/Block/Partial/Builder or something - why? why not?


def initialize( team_mapping )
  @team_mapping = team_mapping
end


def build     ## todo/check: always use render as name - why? why not?
  cities        = {}
  missing_teams = []

  @team_mapping.each do |team_name,team|
    if team
       team_city = team.city || '?'    ## convert nil to ?

       ## note: do NOT include duplicate teams (twice or three times)
       cities[team_city] ||= []
       cities[team_city] << team    unless cities[team_city].include?( team )
    else
      ## collect missing teams too - why? why not?
      missing_teams << team_name
    end
  end


  buf = String.new('')

  if missing_teams.size > 0
    missing_teams = missing_teams.sort  ## sort from a-z

    buf << "#{missing_teams.size} missing teams:\n"
    buf << missing_teams.join( ', ' )
    buf << "\n\n"
  end


  ## sort cities by name
  ##   todo/fix: exlude special key x and ? - why? why not?
  sorted_cities = cities.to_a.sort do |l,r|
     res = r[1].size <=> l[1].size       ## sort by team size/counter first
     res = l[0] <=> r[0]    if res == 0   ## sort by city name next
     res
  end


  sorted_cities.each do |city_rec|
    city = city_rec[0]  # city name/key
    v    = city_rec[1]  # teams for city

      if city == '?'
        buf << "- #{city}"
      else
        buf << "- **#{city}**"
      end

      buf << " (#{v.size})"
      buf << ": "

      if v.size == 1
        t = v[0]
        buf << "#{t.name} "
        if t.alt_names && t.alt_names.size > 0
            ##  todo/fix:
            ##    add check for matching city name !!!!
            ##     sort by smallest first - why? why not?
            buf << " (#{t.alt_names.size}) #{t.alt_names.join(' · ')}"
        end
        buf << "\n"
      else
        ## buf << v.map { |t| t.name }.join( ', ')  ## print all canonical team names
        buf << "\n"
        v.each do |t|
          buf << "  - #{t.name} "
          if t.alt_names && t.alt_names.size > 0
            ##  todo/fix:
            ##    add check for matching city name !!!!
            ##     sort by smallest first - why? why not?
            buf << " (#{t.alt_names.size}) #{t.alt_names.join(' · ')}"
          end
          buf << "\n"
        end
      end
  end

  buf << "\n\n"
  buf
end  # method build

alias_method :render, :build

end  # class TeamsByCityPart
