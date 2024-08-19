
module SportDb

class MatchParserV2    ## simple match parser for team match schedules


  def self.parse( lines, start: )
    ##  todo/fix: add support for txt and lines
    ##    check if lines_or_txt is an array or just a string
    ##   use teams: like start:  why? why not?
    parser = new( lines, start )
    parser.parse
  end


  include Logging         ## e.g. logger#debug, logger#info, etc.

  def self.debug=(value) @@debug = value; end
  def self.debug?() @@debug ||= false; end  ## note: default is FALSE
  def debug?()  self.class.debug?; end

  def _read_lines( txt )   ## todo/check:  add alias preproc_lines or build_lines or prep_lines etc. - why? why not?
    ## returns an array of lines with comments and empty lines striped / removed
    lines = []
    txt.each_line do |line|    ## preprocess
       line = line.strip

       next if line.empty? || line.start_with?('#')   ###  skip empty lines and comments
       line = line.sub( /#.*/, '' ).strip             ###  cut-off end-of line comments too
       lines << line
    end
    lines
  end


  ## note:  colon (:) MUST be followed by one (or more) spaces
  ##      make sure mon feb 12 18:10 will not match
  ##        allow 1. FC Köln etc.
  ##               Mainz 05:
  ##           limit to 30 chars max
  ##          only allow  chars incl. intl buut (NOT ()[]/;)
  ##
  ##   Group A:
  ##   Group B:   - remove colon
  ##    or lookup first

  ATTRIB_RE = %r{^
                   [ ]*?     # slurp leading spaces
                (?<key>[^:|\]\[()\/; -]
                       [^:|\]\[()\/;]{0,30}
                 )
                   [ ]*?     # slurp trailing spaces
                   :[ ]+
                (?<value>.+)
                    [ ]*?   # slurp trailing spaces
                   $
                }ix

  #
  # todo/fix: change start to start: too!!!
  #       might be optional in the future!! - why? why not?

  def initialize( lines, start )
    # for convenience split string into lines
    ##    note: removes/strips empty lines
    ## todo/check: change to text instead of array of lines - why? why not?

    ## note - wrap in enumerator/iterator a.k.a lines reader
    @lines = lines.is_a?( String ) ?
                    _read_lines( lines ) : lines

    @start        = start
  end


  def parse
    @last_date    = nil
    @last_time    = nil
    @last_round   = nil
    @last_group   = nil

    @last_goals   = 1    ## toggle between 1|2  - hacky (quick & dirty) support for multi-line goals, fix soon!

    @teams   = Hash.new(0)   ## track counts (only) for now for (interal) team stats - why? why not?
    @rounds  = {}
    @groups  = {}
    @matches = []

    @warns        = []    ## track list of warnings (unmatched lines)  too - why? why not?



    @parser = Parser.new

    @errors = []
    @tree   = []

    attrib_found = false

    @lines.each_with_index do |line,i|

         if debug?
           puts
           puts "line >#{line}<"
         end

          ## skip new (experimental attrib syntax)
          if attrib_found == false &&
              ATTRIB_RE.match?( line )
            ## note: check attrib regex AFTER group def e.g.:
            ##         Group A:
            ##         Group B:  etc.
            ##     todo/fix - change Group A: to Group A etc.
            ##                       Group B: to Group B
             attrib_found = true
             ## logger.debug "skipping key/value line - >#{line}<"
             next
          end

          if attrib_found
            ## check if line ends with dot
            ##  if not slurp up lines to the next do!!!
            ## logger.debug "skipping key/value line - >#{line}<"
            attrib_found = false   if line.end_with?( '.' )
                # logger.debug "skipping key/value line (cont.) - >#{line}<"
            next
          end

          t, error_messages  =  @parser.parse_with_errors( line )


           if error_messages.size > 0
              ## add to "global" error list
              ##   make a triplet tuple (file / msg / line text)
              error_messages.each do |msg|
                  @errors << [ '<file>',  ## add filename here
                               msg,
                               line
                             ]
              end
           end

           pp t   if debug?

           @tree << t
    end  # each lines

    ## pp @tree

    ## report parse errors here - why? why not?



    @tree.each do |nodes|

        node_type = nodes[0][0]  ## get node type of first/head node

       if node_type == :round_def
        ## todo/fix:  add round definition (w begin n end date)
        ## todo: do not patch rounds with definition (already assume begin/end date is good)
        ##  -- how to deal with matches that get rescheduled/postponed?
        parse_round_def( nodes )
       elsif node_type == :group_def  ## NB: group goes after round (round may contain group marker too)
        ### todo: add pipe (|) marker (required)
        parse_group_def( nodes )

       elsif node_type == :player
        ## note - for now goals line MUST start with player!!
        parse_goals( nodes )
       else
        ## try to be liberal/flexible
        ##  eat-up nodes as we go
        ##  assume match with group / round header
        ##   etc. on its own line or not

        ## preprocess possible before match nodes

        while !nodes.empty? do
             node_type = nodes[0][0]  ## get node type of first/head node
             if node_type == :round
                node = nodes.shift   ## eat-up
                parse_round_header( node )
            elsif node_type == :group
                ##  -- lets you set group  e.g. Group A etc.
                node = nodes.shift   ## eat-up
                parse_group_header( node )
            elsif node_type == :date
                node = nodes.shift   ## eat-up
                parse_date_header( node )
            ## add time here too - why? why not?
            ## add skip comma separator here too - why? why not?
            ##  "slurp-up" in upstream parser?
            ##  e.g.   round, group  or group, round ?
            else
                break
            end
        end
        next if nodes.empty?

        ## rename to try_parse_match - why? why not?
        parse_match( nodes )
      end

      end  # tree.each

    ## note - team keys are names and values are "internal" stats!!
    ##                      and NOT team/club/nat_team structs!!
    [@teams.keys, @matches, @rounds.values, @groups.values]
  end # method parse



  def parse_group_header( node )
    logger.debug "parsing group header: >#{node}<"

    # note: group header resets (last) round  (allows, for example):
    #  e.g.
    #  Group Playoffs/Replays       -- round header
    #    team1 team2                -- match
    #  Group B                      -- group header
    #    team1 team2 - match  (will get new auto-matchday! not last round)
    @last_round     = nil

    name = node[1]

    group = @groups[ name ]
    if group.nil?
      puts "!! PARSE ERROR - no group def found for >#{name}<"
      exit 1
    end

    # set group for games
    @last_group = group
  end


  def parse_group_def( nodes )
    logger.debug "parsing group def: >#{nodes}<"

   ## e.g
   ##  [:group_def, "Group A"],
   ##   [:team, "Germany"],
   ##   [:team, "Scotland"],
   ##   [:team, "Hungary"],
   ##   [:team, "Switzerland"]

    node = nodes[0]
    name = node[1]   ## group name

    teams = nodes[1..-1].map do |node|
                                  if node[0] == :team
                                       team = node[1]
                                       @teams[ team ] += 1
                                       team
                                  else
                                     puts "!! PARSE ERROR - only teams expected in group def; got:"
                                     pp nodes
                                     exit 1
                                  end
                             end

    ## todo/check/fix: add back group key - why? why not?
    group = Import::Group.new( name:  name,
                               teams: teams )

    @groups[ name ] = group
  end


  def _build_date( m:, d:, y:, start:  )

    if y.nil?   ## try to calculate year
      y =  if  m > start.month ||
               (m == start.month && d >= start.day)
                # assume same year as start_at event (e.g. 2013 for 2013/14 season)
                start.year
           else
                 # assume year+1 as start_at event (e.g. 2014 for 2013/14 season)
                start.year+1
           end
    end

      Date.new( y,m,d )  ## y,m,d
  end

  def parse_round_def( nodes )
    logger.debug "parsing round def: >#{nodes}<"

    ## e.g. [[:round_def, "Matchday 1"], [:duration, "Fri Jun/14 - Tue Jun/18"]]
    ##      [[:round_def, "Matchday 2"], [:duration, "Wed Jun/19 - Sat Jun/22"]]
    ##      [[:round_def, "Matchday 3"], [:duration, "Sun Jun/23 - Wed Jun/26"]]

    node = nodes[0]
    name  = node[1]
    # NB: use extracted round name for knockout check
    # knockout_flag = is_knockout_round?( name )

    node = nodes[1]
    node_type = node[0]
    if node_type == :date
        start_date = end_date = _build_date( m: node[2][:m],
                                             d: node[2][:d],
                                             y: node[2][:y],
                                              start: @start)
    elsif node_type == :duration
      start_date  = _build_date( m: node[2][:start][:m],
                                 d: node[2][:start][:d],
                                 y: node[2][:start][:y],
                                   start: @start)
      end_date    = _build_date( m: node[2][:end][:m],
                                 d: node[2][:end][:d],
                                 y: node[2][:end][:y],
                                   start: @start)
    else
       puts "!! PARSE ERROR - expected date or duration for round def; got:"
       pp nodes
       exit 1
    end

    # note: - NOT needed; start_at and end_at are saved as date only (NOT datetime)
    #  set hours,minutes,secs to beginning and end of day (do NOT use default 12.00)
    #   e.g. use 00.00 and 23.59
    # start_at = start_at.beginning_of_day
    # end_at   = end_at.end_of_day

    # note: make sure start_at/end_at is date only (e.g. use start_at.to_date)
    #   sqlite3 saves datetime in date field as datetime, for example (will break date compares later!)

    # note - _build_date always returns Date for now - no longer needed!!
    # start_date = start_date.to_date
    #  end_date   = end_date.to_date


    ## fix:
    ##  remove knockout_flag - why? why not?
    knockout_flag = false


    logger.debug "    start_date: #{start_date}"
    logger.debug "    end_date:   #{end_date}"
    logger.debug "    name:    >#{name}<"
    logger.debug "    knockout_flag:   #{knockout_flag}"

    round = Import::Round.new( name:       name,
                               start_date: start_date,
                               end_date:   end_date,
                               knockout:   knockout_flag,
                               auto:       false )

    @rounds[ name ] = round
  end


  def parse_round_header( node )
    logger.debug "parsing round header: >#{node}<"

    name = node[1]

    # name = name.sub( ROUND_EXTRA_WORDS_RE, '' )
    # name = name.strip

    round = @rounds[ name ]
    if round.nil?    ## auto-add / create if missing
      ## todo/check: add num (was pos) if present - why? why not?
      round = Import::Round.new( name: name )
      @rounds[ name ] = round
    end

    ## todo/check: if pos match (MUST always match for now)
    @last_round = round
    @last_group = nil   # note: reset group to no group - why? why not?

    ## todo/fix/check
    ##  make round a scope for date(time) - why? why not?
    ##   reset date/time e.g. @last_date = nil !!!!
  end

  def parse_date_header( node )
    logger.debug( "date header: >#{node}<")

    date = _build_date( m: node[2][:m],
                        d: node[2][:d],
                        y: node[2][:y],
                        start: @start )

    logger.debug( "    date: #{date} with start: #{@start}")

      @last_date = date   # keep a reference for later use
      @last_time = nil

      ###  quick "corona" hack - support seasons going beyond 12 month (see swiss league 2019/20 and others!!)
      ##    find a better way??
      ##  set @start date to full year (e.g. 1.1.) if date.year  is @start.year+1
      ##   todo/fix: add to linter to check for chronological dates!! - warn if NOT chronological
      ###  todo/check: just turn on for 2019/20 season or always? why? why not?

      ## todo/fix: add switch back to old @start_org
      ##   if year is date.year == @start.year-1    -- possible when full date with year set!!!
=begin
      if @start.month != 1
         if date.year == @start.year+1
           logger.debug( "!! hack - extending start date to full (next/end) year; assumes all dates are chronologigal - always moving forward" )
           @start_org = @start   ## keep a copy of the original (old) start date - why? why not? - not used for now
           @start = Date.new( @start.year+1, 1, 1 )
         end
      end
=end
  end

  def parse_minutes( nodes )
    ## parse goals by player
    ##   may have multiple minutes!!
    goals = []

    node = nodes.shift  ## get player
    name = node[1]

    loop do
      goal = {}
      goal[:name]  = name

      node_type = nodes[0][0]
      if node_type != :minute
        puts "!! PARSE ERROR - minute expected to follow player (in goal); got #{node_type}:"
        pp nodes
        exit 1
      end

      node = nodes.shift
      goal[:minute] =  node[2][:m]
      goal[:offset] =  node[2][:offset]  if node[2][:offset]

      ## check for own goal or penalty or such
      if !nodes.empty?
        node_type = nodes[0][0]
        if node_type == :og
         nodes.shift
         goal[:og] = true
        elsif node_type == :pen
         nodes.shift
         goal[:pen] = true
        else
          # do nothing
        end
      end

      goals << goal

      ## check if another minute ahead; otherwise break
      break  if nodes.empty?

      node_type = nodes[0][0]
      break  if node_type != :minute
    end


    goals
  end


  def parse_goals( nodes )
    logger.debug "parse goals: >#{nodes}<"

    goals1 = []
    goals2 = []

    while !nodes.empty?
        node_type = nodes[0][0]
        if node_type == :player
           more_goals = parse_minutes( nodes )
           ## hacky multi-line support for goals
           ##   using last_goal (1|2)
           @last_goals == 2 ?  goals2 += more_goals :
                               goals1 += more_goals
        elsif node_type == :';'   ## team separator
            nodes.shift  # eat-up
            @last_goals = 2
        else
          puts "!! PARSE ERROR - unexpected node type in goals;; got #{node_type}:"
          pp nodes
          exit 1
        end
    end

    pp [goals1,goals2]

## wrap in struct andd add/append to match
=begin
class GoalStruct
  ######
  # flat struct for goals - one entry per goals
  attr_accessor :name
  attr_accessor :team   #  1 or 2 ? check/todo: add team1 or team2 flag?
  attr_accessor :minute, :offset
  attr_accessor :penalty, :owngoal
  attr_accessor :score1, :score2  # gets calculated
=end

    goals = []
    goals1.each do |rec|
      goal = GoalStruct.new
      goal.name    = rec[:name]
      goal.team    = 1
      goal.minute  = rec[:minute]
      goal.offset  = rec[:offset]   if rec[:offset]
      goal.penalty = rec[:pen]      if rec[:pen]
      goal.owngoal = rec[:og]       if rec[:og]
      goals << goal
    end
    goals2.each do |rec|
      goal = GoalStruct.new
      goal.name    = rec[:name]
      goal.team    = 2
      goal.minute  = rec[:minute]
      goal.offset  = rec[:offset]   if rec[:offset]
      goal.penalty = rec[:pen]      if rec[:pen]
      goal.owngoal = rec[:og]       if rec[:og]
      goals << goal
    end

    pp goals

    ## quick & dirty - auto add goals to last match
    ##   note - for hacky (quick& dirty) multi-line support
    ##     always append for now
    match = @matches[-1]
    match.goals ||= []
    match.goals += goals

    ## todo/fix
    ##   sort by minute
    ##    PLUS auto-fill score1,score2 - why? why not?
  end


  def parse_match( nodes )
    logger.debug( "parse match: >#{nodes}<" )

    ## collect (possible) nodes by type
    num   = nil
    date  = nil
    time  = nil
    teams = []
    score = nil
    more  = []

    while !nodes.empty?
        node = nodes.shift
        node_type = node[0]

        if node_type == :num
            num = node[1]
        elsif node_type == :date
            ## note: date wipes out/clear time
            ##   time MUST always come after date
            time = nil
            date = _build_date( m: node[2][:m],
                                d: node[2][:d],
                                y: node[2][:y],
                                start: @start )
        elsif node_type == :time
            ## note - there's no time (-only) type in ruby
            ##  use string (e.g. '14:56', '1:44')
            ##   use   01:44 or 1:44 ?
            ##  check for 0:00 or 24:00  possible?
            time = '%d:%02d' % [node[2][:h], node[2][:m]]
        elsif node_type == :team
            teams << node[1]
        elsif node_type == :score
            ### todo/fix
            ##    add keywords (e.g. ht, ft or such) to Score.new - why? why not?
            ##     or use new Score.build( ht:, ft:, ) or such - why? why not?
             ht = node[2][:ht] || [nil,nil]
             ft = node[2][:ft] || [nil,nil]
             et = node[2][:et] || [nil,nil]
             p  = node[2][:p]  || [nil,nil]
             values = [*ht, *ft, *et, *p]
             pp values

             score = Score.new( *values )
             pp score
        elsif node_type == :vs
           ## skip; do nothing
##
## todo - add    ## find (optional) match status e.g. [abandoned] or [replay] or [awarded]
##                                   or [cancelled] or [postponed] etc.
##    status = find_status!( line )   ## todo/check: allow match status also in geo part (e.g. after @) - why? why not?

        elsif node_type == :'@' ||
              node_type == :geo
            more << node[1]  if node_type == :geo
        else
            puts "!! PARSE ERROR - unexpected node type #{node_type} in match line; got:"
            pp node
            exit 1
        end
    end


    if teams.size != 2
      puts "!! PARSE ERROR - expected two teams; got #{teams.size}:"
      pp teams
      exit 1
    end

    team1 = teams[0]
    team2 = teams[1]

    @teams[ team1 ] += 1
    @teams[ team2 ] += 1


    ###
    # check if date found?
    #   note: ruby falsey is nil & false only (not 0 or empty array etc.)
    if date
      ### check: use date_v2 if present? why? why not?
      @last_date = date    # keep a reference for later use
      @last_time = nil
      # @last_time = nil
    else
      date = @last_date    # no date found; (re)use last seen date
    end

    if time
      @last_time = time
    else
      time = @last_time
    end


    round = nil
    if @last_round
      round = @last_round
    else
      ## find (first) matching round by date if rounds / matchdays defined
      ##   if not rounds / matchdays defined - YES, allow matches WITHOUT rounds!!!
      if @rounds.size > 0
        @rounds.values.each do |round_rec|
          ## note: convert date to date only (no time) with to_date!!!
          if (round_rec.start_date && round_rec.end_date) &&
             (date.to_date >= round_rec.start_date &&
             date.to_date <= round_rec.end_date)
            round = round_rec
            break
          end
        end
        if round.nil?
          puts "!! PARSE ERROR - no matching round found for match date:"
          pp date
          exit 1
        end
      end
    end

    ## todo/check: scores are integers or strings?

    ## todo/check: pass along round and group refs or just string (canonical names) - why? why not?

    ## split date in date & time if DateTime
=begin
    time_str = nil
    date_str = nil
    if date.is_a?( DateTime )
        date_str = date.strftime('%Y-%m-%d')
        time_str = date.strftime('%H:%M')
    elsif date.is_a?( Date )
        date_str = date.strftime('%Y-%m-%d')
    else  # assume date is nil
    end
=end

    time_str = nil
    date_str = nil

    date_str = date.strftime('%Y-%m-%d')  if date
    time_str = time    if date && time


    status = nil
    ground = nil

    @matches << Import::Match.new( num:     num,
                                   date:    date_str,
                                   time:    time_str,
                                   team1:   team1,  ## note: for now always use mapping value e.g. rec (NOT string e.g. team1.name)
                                   team2:   team2,  ## note: for now always use mapping value e.g. rec (NOT string e.g. team2.name)
                                   score:   score,
                                   round:   round       ? round.name       : nil,   ## note: for now always use string (assume unique canonical name for event)
                                   group:   @last_group ? @last_group.name : nil,   ## note: for now always use string (assume unique canonical name for event)
                                   status:  status,
                                   ground:  ground )
    ### todo: cache team lookups in hash?

    ## hacky goals support
    ### reset/toggle 1/2
    @last_goals = 1
  end
end # class MatchParserV2
end # module SportDb



__END__


    ##  split by or || or |||
    ##           or ++ or +++
    ##           or -- or ---
    ##           or // or ///
    ##  note: allow Final | First Leg  as ONE name same as
    ##              Final - First Leg or
    ##              Final, First Leg
    ##   for cut-off always MUST be more than two chars
    ##
    ##  todo/check: find a better name than HEADER_SEP(ARATOR) - why? why not?
    ##   todo/fix: move to parser utils and add a method split_name or such?
    HEADER_SEP_RE = /  [ ]*      ## allow (strip) leading spaces
                      (?:\|{2,} |
                          \+{2,} |
                           -{2,} |
                          \/{2,}
                      )
                      [ ]*       ## allow (strip) trailing spaces
                  /x

  def find_round_header_name!( line )
    # assume everything left is the round name
    #  extract all other items first (round name2, round pos, group name n pos, etc.)

    buf = line.dup
    logger.debug "  find_round_header_name! line-before: >>#{buf}<<"


    parts = buf.split( HEADER_SEP_RE )
    buf = parts[0]

    buf.strip!    # remove leading and trailing whitespace

    logger.debug "  find_round_name! line-after: >>#{buf}<<"

    ### bingo - assume what's left is the round name

    logger.debug "   name: >>#{buf}<<"
    line.sub!( buf, '[ROUND.NAME]' )

    buf
  end

    ## quick hack- collect all "fillwords" by language!!!!
    ##    change later  and add to sportdb-langs!!!!
    ##
    ##    strip all "fillwords" e.g.:
    ##      Nachtrag/Postponed/Addition/Supplemento names
    ##
    ##  todo/change: find a better name for ROUND_EXTRA_WORDS - why? why not?
    ROUND_EXTRA_WORDS_RE = /\b(?:
                               Nachtrag |     ## de
                               Postponed |    ## en
                               Addition  |    ## en
                               Supplemento    ## es
                              )
                             \b/ix

  def parse_round_header( line )
    logger.debug "parsing round header line: >#{line}<"

    name = find_round_header_name!( line )

    logger.debug "  line: >#{line}<"

    name = name.sub( ROUND_EXTRA_WORDS_RE, '' )
    name = name.strip

    round = @rounds[ name ]
    if round.nil?    ## auto-add / create if missing
      ## todo/check: add num (was pos) if present - why? why not?
      round = Import::Round.new( name: name )
      @rounds[ name ] = round
    end

    ## todo/check: if pos match (MUST always match for now)
    @last_round = round
    @last_group = nil   # note: reset group to no group - why? why not?
  end


  def find_score!( line )
    # note: always call after find_dates !!!
    #  scores match date-like patterns!!  e.g. 10-11  or 10:00 etc.
    #   -- note: score might have two digits too

    ScoreFormats.find!( line )
  end

  def find_status!( line )
    StatusParser.find!( line )
  end


  ### todo/check - include (optional) leading space in regex - why? why not?
  NUM_RE = /^[ ]*\(
                    (?<num>[0-9]{1,3})
                  \)
           /x

  def find_num!( line )
      ## check for leading match number e.g.
      ##    (1) Fri Jun/14 21:00         Germany   5-1 (3-0)  Scotland
      m = line.match( NUM_RE )
      if m
        num = m[:num].to_i(10)  ## allows 01/02/07 etc. -- why? why not?
        match_str = m[0]
        line.sub!( match_str, '[NUM]' )
        num
      else
        nil
      end
  end


  def try_parse_game( line )
    # note: clone line; for possible test do NOT modify in place for now
    # note: returns true if parsed, false if no match
    parse_game( line.dup )
  end


  def parse_game( line )
    logger.debug "parsing game (fixture) line: >#{line}<"

    ## split by geo (@)
    ##   split into parts e.g. break using @ !!!
    values = line.split( '@' )

    ## for now pass along ground, city (timezone) as string as is
    ##         parse (map) later - why? why not??
    ### check for ground/stadium and cities
    ground =  if values.size == 1
                 nil ## no stadium
              elsif values.size == 2   # bingo!!!
                 ## process stadium, city (timezone) etc.
                 ## for now keep it simple - pass along "unparsed" all-in-one
                 values[1].gsub( /[ \t]+/, ' ').strip   ## squish
              else
                 puts "!! ERROR - too many @-markers found in line:"
                 puts line
                 exit 1
              end


    line   = values[0]

    @mapper_teams.map_teams!( line )   ### todo/fix: limit mapping to two(2) teams - why? why not?  might avoid matching @ Barcelona ??
    teams = @mapper_teams.find_teams!( line )
    team1 = teams[0]
    team2 = teams[1]

    ## note: if we do NOT find two teams; return false - no match found
    if team1.nil? || team2.nil?
      logger.debug "  no game match (two teams required) found for line: >#{line}<"
      return false
    end


    ## try optional match number e.g.
    ##        (1) Fri Jun/14 21:00         Germany   5-1 (3-0)  Scotland
    num = find_num!( line )
    ## pos = find_game_pos!( line )

    ## find (optional) match status e.g. [abandoned] or [replay] or [awarded]
    ##                                   or [cancelled] or [postponed] etc.
    status = find_status!( line )   ## todo/check: allow match status also in geo part (e.g. after @) - why? why not?


      date      = find_date!( line, start: @start )  ## date or datetime (but NOT time!)

    ## todo/fix:
    ##   add support for find_time!   e.g. 21.00 (or 21:00 ?)



    ###
    # check if date found?
    #   note: ruby falsey is nil & false only (not 0 or empty array etc.)
    if date
      ### check: use date_v2 if present? why? why not?
      @last_date = date    # keep a reference for later use
    else
      date = @last_date    # no date found; (re)use last seen date
    end


    score = find_score!( line )

    logger.debug "  line: >#{line}<"


    round = nil
    if @last_round
      round = @last_round
    else
      ## find (first) matching round by date if rounds / matchdays defined
      ##   if not rounds / matchdays defined - YES, allow matches WITHOUT rounds!!!
      if @rounds.size > 0
        @rounds.values.each do |round_rec|
          ## note: convert date to date only (no time) with to_date!!!
          if (round_rec.start_date && round_rec.end_date) &&
             (date.to_date >= round_rec.start_date &&
             date.to_date <= round_rec.end_date)
            round = round_rec
            break
          end
        end
        if round.nil?
          puts "!! ERROR - no matching round found for match date:"
          pp date
          exit 1
        end
      end
    end


    ## todo/check: scores are integers or strings?

    ## todo/check: pass along round and group refs or just string (canonical names) - why? why not?


    ## split date in date & time if DateTime
    time_str = nil
    date_str = nil
    if date.is_a?( DateTime )
        date_str = date.strftime('%Y-%m-%d')
        time_str = date.strftime('%H:%M')
    elsif date.is_a?( Date )
        date_str = date.strftime('%Y-%m-%d')
    else  # assume date is nil
    end

    @matches << Import::Match.new( num:     num,
                                   date:    date_str,
                                   time:    time_str,
                                   team1:   team1,  ## note: for now always use mapping value e.g. rec (NOT string e.g. team1.name)
                                   team2:   team2,  ## note: for now always use mapping value e.g. rec (NOT string e.g. team2.name)
                                   score:   score,
                                   round:   round       ? round.name       : nil,   ## note: for now always use string (assume unique canonical name for event)
                                   group:   @last_group ? @last_group.name : nil,   ## note: for now always use string (assume unique canonical name for event)
                                   status:  status,
                                   ground:  ground )
    ### todo: cache team lookups in hash?

=begin
    team1 = Team.find_by_key!( team1_key )
    team2 = Team.find_by_key!( team2_key )

    @last_team1 = team1    # store for later use for goals etc.
    @last_team2 = team2


    if @round.nil?
      ## no round header found; calculate round from date

      ###
      ## todo/fix: add some unit tests for round look up
      #  fix: use date_v2 if present!! (old/original date; otherwise use date)

      #
      # fix: check - what to do with hours e.g. start_at use 00:00 and for end_at use 23.59 ??
      #  -- for now - remove hours (e.g. use end_of_day and beginnig_of_day)

      ##
      # note: start_at and end_at are dates ONLY (note datetime)
      #  - do NOT pass in hours etc. in query
      #  again use -->  date.end_of_day, date.beginning_of_day
      #  new: not working:  date.to_date, date.to_date
      #    will not find round if  start_at same as date !! (in theory hours do not matter)

      ###
      # hack:
      #  special case for sqlite3 (date compare not working reliable; use casts)
      #  fix: move to  adapter_name to activerecord_utils as sqlite? or similar?

      if ActiveRecord::Base.connection.adapter_name.downcase.starts_with?( 'sqlite' )
        logger.debug( "  [sqlite] using sqlite-specific query for date compare for rounds finder" )
        round = Round.where( 'event_id = ? AND (    julianday(start_at) <= julianday(?)'+
                                               'AND julianday(end_at)   >= julianday(?))',
                               @event.id, date.to_date, date.to_date).first
      else  # all other dbs (postgresql, mysql, etc.)
        round = Round.where( 'event_id = ? AND (start_at <= ? AND end_at >= ?)',
                             @event.id, date.to_date, date.to_date).first
      end

      pp round
      if round.nil?
        logger.warn( "  !!!! no round match found for date #{date}" )
        pp Round.all

        ###################################
        # -- try auto-adding matchday
        round = Round.new

        round_attribs = {
          event_id: @event.id,
          name: "Matchday #{date.to_date}",
          pos: 999001+@patch_round_ids_pos.length,   # e.g. 999<count> - 999001,999002,etc.
          start_at:  date.to_date,
          end_at:    date.to_date
        }

        logger.info( "  auto-add round >Matchday #{date.to_date}<" )
        logger.debug round_attribs.to_json

        round.update_attributes!( round_attribs )

        @patch_round_ids_pos << round.id   # todo/check - add just id or "full" record as now - why? why not?
      end

      # store pos for auto-number next round if missing
      #  - note: only if greater/bigger than last; use max
      #  - note: last_round_pos might be nil - thus set to 0
      if round.pos > 999000
        # note: do NOT update last_round_pos for to-be-patched rounds
      else
        @last_round_pos = [round.pos,@last_round_pos||0].max
      end

      ## note: will crash (round.pos) if round is nil
      logger.debug( "  using round #{round.pos} >#{round.name}< start_at: #{round.start_at}, end_at: #{round.end_at}" )
    else
      ## use round from last round header
      round = @round
    end


    ### check if games exists
    ##  with this teams in this round if yes only update
    game = Game.find_by_round_id_and_team1_id_and_team2_id(
                         round.id, team1.id, team2.id
    )

    game_attribs = {
      score1i:   scores[0],
      score2i:   scores[1],
      score1:    scores[2],
      score2:    scores[3],
      score1et:  scores[4],
      score2et:  scores[5],
      score1p:   scores[6],
      score2p:   scores[7],
      play_at:    date,
      play_at_v2: date_v2,
      postponed: postponed,
      knockout:  round.knockout,   ## note: for now always use knockout flag from round - why? why not??
      ground_id: ground.present? ? ground.id : nil,
      group_id:  @group.present? ? @group.id : nil
    }

    game_attribs[ :pos ] = pos   if pos.present?

    ####
    # note: only update if any changes (or create if new record)
    if game.present? &&
       game.check_for_changes( game_attribs ) == false
          logger.debug "  skip update game #{game.id}; no changes found"
    else
      if game.present?
        logger.debug "update game #{game.id}:"
      else
        logger.debug "create game:"
        game = Game.new

        more_game_attribs = {
          round_id: round.id,
          team1_id: team1.id,
          team2_id: team2.id
        }

        ## NB: use round.games.count for pos
        ##  lets us add games out of order if later needed
        more_game_attribs[ :pos ] = round.games.count+1   if pos.nil?

        game_attribs = game_attribs.merge( more_game_attribs )
      end

      logger.debug game_attribs.to_json
      game.update_attributes!( game_attribs )
    end

    @last_game = game   # store for later reference (e.g. used for goals etc.)
=end

    return true   # game match found
  end # method parse_game



  def try_parse_date_header( line )
    # note: clone line; for possible test do NOT modify in place for now
    # note: returns true if parsed, false if no match
    parse_date_header( line.dup )
  end

  def find_date!( line, start: )
    ## NB: lets us pass in start_at/end_at date (for event)
    #   for auto-complete year

    # extract date from line
    # and return it
    # NB: side effect - removes date from line string
    DateFormats.find!( line, start: start )
  end


  def parse_date_header( line )
    # note: returns true if parsed, false if no match

    # line with NO teams  plus include date e.g.
    #   [Fri Jun/17]  or
    #   Jun/17  or
    #   Jun/17:   etc.

    @mapper_teams.map_teams!( line )
    teams = @mapper_teams.find_teams!( line )
    team1 = teams[0]
    team2 = teams[1]

    date = find_date!( line, start: @start )

    if date && team1.nil? && team2.nil?
      logger.debug( "date header line found: >#{line}<")
      logger.debug( "    date: #{date} with start: #{@start}")

      @last_date = date   # keep a reference for later use

      ###  quick "corona" hack - support seasons going beyond 12 month (see swiss league 2019/20 and others!!)
      ##    find a better way??
      ##  set @start date to full year (e.g. 1.1.) if date.year  is @start.year+1
      ##   todo/fix: add to linter to check for chronological dates!! - warn if NOT chronological
      ###  todo/check: just turn on for 2019/20 season or always? why? why not?

      ## todo/fix: add switch back to old @start_org
      ##   if year is date.year == @start.year-1    -- possible when full date with year set!!!
      if @start.month != 1
         if date.year == @start.year+1
           logger.debug( "!! hack - extending start date to full (next/end) year; assumes all dates are chronologigal - always moving forward" )
           @start_org = @start   ## keep a copy of the original (old) start date - why? why not? - not used for now
           @start = Date.new( @start.year+1, 1, 1 )
         end
      end

      true
    else
      false
    end
  end



