# encoding: utf-8

module SportDb
  module Import


## "free-standing" goal event - for import/export  in separate event / goal datafiles
##   returned by CsvGoalParser and others
class GoalEvent

  def self.build( row )  ## rename to parse or such - why? why not?

  ## split match_id
  team_str, more_str   = row['Match'].split( '|' )
  team1_str, team2_str = team_str.split( ' - ' )

  more_str  = more_str.strip
  team1_str = team1_str.strip
  team2_str = team2_str.strip

   # check if more_str is a date otherwise assume round
   date_fmt = if more_str =~ /^[A-Z]{3} [0-9]{1,2}$/i  ## Apr 4
                '%b %d'
              elsif more_str =~ /^[A-Z]{3} [0-9]{1,2} [0-9]{4}$/i  ## Apr 4 2019
                '%b %d %Y'
             else
                nil
             end

   if date_fmt
    date  = Date.strptime( more_str, date_fmt )
    round = nil
   else
    date  = nil
    round = more_str
   end


    values = row['Score'].split('-')
    values = values.map { |value| value.strip }
    score1 = values[0].to_i
    score2 = values[1].to_i

    minute = nil
    offset = nil
    if m=%r{([0-9]+)
              (?:[ ]+
                   \+([0-9]+)
                )?
                ['.]
          $}x.match( row['Minute'])
      minute = $1.to_i
      offset = $2 ? $2.to_i : nil
    else
      puts "!! ERROR - unsupported minute (goal) format >#{row['Minute']}<"
      exit 1
    end

    attributes = {
          team1:  team1_str,
          team2:  team2_str,
          date:   date,
          round:  round,
          score1: score1,
          score2: score2,
          minute: minute,
          offset: offset,
          player: row['Player'],
          owngoal: ['(og)', '(o.g.)'].include?( row['Extra']),
          penalty: ['(pen)', '(pen.)'].include?( row['Extra']),
          notes:   (row['Notes'].nil? || row['Notes'].empty?) ? nil : row['Notes']
        }

    new( **attributes )
  end


  ## match id
  attr_reader  :team1,
               :team2,
               :round,  ## optional
               :date   ## optional

  ## main attributes
  attr_reader :score1,
              :score2,
              :player,
              :minute,
              :offset,
              :owngoal,
              :penalty,
              :notes


  ## todo/check: or just use match.hash or such if match mapping known - why? why not?
  def match_id
    if round
      "#{@team1} - #{@team2} | #{@round}"
    else
      "#{@team1} - #{@team2} | #{@date}"
    end
  end


  def owngoal?() @owngoal==true; end
  def penalty?() @penalty==true; end

  def initialize( team1:,
                  team2:,
                  round:   nil,
                  date:    nil,
                  score1:,
                  score2:,
                  player:,
                  minute:,
                  offset:  nil,
                  owngoal: false,
                  penalty: false,
                  notes:   nil
                )
    @team1   = team1
    @team2   = team2
    @round   = round
    @date    = date

    @score1  = score1
    @score2  = score2
    @player  = player
    @minute  = minute
    @offset  = offset
    @owngoal = owngoal
    @penalty = penalty
    @notes   = notes
  end


  ## note: lets you use normalize teams or such acts like a Match struct
  def update( **kwargs )
    ## todo/fix: use team1_name, team2_name or similar - for compat with db activerecord version? why? why not?
    @team1 = kwargs[:team1]    if kwargs.has_key? :team1
    @team2 = kwargs[:team2]    if kwargs.has_key? :team2
  end
end  # class GoalEvent




class Goal  ### nested (non-freestanding) inside match (match is parent)
  def self.build( events )  ## check/todo - rename to build_from_event/row or such - why? why not?
    ## build an array of goal structs from (csv) recs
    recs = []

    last_score1 = 0
    last_score2 = 0

    events.each do |event|

      if last_score1+1 == event.score1 && last_score2 == event.score2
        team = 1
      elsif last_score2+1 == event.score2 && last_score1 == event.score1
        team = 2
      else
        puts "!! ERROR - unexpected score advance (one goal at a time expected):"
        puts "  #{last_score1}-#{last_score2}=> #{event.score1}-#{event.score2}"
        exit 1
      end

      last_score1 = event.score1
      last_score2 = event.score2


      attributes = {
        score1:  event.score1,
        score2:  event.score2,
        team:    team,
        minute:  event.minute,
        offset:  event.offset,
        player:  event.player,
        owngoal: event.owngoal?,
        penalty: event.penalty?,
        notes:   event.notes
      }

      recs << Goal.new( **attributes )
    end

    recs
  end



  attr_reader :score1,
              :score2,
              :team,
              :player,
              :minute,
              :offset,
              :owngoal,
              :penalty,
              :notes



  def owngoal?() @owngoal==true; end
  def penalty?() @penalty==true; end
  def team1?()   @team == 1; end
  def team2?()   @team == 2; end

  def initialize( score1:,
                  score2:,
                  team:,
                  player:,
                  minute:,
                  offset:  nil,
                  owngoal: false,
                  penalty: false,
                  notes:   nil
                )
    @score1  = score1
    @score2  = score2
    @team    = team     # 1 or 2
    @player  = player
    @minute  = minute
    @offset  = offset
    @owngoal = owngoal
    @penalty = penalty
    @notes   = notes
  end
end # class Goal



class Match

  attr_reader :date,
              :team1,     :team2,      ## todo/fix: use team1_name, team2_name or similar - for compat with db activerecord version? why? why not?
              :score1,    :score2,     ## full time
              :score1i,   :score2i,    ## half time (first (i) part)
              :score1et,  :score2et,   ## extra time
              :score1p,   :score2p,    ## penalty
              :score1agg, :score2agg,  ## full time (all legs) aggregated
              :winner,    # return 1,2,0   1 => team1, 2 => team2, 0 => draw/tie
              :round,     ## todo/fix:  use round_num or similar - for compat with db activerecord version? why? why not?
              :leg,      ## e.g. '1','2','3','replay', etc.   - use leg for marking **replay** too - keep/make leg numeric?! - why? why not?
              :stage,
              :group,
              :status,    ## e.g. replay, cancelled, awarded, abadoned, postponed, etc.
              :conf1,    :conf2,      ## special case for mls e.g. conference1, conference2 (e.g. west, east, central)
              :country1, :country2,    ## special case for champions league etc. - uses FIFA country code
              :comments,
              :league      ## (optinal) added as text for now (use struct?)


  attr_accessor :goals  ## todo/fix: make goals like all other attribs!!

  def initialize( **kwargs )
    update( kwargs )  unless kwargs.empty?
  end

  def update( **kwargs )
    ## note: check with has_key?  because value might be nil!!!
    @date     = kwargs[:date]     if kwargs.has_key? :date

    ## todo/fix: use team1_name, team2_name or similar - for compat with db activerecord version? why? why not?
    @team1    = kwargs[:team1]    if kwargs.has_key? :team1
    @team2    = kwargs[:team2]    if kwargs.has_key? :team2

    @conf1    = kwargs[:conf1]    if kwargs.has_key? :conf1
    @conf2    = kwargs[:conf2]    if kwargs.has_key? :conf2
    @country1 = kwargs[:country1]  if kwargs.has_key? :country1
    @country2 = kwargs[:country2]  if kwargs.has_key? :country2

    ## note: round is a string!!!  e.g. '1', '2' for matchday or 'Final', 'Semi-final', etc.
    ##   todo: use to_s - why? why not?
    @round    = kwargs[:round]    if kwargs.has_key? :round
    @stage    = kwargs[:stage]    if kwargs.has_key? :stage
    @leg      = kwargs[:leg]      if kwargs.has_key? :leg
    @group    = kwargs[:group]    if kwargs.has_key? :group
    @status   = kwargs[:status]   if kwargs.has_key? :status
    @comments = kwargs[:comments] if kwargs.has_key? :comments

    @league   = kwargs[:league]   if kwargs.has_key? :league


    if kwargs.has_key?( :score )   ## check all-in-one score struct for convenience!!!
      score = kwargs[:score]
      if score.nil?   ## reset all score attribs to nil!!
        @score1     = nil
        @score1i    = nil
        @score1et   = nil
        @score1p    = nil
        ## @score1agg  = nil

        @score2     = nil
        @score2i    = nil
        @score2et   = nil
        @score2p    = nil
        ## @score2agg  = nil
      else
        @score1     = score.score1
        @score1i    = score.score1i
        @score1et   = score.score1et
        @score1p    = score.score1p
        ## @score1agg  = score.score1agg

        @score2     = score.score2
        @score2i    = score.score2i
        @score2et   = score.score2et
        @score2p    = score.score2p
        ## @score2agg  = score.score2agg
      end
    else
      @score1     = kwargs[:score1]      if kwargs.has_key? :score1
      @score1i    = kwargs[:score1i]     if kwargs.has_key? :score1i
      @score1et   = kwargs[:score1et]    if kwargs.has_key? :score1et
      @score1p    = kwargs[:score1p]     if kwargs.has_key? :score1p
      @score1agg  = kwargs[:score1agg]   if kwargs.has_key? :score1agg

      @score2     = kwargs[:score2]      if kwargs.has_key? :score2
      @score2i    = kwargs[:score2i]     if kwargs.has_key? :score2i
      @score2et   = kwargs[:score2et]    if kwargs.has_key? :score2et
      @score2p    = kwargs[:score2p]     if kwargs.has_key? :score2p
      @score2agg  = kwargs[:score2agg]   if kwargs.has_key? :score2agg

      ## note: (always) (auto-)convert scores to integers
      @score1     = @score1.to_i      if @score1
      @score1i    = @score1i.to_i     if @score1i
      @score1et   = @score1et.to_i    if @score1et
      @score1p    = @score1p.to_i     if @score1p
      @score1agg  = @score1agg.to_i   if @score1agg

      @score2     = @score2.to_i      if @score2
      @score2i    = @score2i.to_i     if @score2i
      @score2et   = @score2et.to_i    if @score2et
      @score2p    = @score2p.to_i     if @score2p
      @score2agg  = @score2agg.to_i   if @score2agg
    end

    ## todo/fix:
    ##  gr-greece/2014-15/G1.csv:
    ##     G1,10/05/15,Niki Volos,OFI,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
    ##

    ##  for now score1 and score2 must be present
    if @score1.nil? || @score2.nil?
      puts "** WARN: missing scores for match:"
      pp kwargs
      ## exit 1
    end

    ## todo/fix: auto-calculate winner
    # return 1,2,0   1 => team1, 2 => team2, 0 => draw/tie
    ### calculate winner - use 1,2,0
    if @score1 && @score2
       if @score1 > @score2
          @winner = 1
       elsif @score2 > @score1
          @winner = 2
       elsif @score1 == @score2
          @winner = 0
       else
       end
    else
      @winner = nil   # unknown / undefined
    end

    self   ## note - MUST return self for chaining
  end



  def over?()      true; end  ## for now all matches are over - in the future check date!!!
  def complete?()  true; end  ## for now all scores are complete - in the future check scores; might be missing - not yet entered


  def score_str    # pretty print (full time) scores; convenience method
    "#{@score1}-#{@score2}"
  end

  def scorei_str    # pretty print (half time) scores; convenience method
    "#{@score1i}-#{@score2i}"
  end
end  # class Match

end # module Import
end # module SportDb
