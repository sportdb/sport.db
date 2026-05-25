######
# goals helper
#   todo/check/fix:  move upstream for (re)use  - why? why not?
###   yes, fix - move to  csv in sportdb-structs!!!!


module Writer


def self.merge_goals( matches, goals )
  goals_by_match = goals.group_by { |rec| rec.match_id }
  puts "match goal reports - #{goals_by_match.size} records"

  ## lets group by date for easier lookup
  matches_by_date = matches.group_by { |rec| rec.date }


  ## note: "shadow / reuse" matches and goals vars for now in loop
  ##  find better names to avoid confusion!!
  goals_by_match.each_with_index do |(match_id, goals),i|
    ## split match_id
    team_str, more_str   = match_id.split( '|' )
    team1_str, team2_str = team_str.split( ' - ' )

    more_str  = more_str.strip
    team1_str = team1_str.strip
    team2_str = team2_str.strip

    ## for now assume date in more (and not round or something else)
    date_str = more_str  # e.g. in 2019-07-26 format

    puts ">#{team1_str}< - >#{team2_str}< | #{date_str},    #{goals.size} goals"

    ## try a join - find matching match
    matches = matches_by_date[ date_str ]
    if matches.nil?
      puts "!! ERROR: no match found for date >#{date_str}<"
      exit 1
    end

    found_matches = matches.select {|match| match.team1 == team1_str &&
                                            match.team2 == team2_str }

    if found_matches.size == 1
      match = found_matches[0]
      match.goals = SportDb::Import::Goal.build( goals )
    else
      puts "!!! ERROR: found #{found_matches.size} in #{matches.size} matches for date >#{date_str}<:"
      matches.each do |match|
        puts "  >#{match.team1}< - >#{match.team2}<"
      end
      exit 1
    end
  end
end



def self.build_goals( goals )
  ## todo/fix: for now assumes always minutes (without offset) - add offset support

  ## note: "fold" multiple goals by players
  team1_goals = {}
  team2_goals = {}
  goals.each do |goal|
    team_goals = goal.team == 1 ? team1_goals : team2_goals
    player_goals = team_goals[ goal.player ] ||= []
    player_goals << goal
  end

  buf = String.new
  if team1_goals.size > 0
    buf << build_goals_for_team( team1_goals )
  end

  ## note: only add a separator (;) if BOTH teams have goal scores
  if team1_goals.size > 0 && team2_goals.size > 0
    buf << '; '
  end

  if team2_goals.size > 0
    buf << build_goals_for_team( team2_goals )
  end
  buf
end


def self.build_goals_for_team( team_goals )
  buf = String.new
  team_goals.each_with_index do |(player_name, goals),i|
    buf << ' ' if i > 0
    buf << "#{player_name} "
    buf << goals.map do |goal|
                        str = "#{goal.minute}'"
                        str << "(og)"      if goal.owngoal?
                        str << "(p)"       if goal.penalty?
                        str
                     end.join( ', ' )
  end
  buf
end


end # module Writer