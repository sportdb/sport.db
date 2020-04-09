###
#  moved "global" helpers into matchlist

###########################
# match.txt helpers
#
#  todo/fix: move into Matchlist !!!!!!!!!!!!!!!!!!!!!!!!


def build_team_usage_in_matches_txt( matches )

    teams = Hash.new( 0 )   ## default value is 0
  
    matches.each_with_index do |match,i|
      teams[ match.team1 ] += 1
      teams[ match.team2 ] += 1
    end
  
    teams
  end
  
  
  def calc_goals_in_matches_txt( matches )
    ## total goals
    goals = 0
    matches.each_with_index do |match|
      if match.score1 && match.score2
        goals += match.score1
        goals += match.score2
  
        ## todo: add after extra time? if knock out (k.o.) - why? why not?
        ##   make it a flag/opt?
      end
    end
    goals
  end
  
  
  
  def find_teams_in_matches_txt( matches )
  
    teams = Hash.new( 0 )   ## default value is 0
  
    matches.each_with_index do |match,i|
      teams[ match.team1 ] += 1
      teams[ match.team2 ] += 1
    end
  
    pp teams
  
    ## note: only return team names (not hash with usage counter)
    teams.keys
  end
  

  ##############
   old rounds?  without match_counts array
      ## todo: add has_rounds? alias for rounds? too
      def rounds?
        ## return true if all match_played in team_usage are the same
        ##  e.g. assumes league with matchday rounds
        if @has_rounds.nil?    ## check/todo: if undefined attribute is nil by default??
           ## check/calc rounds
           ##  note: values => matches_played by team
           matches_played = team_usage.values.uniq
           if matches_played.size == 1
             @rounds = matches_played[0]
           else
             @rounds = nil
           end
           @has_rounds = @rounds ? true : false
        end
        @has_rounds
     end
 