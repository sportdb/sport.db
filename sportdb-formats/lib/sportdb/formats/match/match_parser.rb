# encoding: utf-8

module SportDb

class MatchParser   ## simple match parser for team match schedules

  def self.parse( lines, teams, start: )
    ##  todo/fix: add support for txt and lines
    ##    check if lines_or_txt is an array or just a string
    ##   use teams: like start:  why? why not?
    parser = new( lines, teams, start )
    parser.parse
  end


  include Logging         ## e.g. logger#debug, logger#info, etc.
  include ParserHelper    ## e.g. read_lines, etc.


  def initialize( lines, teams, start )
    # for convenience split string into lines
    ##    note: removes/strips empty lines
    ## todo/check: change to text instead of array of lines - why? why not?
    @lines        = lines.is_a?( String ) ? read_lines( lines ) : lines

    @mapper_teams = TeamMapper.new( teams )
    @start        = start
  end


  def parse
    @last_date    = nil
    @last_round   = nil
    @last_group   = nil

    @rounds  = {}
    @groups  = {}
    @matches = []

    @warns        = []    ## track list of warnings (unmatched lines)  too - why? why not?


    @lines.each do |line|
      if is_goals?( line )
        logger.debug "skipping matched goals line: >#{line}<"
      elsif is_round_def?( line )
        ## todo/fix:  add round definition (w begin n end date)
        ## todo: do not patch rounds with definition (already assume begin/end date is good)
        ##  -- how to deal with matches that get rescheduled/postponed?
        parse_round_def( line )
      elsif is_round?( line )
        parse_round_header( line )
      elsif is_group_def?( line ) ## NB: group goes after round (round may contain group marker too)
        ### todo: add pipe (|) marker (required)
        parse_group_def( line )
      elsif is_group?( line )
        ##  -- lets you set group  e.g. Group A etc.
        parse_group_header( line )
      elsif try_parse_game( line )
        # do nothing here
      elsif try_parse_date_header( line )
        # do nothing here
      else
        logger.warn "skipping line (no match found): >#{line}<"
        @warns << line
      end
    end # lines.each

    [@matches, @rounds.values, @groups.values]
  end # method parse



  def parse_group_header( line )
    logger.debug "parsing group header line: >#{line}<"

    # note: group header resets (last) round  (allows, for example):
    #  e.g.
    #  Group Playoffs/Replays       -- round header
    #    team1 team2                -- match
    #  Group B:                     -- group header
    #    team1 team2 - match  (will get new auto-matchday! not last round)
    @last_round     = nil

    name = find_group_name!( line )

    logger.debug "    name: >#{name}<"
    logger.debug "  line: >#{line}<"

    group = @groups[ name ]
    if group.nil?
      puts "!! ERROR - no group def found for >#{name}<"
      exit 1
    end

    # set group for games
    @last_group = group
  end

  def parse_group_def( line )
    logger.debug "parsing group def line: >#{line}<"

    @mapper_teams.map_teams!( line )
    teams = @mapper_teams.find_teams!( line )

    name = find_group_name!( line )

    logger.debug "  line: >#{line}<"

    ## todo/check/fix: add back group key - why? why not?
    group = Import::Group.new( name:  name,
                               teams: teams.map {|team| team.name } )

    @groups[ name ] = group
  end


  def find_group_name!( line )
    ## group pos - for now support single digit e.g 1,2,3 or letter e.g. A,B,C or HEX
    ## nb:  (?:)  = is for non-capturing group(ing)

    ## fix:
    ##   get Group|Gruppe|Grupo from lang!!!! do NOT hardcode in place

    ## todo:
    ##   check if Group A:  or [Group A]  works e.g. : or ] get matched by \b ???
    regex = /\b
              (?:
                (Group | Gruppe | Grupo)
                   [ ]+
                (\d+ | [A-Z]+)
              )
            \b/x

    m = regex.match( line )

    return nil    if m.nil?

    name = m[0]

    logger.debug "   name: >#{name}<"

    line.sub!( name, '[GROUP.NAME]' )

    name
  end


  def parse_round_def( line )
    logger.debug "parsing round def line: >#{line}<"

    start_date = find_date!( line, start: @start )
    end_date   = find_date!( line, start: @start )

    # note: if end_date missing -- assume start_date is (==) end_at
    end_date = start_date  if end_date.nil?

    # note: - NOT needed; start_at and end_at are saved as date only (NOT datetime)
    #  set hours,minutes,secs to beginning and end of day (do NOT use default 12.00)
    #   e.g. use 00.00 and 23.59
    # start_at = start_at.beginning_of_day
    # end_at   = end_at.end_of_day

    # note: make sure start_at/end_at is date only (e.g. use start_at.to_date)
    #   sqlite3 saves datetime in date field as datetime, for example (will break date compares later!)
    start_date = start_date.to_date
    end_date   = end_date.to_date


    name  = find_round_def_name!( line )
    # NB: use extracted round name for knockout check
    knockout_flag = is_knockout_round?( name )


    logger.debug "    start_date: #{start_date}"
    logger.debug "    end_date:   #{end_date}"
    logger.debug "    name:    >#{name}<"
    logger.debug "    knockout_flag:   #{knockout_flag}"

    logger.debug "  line: >#{line}<"

    round = Import::Round.new( name:       name,
                               start_date: start_date,
                               end_date:   end_date,
                               knockout:   knockout_flag,
                               auto:       false )

    @rounds[ name ] = round
  end



  def find_round_def_name!( line )
    # assume everything before pipe (\) is the round name
    #  strip [ROUND.POS],  todo:?? [ROUND.NAME2]

    # todo/fix: add name2 w/  // or /  why? why not?
    #  -- strip / or / chars

    buf = line.dup
    logger.debug "  find_round_def_name! line-before: >>#{buf}<<"

    ## cut-off everything after (including) pipe (|)
    buf = buf[ 0...buf.index('|') ]
    buf.strip!

    logger.debug "  find_round_def_name! line-after: >>#{buf}<<"

    logger.debug "   name: >>#{buf}<<"
    line.sub!( buf, '[ROUND.NAME]' )

    buf
  end


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

  def try_parse_game( line )
    # note: clone line; for possible test do NOT modify in place for now
    # note: returns true if parsed, false if no match
    parse_game( line.dup )
  end


  def parse_game( line )
    logger.debug "parsing game (fixture) line: >#{line}<"

    ## split by geo (@) - remove for now
    ##   split into parts e.g. break using @ !!!
    values = line.split( '@' )
    line = values[0]


    @mapper_teams.map_teams!( line )   ### todo/fix: limit mapping to two(2) teams - why? why not?  might avoid matching @ Barcelona ??
    teams = @mapper_teams.find_teams!( line )
    team1 = teams[0]
    team2 = teams[1]

    ## note: if we do NOT find two teams; return false - no match found
    if team1.nil? || team2.nil?
      logger.debug "  no game match (two teams required) found for line: >#{line}<"
      return false
    end

    ## pos = find_game_pos!( line )

      date      = find_date!( line, start: @start )

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
      ## find (first) matching round by date
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


    ## todo/check: scores are integers or strings?

    ## todo/check: pass along round and group refs or just string (canonical names) - why? why not?

    @matches << Import::Match.new( date:    date,
                                   team1:   team1,  ## note: for now always use mapping value e.g. rec (NOT string e.g. team1.name)
                                   team2:   team2,  ## note: for now always use mapping value e.g. rec (NOT string e.g. team2.name)
                                   score:   score,
                                   round:   round       ? round.name       : nil,   ## note: for now always use string (assume unique canonical name for event)
                                   group:   @last_group ? @last_group.name : nil )  ## note: for now always use string (assume unique canonical name for event)

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



end # class MatchParser
end # module SportDb
