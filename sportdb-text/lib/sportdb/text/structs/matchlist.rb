# encoding: utf-8


module SportDb
  module Struct



class Matchlist  ## todo: find a better name - MatchStats, MatchFixtures, MatchSchedule, ...
                       ## use MatchCache/Buffer/Summary/Snippet/Segment/List...
                       ##    or MatchAnalyzer/Checker/Proofer/Query - why? why not?
  attr_reader :matches    # count of matches
              ## :name,
              ## :goals,     # count of (total) goals - use total_goals - why? why not?
              ## :teams, -- has its own reader
              ## :rounds     # note: use if all teams have same match count
 ## add last_updated/updated or something - why? why not?

  def initialize( matches )
    @matches = matches
  end


  def team_usage
    @team_usage ||= build_team_usage_in_matches_txt( @matches )
    @team_usage
  end

  def teams
    @team_names ||= team_usage.keys.sort
    @team_names
  end

  def goals
    @goals ||= calc_goals_in_matches_txt( @matches )
  end


## note: start_date and end_date might be nil / optional missing!!!!
  def start_date?
    if @has_start_date.nil?
      if @matches[0].date    ## todo/fix: use min/max for start date?
         @start_date     = Date.strptime( @matches[0].date, '%Y-%m-%d' )
         @has_start_date = true
      else
         @start_date     = nil
         @has_start_date = false
      end
    end
    @has_start_date
  end

  def start_date  ## todo/fix: scan all records/matches - remove "quick" hack !!!
    start_date?
    @start_date
  end

  def end_date?
    if @has_end_date.nil?
      if @matches[-1].date  ## todo/fix: use min/max for end date?
         @end_date     = Date.strptime( @matches[-1].date, '%Y-%m-%d' )
         @has_end_date = true
      else
         @end_date     = nil
         @has_end_date = false
      end
    end
    @has_end_date
  end

  def end_date   ## todo/fix: scan all records/matches - remove "quick" hack !!!
    ## return date as string as is - why? why not?
    end_date?
    @end_date
  end



  def rounds
    rounds?   ## note: use rounds? to calculate (cache) rounds
    @rounds   ## note: return number of rounds or nil (for uneven matches played by teams)
  end

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

end  # class Matchlist



  end # module Struct
end # module SportDb



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
