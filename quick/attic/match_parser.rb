

class MatchParser    ## simple match parser for team match schedules


  def parse
    ## note: every (new) read call - resets errors list to empty
    @errors = []

    @last_date    = nil
    @last_time    = nil
    @last_round   = nil
    @last_group   = nil

    ## last_goals - rename to (longer) @last_team_goals or such - why? why not?
    @last_goals   = 1    ## toggle between 1|2  - hacky (quick & dirty) support for multi-line goals, fix soon!

    @teams   = Hash.new(0)   ## track counts (only) for now for (interal) team stats - why? why not?
    @rounds  = {}
    @groups  = {}
    @matches = []

    @warns        = []    ## track list of warnings (unmatched lines)  too - why? why not?



    @parser = Parser.new
    @tree   = []

    @lines.each_with_index do |line,i|

         if debug?
           puts
           puts "line >#{line}<"
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

       elsif node_type == :player  ||
             node_type == :none  # e.g  [[:none], [:";"], [:player, "Xhaka"],...]
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
             elsif node_type == :leg
                 node = nodes.shift   ## eat-up
                 ## ignore (round) leg for now - add later leg - 1|2|3 etc!!!
                 ##   needs to get added to db/schema too!!!!
                 ##    add @last_leg = nil  or 1|2|3 etc.
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


## quick debug hack
   if m == 2 && d == 29
      puts "quick check  feb/29 dates"
      pp [d,m,y]
      pp start
   end

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

      ## Kane 39', 62', 67'
      ## consume/eat-up (optional?) commas
      if node_type == :','
        nodes.shift
        node_type = nodes[0][0]
      end

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
        elsif node_type == :none
            nodes.shift  # eat-up
        else
          puts "!! PARSE ERROR - unexpected node type in goals;; got #{node_type}:"
          pp nodes
          exit 1
        end
    end

    pp [goals1,goals2]     if debug?

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
      goal = Import::Goal.new(
                  player: rec[:name],
                  team:   1,
                  minute:  rec[:minute],
                  offset:  rec[:offset],
                  penalty: rec[:pen] || false, #  note: pass along/use false NOT nil
                  owngoal: rec[:og] || false
                )
      goals << goal
    end
    goals2.each do |rec|
      goal = Import::Goal.new(
                  player: rec[:name],
                  team:   2,
                  minute:  rec[:minute],
                  offset:  rec[:offset],
                  penalty: rec[:pen] || false, #  note: pass along/use false NOT nil
                  owngoal: rec[:og] || false
                )
      goals << goal
    end

    pp goals   if debug?

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
    num    = nil
    date   = nil
    time   = nil
    teams  = []
    score  = nil
    more   = []
    status = nil

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
             ## pp values

             score = Score.new( *values )
             ## pp score
        elsif node_type == :status  # e.g. awarded, canceled, postponed, etc.
             status = node[1]
        elsif node_type == :vs
           ## skip; do nothing
##
## todo - add    ## find (optional) match status e.g. [abandoned] or [replay] or [awarded]
##                                   or [cancelled] or [postponed] etc.
##    status = find_status!( line )   ## todo/check: allow match status also in geo part (e.g. after @) - why? why not?

        elsif node_type == :'@' ||
              node_type == :',' ||
              node_type == :geo ||
              node_type == :timezone
         ## e.g.
         ## [:"@"], [:geo, "Stade de France"], [:","], [:geo, "Saint-Denis"]]
         ## [:"@"], [:geo, "Arena de São Paulo"], [:","], [:geo, "São Paulo"], [:timezone, "(UTC-3)"]
            more << node[1]  if node_type == :geo
        else
            puts "!! PARSE ERROR - unexpected node type #{node_type} in match line; got:"
            pp node
            ## exit 1
            @errors << ["PARSE ERROR - unexpected node type #{node_type} in match line; got: #{node.inspect}"]
            return
        end
    end


    if teams.size != 2
      puts "!! PARSE ERROR - expected two teams; got #{teams.size}:"
      pp teams
      ## exit 1
      @errors << ["PARSE ERROR - expected two teams; got #{teams.size}: #{teams.inspect}"]
      return
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
end # class MatchParser
end # module SportDb

