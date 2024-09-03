
module Sports

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
      minute = m[1].to_i
      offset = m[2] ? m[2].to_i : nil
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


### extend "basic" goal struct with goal event build
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
        owngoal: event.owngoal,
        penalty: event.penalty,
        notes:   event.notes
      }

      recs << new( **attributes )
    end

    recs
  end
end  # class Goal


end # module Sports



