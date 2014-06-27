# encoding: utf-8

module SportDb

# todo: find a better name? to avoid confusing w/ GoalsParser? use MatchGoalsParser or similar?
class GoalsFinder
  include LogUtils::Logging
  include FixtureHelpers   # e.g. cut_off_end_of_line_comment!

  def initialize
    # nothing here for now
  end

  def find!( line, opts={} )
    # remove end-of-line comments
    #   - move to textutils ?? why? why not??
    cut_off_end_of_line_comment!( line )     ## note: func defined in utils.rb (FixtureHelpers)

    # remove [] if presents e.g. [Neymar 12']
    line = line.gsub( /[\[\]]/, '' )
    # remove (single match) if line starts w/ - (allow spaces)  e.g. [-;Neymar 12'] or [ - ;Neymar 12']
    line = line.sub( /^[ ]*-[ ]*/, '' )

    # split into left hand side (lhs) for team1 and
    #            right hand side (rhs) for team2

    values = line.split( ';' )
    
    # note: allow empty right hand side (e.g. team2 did NOT score any goals e.g. 3-0 etc.)
    lhs = values[0]
    rhs = values[1]

    lhs = lhs.strip   unless lhs.nil?
    rhs = rhs.strip   unless rhs.nil?

    parser = GoalsParser.new
    ## todo/check: only call if not nil?

    logger.debug "  lhs (team1): >#{lhs}<"
    lhs_data = parser.parse!( lhs )
    pp lhs_data

    logger.debug "  rhs (team2): >#{rhs}<"    
    rhs_data = parser.parse!( rhs )
    pp rhs_data

    ### merge into flat goal structs
    goals = []
    lhs_data.each do |player|
      player.minutes.each do |minute|
        goal = GoalStruct.new
        goal.name    = player.name
        goal.team    = 1
        goal.minute  = minute.minute
        goal.offset  = minute.offset
        goal.penalty = minute.penalty
        goal.owngoal = minute.owngoal
        goals << goal
      end
    end

    rhs_data.each do |player|
      player.minutes.each do |minute|
        goal = GoalStruct.new
        goal.name    = player.name
        goal.team    = 2
        goal.minute  = minute.minute
        goal.offset  = minute.offset
        goal.penalty = minute.penalty
        goal.owngoal = minute.owngoal
        goals << goal
      end
    end


    # sort by minute + offset
    goals = goals.sort do |l,r|
      res = l.minute <=> r.minute
      if res == 0 
        res =  l.offset <=> r.offset  # pass 2: sort by offset
      end
      res
    end

    ## calc score1,score2
    score1 = 0
    score2 = 0
    goals.each do |goal|
      if goal.team == 1
        score1 += 1
      elsif goal.team == 2
        score2 += 1
      else
        # todo: should not happen: issue warning
      end
      goal.score1 = score1
      goal.score2 = score2
    end

    logger.debug "  #{goals.size} goals:"
    pp goals

    goals
  end

end  # class GoalsFinder



class GoalsPlayerStruct
  ##
  # note: player with own goal (o.g) gets listed on other team
  #  (thus, player might have two entries if also scored for its own team)
  #
  attr_accessor :name
  attr_accessor :minutes   # ary of minutes e.g. 30', 45+2', 72'

  def initialize
    @minutes = []
  end
end


class GoalsMinuteStruct
  attr_accessor :minute, :offset
  attr_accessor :penalty, :owngoal    # flags

  def initialize
    @offset  = 0
    @penalty = false
    @owngoal = false
  end
end


class GoalStruct
  ######
  # flat struct for goals - one entry per goals
  attr_accessor :name
  attr_accessor :team   #  1 or 2 ? check/todo: add team1 or team2 flag?
  attr_accessor :minute, :offset
  attr_accessor :penalty, :owngoal
  attr_accessor :score1, :score2  # gets calculated

  ## add pos  for sequence number? e.g. 1,2,3,4  (1st goald, 2nd goal, etc.) ???

  def initialize
    # do nothing
  end
end




class GoalsParser
  include LogUtils::Logging


  # note: use ^ for start of string only!!!
  # - for now slurp everything up to digits (inlc. spaces - use strip to remove)
  NAME_REGEX = /^
                [^0-9]+
               /x


  MINUTES_REGEX = /^      # note: use ^ for start of string only!!!
                    (?<minute>[0-9]{1,3})
                    (?:\+
                      (?<offset>[1-9]{1})
                    )?
                    '
                    (?:[ ]*
                      \(
                      (?<type>P|pen\.|o\.g\.)
                      \)
                    )?
                  /x



  def initialize
    # nothing here for now
  end

  def parse!( line, opts={} )

    ## for now assume
    ##    everything up-to  0-9 and , and () is part of player name 

    ## try parsing lhs
    ##  todo: check for  empty -    remove (make it same as empty string)

    players = []

    name = get_player_name!( line )
    while name
      logger.debug "  found player name >#{name}< - remaining >#{line}<"
      
      player = GoalsPlayerStruct.new
      player.name = name
      
      minute_hash = get_minute_hash!( line )
      while minute_hash
        logger.debug "  found minutes >#{minute_hash.inspect}< - remaining >#{line}<"

        minute = GoalsMinuteStruct.new
        minute.minute = minute_hash[:minute].to_i
        minute.offset = minute_hash[:offset].to_i  if minute_hash[:offset]
        if minute_hash[:type]
          minute.owngoal = true  if minute_hash[:type] =~ /o\.g\./
          minute.penalty = true  if minute_hash[:type] =~ /P|pen\./
        end
        player.minutes << minute

        # remove commas and spaces (note: use ^ for start of string only!!!)
        line.sub!( /^[ ,]+/, '' )
        minute_hash = get_minute_hash!( line )
      end
      
      players << player
      name = get_player_name!( line )
    end

    players
  end   # method parse!

private
  def get_player_name!( line )
    m = NAME_REGEX.match( line )
    if m
      ## remove from line
      line.slice!( 0...m[0].length )
      m[0].strip    # remove leading and trailing spaces
    else
      nil
    end
  end

  def get_minute_hash!( line )
    m = MINUTES_REGEX.match( line ) # note: use ^ for start of string only!!!
    if m
      h = {}
      # - note: do NOT forget to turn name into symbol for lookup in new hash (name.to_sym)
      m.names.each { |n| h[n.to_sym] = m[n] } # or use match_data.names.zip( match_data.captures ) - more cryptic but "elegant"??

      ## remove matched string from line
      line.slice!( 0...m[0].length )
      h
    else
      nil
    end
  end

end # class GoalsParser

end # module SportDb
