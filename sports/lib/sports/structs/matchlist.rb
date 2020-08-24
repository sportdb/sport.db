

module Sports


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


  def usage
    @usage ||= build_usage( @matches )
    @usage
  end

  def team_usage() usage.team_usage; end

  def teams
    @team_names ||= team_usage.keys.sort
    @team_names
  end

  def goals() usage.goals; end

  ## note: start_date and end_date might be nil / optional missing!!!!
  def start_date?() usage.start_date?; end
  def end_date?()   usage.end_date?; end

  def start_date()  usage.start_date; end
  def end_date()    usage.end_date; end

  def has_dates?()  usage.has_dates?; end
  def dates_str()   usage.dates_str; end
  def days()        usage.days; end


  def rounds() usage.rounds; end

  ## todo: add has_rounds? alias for rounds? too
  ## return true if all match_played in team_usage are the same
  ##  e.g. assumes league with matchday rounds
  def rounds?() usage.rounds?; end

  def match_counts() usage.match_counts; end
  def match_counts_str() usage.match_counts_str; end



  def stage_usage
    @stage_usage ||= build_stage_usage( @matches )
    @stage_usage
  end

  def stages() stage_usage.keys; end  ## note: returns empty array for stages for now - why? why not?


############################
#  matchlist helpers
private
  class StatLine
     attr_reader :team_usage,
                 :matches,
                 :goals,
                 :rounds,   ## keep rounds - why? why not?
                 :start_date,
                 :end_date

     def teams() @team_usage.keys.sort; end   ## (auto-)sort here always - why? why not?

     def start_date?() @start_date.nil? == false; end
     def end_date?()   @end_date.nil? == false; end

     def has_dates?()  @start_date && @end_date; end
     def dates_str
       ## note: start_date/end_date might be optional/missing
       if has_dates?
         "#{start_date.strftime( '%a %d %b %Y' )} - #{end_date.strftime( '%a %d %b %Y' )}"
       else
         "??? - ???"
       end
     end

    def days() end_date.jd - start_date.jd; end


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
          if match_counts.size == 1
            @rounds = match_counts[0][0]
          else
            @rounds = nil
          end
          @has_rounds = @rounds ? true : false
       end
       @has_rounds
    end


    def build_match_counts   ## use/rename to matches_played - why? why not?
      counts = Hash.new(0)
      team_usage.values.each do |count|
        counts[count] += 1
      end

      ## sort (descending) highest usage value first (in returned array)
      ##  e.g. [[32,8],[31,2]]  ## 32 matches by 8 teams, 31 matches by 2 teams etc.
      counts.sort_by {|count, usage| -count }
    end

    def match_counts
      # match counts / nos played per team
      @match_counts ||= build_match_counts
      @match_counts
    end

    def match_counts_str
      ## pretty print / formatted match_counts
      buf = String.new('')
      match_counts.each_with_index do |rec,i|
        buf << ' '  if i > 0   ## add (space) separator
        buf << "#{rec[0]}×#{rec[1]}"
      end
      buf
    end



     def initialize
        @matches    = 0
        @goals      = 0

        @start_date = nil
        @end_date   = nil

        @team_usage = Hash.new(0)

        @match_counts = nil
     end


     def update( match )
        @matches += 1    ## match counter

        if match.score1 && match.score2
          @goals += match.score1
          @goals += match.score2

          ## todo: add after extra time? if knock out (k.o.) - why? why not?
          ##   make it a flag/opt?
        end

        @team_usage[ match.team1 ] += 1
        @team_usage[ match.team2 ] += 1

        if match.date
          ## return / store date as string as is - why? why not?
          date = Date.strptime( match.date, '%Y-%m-%d' )

          @start_date = date  if @start_date.nil? || date < @start_date
          @end_date   = date  if @end_date.nil?   || date > @end_date
        end
     end
  end  # class StatLine


  ## collect total usage stats (for all matches)
  def build_usage( matches )
    stat = StatLine.new
    matches.each do |match|
      stat.update( match )
    end
    stat
  end

  ## collect usage stats by stage (e.g. regular / playoff / etc.)
  def build_stage_usage( matches )
    stages = {}

    matches.each do |match|
       stage_key = if match.stage.nil?
                     'Regular'  ## note: assume Regular stage if not defined (AND not explicit unknown)
                   else
                     match.stage
                   end

        stages[ stage_key ] ||= StatLine.new
        stages[ stage_key ].update( match )
    end

    stages
  end

end  # class Matchlist

end # module Sports
