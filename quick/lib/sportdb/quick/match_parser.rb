
module SportDb

class MatchParser    ## simple match parser for team match schedules

  def self.debug=(value) @@debug = value; end
  def self.debug?() @@debug ||= false; end  ## note: default is FALSE
  def debug?()  self.class.debug?; end

  include Logging         ## e.g. logger#debug, logger#info, etc.

  def log( msg )
    ## append msg to ./logs.txt
    ##     use ./errors.txt - why? why not?
    File.open( './logs.txt', 'a:utf-8' ) do |f|
      f.write( msg )
      f.write( "\n" )
    end
  end
 



  
  def self.parse( lines, start: )
    ##  todo/fix: add support for txt and lines
    ##    check if lines_or_txt is an array or just a string
    ##   use teams: like start:  why? why not?
    parser = new( lines, start )
    parser.parse
  end



  def _prep_lines( lines )   ## todo/check:  add alias preproc_lines or build_lines or prep_lines etc. - why? why not?

    ## todo/fix - rework and make simpler
    ##             no need to double join array of string to txt etc.

    txt =  if lines.is_a?( Array )
               ## join together with newline
                lines.reduce( String.new ) do |mem,line|
                                               mem << line; mem << "\n"; mem
                                           end
             else  ## assume single-all-in-one txt
                lines
             end

    ##  preprocess automagically - why? why not?
    ##   strip lines with comments and empty lines striped / removed
    txt_new = String.new
    txt.each_line do |line|    ## preprocess
       line = line.strip
       next if line.empty? || line.start_with?('#')   ###  skip empty lines and comments
       
       line = line.sub( /#.*/, '' ).strip             ###  cut-off end-of line comments too
       
       txt_new << line
       txt_new << "\n"
    end
    txt_new
  end


  #
  # todo/fix: change start to start: too!!!
  #       might be optional in the future!! - why? why not?

  def initialize( lines, start )
    # for convenience split string into lines
    ##    note: removes/strips empty lines
    ## todo/check: change to text instead of array of lines - why? why not?

    ## note - wrap in enumerator/iterator a.k.a lines reader
    ## @lines = lines.is_a?( String ) ?
    ##                _read_lines( lines ) : lines

    @txt          = _prep_lines( lines )    
    @start        = start
    @errors = []
  end


  attr_reader :errors
  def errors?() @errors.size > 0; end

  def parse
    ## note: every (new) read call - resets errors list to empty
    @errors = []

    @last_date    = nil
    @last_time    = nil
    @last_round   = nil
    @last_group   = nil


    @teams   = Hash.new(0)   ## track counts (only) for now for (interal) team stats - why? why not?
    @rounds  = {}
    @groups  = {}
    @matches = []

    @warns        = []    ## track list of warnings (unmatched lines)  too - why? why not?


    @tree   = []


         if debug?
           puts "lines:"
           pp @txt
         end

=begin
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
=end

     parser = RaccMatchParser.new( @txt )   ## use own parser instance (not shared) - why? why not?
     @tree = parser.parse
     ## pp @tree

    ## report parse errors here - why? why not?



    @tree.each do |node|

       if node.is_a? RaccMatchParser::RoundDef
        ## todo/fix:  add round definition (w begin n end date)
        ## todo: do not patch rounds with definition (already assume begin/end date is good)
        ##  -- how to deal with matches that get rescheduled/postponed?
          on_round_def( node )
        elsif node.is_a? RaccMatchParser::GroupDef  ## NB: group goes after round (round may contain group marker too)
        ### todo: add pipe (|) marker (required)
          on_group_def( node )
       elsif node.is_a? RaccMatchParser::GroupHeader
          on_group_header( node )
       elsif node.is_a? RaccMatchParser::RoundHeader
          on_round_header( node )
      elsif node.is_a? RaccMatchParser::DateHeader
          on_date_header( node )
      elsif node.is_a? RaccMatchParser::MatchLine
          on_match_line( node )
      elsif node.is_a? RaccMatchParser::GoalLine
          on_goal_line( node )
      elsif node.is_a? RaccMatchParser::LineupLine
           ## skip lineup for now
      else
        ## report error
        msg = "!! WARN - unknown node (parse tree type) - #{node.class.name}" 
        puts msg
        pp node

        log( msg )
        log( node.pretty_inspect )
      end
    end  # tree.each

    ## note - team keys are names and values are "internal" stats!!
    ##                      and NOT team/club/nat_team structs!!
    [@teams.keys, @matches, @rounds.values, @groups.values]
  end # method parse



  def on_group_header( node )
    logger.debug "on group header: >#{node}<"

    # note: group header resets (last) round  (allows, for example):
    #  e.g.
    #  Group Playoffs/Replays       -- round header
    #    team1 team2                -- match
    #  Group B                      -- group header
    #    team1 team2 - match  (will get new auto-matchday! not last round)
    @last_round     = nil

    name = node.name

    group = @groups[ name ]
    if group.nil?
      puts "!! PARSE ERROR - no group def found for >#{name}<"
      exit 1
    end

    # set group for games
    @last_group = group
  end


  def on_group_def( node )
    logger.debug "on group def: >#{node}<"

   ## e.g
   ##  [:group_def, "Group A"],
   ##   [:team, "Germany"],
   ##   [:team, "Scotland"],
   ##   [:team, "Hungary"],
   ##   [:team, "Switzerland"]

    node.teams.each do |team|
          @teams[ team ] += 1
    end
 
    ## todo/check/fix: add back group key - why? why not?
    group = Import::Group.new( name:  node.name,
                               teams: node.teams )

    @groups[ node.name ] = group
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


  def on_round_def( node )
    logger.debug "on round def: >#{node}<"

    ## e.g. [[:round_def, "Matchday 1"], [:duration, "Fri Jun/14 - Tue Jun/18"]]
    ##      [[:round_def, "Matchday 2"], [:duration, "Wed Jun/19 - Sat Jun/22"]]
    ##      [[:round_def, "Matchday 3"], [:duration, "Sun Jun/23 - Wed Jun/26"]]

    name  = node.name
    # NB: use extracted round name for knockout check
    # knockout_flag = is_knockout_round?( name )

    if node.date
        start_date = end_date = _build_date( m: node.date[:m],
                                             d: node.date[:d],
                                             y: node.date[:y],
                                              start: @start)
    elsif node.duration
      start_date  = _build_date( m: node.duration[:start][:m],
                                 d: node.duration[:start][:d],
                                 y: node.duration[:start][:y],
                                   start: @start)
      end_date    = _build_date( m: node.duration[:end][:m],
                                 d: node.duration[:end][:d],
                                 y: node.duration[:end][:y],
                                   start: @start)
    else
       puts "!! PARSE ERROR - expected date or duration for round def; got:"
       pp node
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


  def on_round_header( node )
    logger.debug "on round header: >#{node}<"

    name = node.names[0]    ## ignore more names for now
                           ## fix later - fix more names!!!

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

  def on_date_header( node )
    logger.debug( "date header: >#{node}<")

    date = _build_date( m: node.date[:m],
                        d: node.date[:d],
                        y: node.date[:y],
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


  def on_goal_line( node )
    logger.debug "on goal line: >#{node}<"

    goals1 = node.goals1
    goals2 = node.goals2

   
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
      rec.minutes.each do |minute|
        goal = Import::Goal.new(
                  player: rec.player,
                  team:   1,
                  minute:  minute.m,
                  offset:  minute.offset,
                  penalty: minute.pen || false, #  note: pass along/use false NOT nil
                  owngoal: minute.og || false
                )
        goals << goal
      end
    end
    goals2.each do |rec|
      rec.minutes.each do |minute|
        goal = Import::Goal.new(
                  player: rec.player,
                  team:   2,
                  minute:  minute.m,
                  offset:  minute.offset,
                  penalty: minute.pen || false, #  note: pass along/use false NOT nil
                  owngoal: minute.og || false
                )
      goals << goal
      end
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


  def on_match_line( node )
    logger.debug( "on match: >#{node}<" )

    ## collect (possible) nodes by type
    num    = nil
    num = node.ord   if node.ord
        
    date   = nil
    date =  _build_date( m: node.date[:m],
                         d: node.date[:d],
                         y: node.date[:y],
                         start: @start )   if node.date

    ## note - there's no time (-only) type in ruby
    ##  use string (e.g. '14:56', '1:44')
    ##   use   01:44 or 1:44 ?
    ##  check for 0:00 or 24:00  possible?  
    time   = nil                       
    time   =  ('%d:%02d' % [node.time[:h], node.time[:m]])  if node.time
 

    ### todo/fix
    ##    add keywords (e.g. ht, ft or such) to Score.new - why? why not?
    ##     or use new Score.build( ht:, ft:, ) or such - why? why not?
    ## pp score              
    score  = nil
    if node.score
      ht = node.score[:ht] || [nil,nil]
      ft = node.score[:ft] || [nil,nil]
      et = node.score[:et] || [nil,nil]
      p  = node.score[:p]  || [nil,nil]
      values = [*ht, *ft, *et, *p]
      ## pp values
      score = Score.new( *values )
    end
 

    status = nil
    status =  node.status   if node.status   ### assume text for now             
    ## if node_type == :status  # e.g. awarded, canceled, postponed, etc.
    ##  status = node[1]
    #
    ## todo - add    ## find (optional) match status e.g. [abandoned] or [replay] or [awarded]
    ##                                   or [cancelled] or [postponed] etc.
    ##    status = find_status!( line )   ## todo/check: allow match status also in geo part (e.g. after @) - why? why not?

    
    ###############
    #  add more for ground (and timezone!!!)
    more   = []
#
#        elsif node_type == :'@' ||
#              node_type == :',' ||
#              node_type == :geo ||
#              node_type == :timezone
         ## e.g.
         ## [:"@"], [:geo, "Stade de France"], [:","], [:geo, "Saint-Denis"]]
         ## [:"@"], [:geo, "Arena de São Paulo"], [:","], [:geo, "São Paulo"], [:timezone, "(UTC-3)"]
#            more << node[1]  if node_type == :geo
  

    team1 = node.team1
    team2 = node.team2

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


    ground   = nil
    timezone = nil
    if node.geo
       ground = node.geo
       ## note: only add/check for timezone if geo (aka ground) is present - why? why not?
       timezone = node.timezone   if node.timezone
    end


    @matches << Import::Match.new( num:      num,
                                   date:     date_str,
                                   time:     time_str,
                                   team1:    team1,  ## note: for now always use mapping value e.g. rec (NOT string e.g. team1.name)
                                   team2:    team2,  ## note: for now always use mapping value e.g. rec (NOT string e.g. team2.name)
                                   score:    score,
                                   round:    round       ? round.name       : nil,   ## note: for now always use string (assume unique canonical name for event)
                                   group:    @last_group ? @last_group.name : nil,   ## note: for now always use string (assume unique canonical name for event)
                                   status:   status,
                                   ground:   ground,
                                   timezone: timezone )
    ### todo: cache team lookups in hash?
  end
end # class MatchParser
end # module SportDb

