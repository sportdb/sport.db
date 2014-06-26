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

    logger.debug "  rhs (team2): >#{rhs}<"    
    rhs_data = parser.parse!( rhs )
    
    ## todo: what to return?
  end

end  # class GoalsFinder



class GoalsParser
  include LogUtils::Logging


  # note: use ^ for start of string only!!!
  # - for now slurp everything up to digits (inlc. spaces - use strip to remove)
  NAME_REGEX = /^
                [^0-9]+
               /x


  MINUTES_REGEX = /^      # note: use ^ for start of string only!!!
                    [0-9]{1,3}
                    (\+[0-9]{1})?
                    '
                    ([ ]*
                      \(
                      (P|pen\.|o\.g\.)
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

    name = get_name!( line )
    while name
      logger.debug "  found player name >#{name}< - remaining >#{line}<"
      minutes = get_minutes!( line )
      while minutes
        logger.debug "  found minutes >#{minutes}< - remaining >#{line}<"
        # remove commas and spaces (note: use ^ for start of string only!!!)
        line.sub!( /^[ ,]+/, '' )
        minutes = get_minutes!( line )
      end
      name = get_name!( line )
    end
    
  end   # method parse!

private
  def get_name!( line )
    m = NAME_REGEX.match( line )
    if m
      name = m[0]
      ## remove from line
      line.slice!( 0...name.length )
      name = name.strip    # remove leading and trailing spaces
      name
    else
      nil
    end
  end

  def get_minutes!( line )
    m = MINUTES_REGEX.match( line ) # note: use ^ for start of string only!!!
    if m
      minutes = m[0]
      ## remove from line
      line.slice!( 0...minutes.length )
      minutes = minutes.strip  # remove leading and trailing spaces
      minutes
    else
      nil
    end
  end

end # class GoalsParser

end # module SportDb
