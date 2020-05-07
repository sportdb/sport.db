# encoding: utf-8

module SportDb

class MatchParserSimpleV2   ## simple match parser for team match schedules

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

    title, pos = find_group_title_and_pos!( line )

    logger.debug "    title: >#{title}<"
    logger.debug "    pos: >#{pos}<"
    logger.debug "  line: >#{line}<"

    group = @groups[ title ]
    if group.nil?
      puts "!! ERROR - no group def found for >#{title}<"
      exit 1
    end

    # set group for games
    @last_group = group
  end

  def parse_group_def( line )
    logger.debug "parsing group def line: >#{line}<"

    @mapper_teams.map_teams!( line )
    teams = @mapper_teams.find_teams!( line )

    title, pos = find_group_title_and_pos!( line )

    logger.debug "  line: >#{line}<"

    group = Import::Group.new( pos: pos,
                               title: title,
                               teams: teams.map {|team| team.title } )

    @groups[ title ] = group
  end


  def find_group_title_and_pos!( line )
    ## group pos - for now support single digit e.g 1,2,3 or letter e.g. A,B,C or HEX
    ## nb:  (?:)  = is for non-capturing group(ing)

    ## fix:
    ##   get Group|Gruppe|Grupo from lang!!!! do NOT hardcode in place

    ## todo:
    ##   check if Group A:  or [Group A]  works e.g. : or ] get matched by \b ???
    regex = /(?:Group|Gruppe|Grupo)\s+((?:\d{1}|[A-Z]{1,3}))\b/

    m = regex.match( line )

    return [nil,nil] if m.nil?

    pos = case m[1]
          when 'A' then 1
          when 'B' then 2
          when 'C' then 3
          when 'D' then 4
          when 'E' then 5
          when 'F' then 6
          when 'G' then 7
          when 'H' then 8
          when 'I' then 9
          when 'J' then 10
          when 'K' then 11
          when 'L' then 12
          when 'HEX' then 666    # HEX for Hexagonal - todo/check: map to something else ??
          else  m[1].to_i
          end

    title = m[0]

    logger.debug "   title: >#{title}<"
    logger.debug "   pos: >#{pos}<"

    line.sub!( regex, '[GROUP.TITLE+POS]' )

    [title,pos]
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


    pos   = find_round_pos!( line )
    title = find_round_def_title!( line )
    # NB: use extracted round title for knockout check
    knockout_flag = is_knockout_round?( title )


    logger.debug "    start_date: #{start_date}"
    logger.debug "    end_date:   #{end_date}"
    logger.debug "    pos:      #{pos}"
    logger.debug "    title:    >#{title}<"
    logger.debug "    knockout_flag:   #{knockout_flag}"

    logger.debug "  line: >#{line}<"

    #######################################
    # todo/fix: add auto flag is false !!!! - why? why not?
    round = Import::Round.new( pos:        pos,
                               title:      title,
                               start_date: start_date,
                               end_date:   end_date,
                               knockout:   knockout_flag,
                               auto:       false )

    @rounds[ title ] = round
  end



  def find_round_pos!( line )
    # pass #1) extract optional round pos from line
    # e.g.  (1)   - must start line
    regex_pos = /^[ \t]*\((\d{1,3})\)[ \t]+/

    # pass #2) find free standing number  e.g. Matchday 3 or Round 5 or 3. Spieltag etc.
    # note: /\b(\d{1,3})\b/
    #   will match -12
    #  thus, use space required - will NOT match  -2 e.g. Group-2 Play-off
    #  note:  allow  1. Runde  n
    #                1^ Giornata
    regex_num = /(?:^|\s)(\d{1,3})(?:[.\^\s]|$)/

    if line =~ regex_pos
      logger.debug "   pos: >#{$1}<"

      line.sub!( regex_pos, '[ROUND.POS] ' )  ## NB: add back trailing space that got swallowed w/ regex -> [ \t]+
      return $1.to_i
    elsif line =~ regex_num
      ## assume number in title is pos (e.g. Jornada 3, 3 Runde etc.)
      ## NB: do NOT remove pos from string (will get removed by round title)

      num = $1.to_i  # note: clone capture; keep a copy (another regex follows; will redefine $1)

      #### fix:
      #  use/make keywords required
      #  e.g. Round of 16  -> should NOT match 16!
      #    Spiel um Platz 3  (or 5) etc -> should NOT match 3!
      #  Round 16 - ok
      #  thus, check for required keywords

      ## quick hack for round of 16
      # todo: mask match e.g. Round of xxx ... and try again - might include something
      #  reuse pattern for Group XX Replays for example
      if line =~ /^\s*Round of \d{1,3}\b/
         return nil
      end

      logger.debug "   pos: >#{num}<"
      return num
    else
      ## fix: add logger.warn no round pos found in line
      return nil
    end
  end # method find_round_pos!

  def find_round_def_title!( line )
    # assume everything before pipe (\) is the round title
    #  strip [ROUND.POS],  todo:?? [ROUND.TITLE2]

    # todo/fix: add title2 w/  // or /  why? why not?
    #  -- strip / or / chars

    buf = line.dup
    logger.debug "  find_round_def_title! line-before: >>#{buf}<<"

    ## cut-off everything after (including) pipe (|)
    buf = buf[ 0...buf.index('|') ]

    # e.g. remove [ROUND.POS], [ROUND.TITLE2], [GROUP.TITLE+POS] etc.
    buf.gsub!( /\[[^\]]+\]/, '' )    ## fix: use helper for (re)use e.g. remove_match_placeholder/marker or similar?
    # remove leading and trailing whitespace
    buf.strip!

    logger.debug "  find_round_def_title! line-after: >>#{buf}<<"

    logger.debug "   title: >>#{buf}<<"
    line.sub!( buf, '[ROUND.TITLE]' )

    buf
  end

  def find_round_header_title!( line )
    # assume everything left is the round title
    #  extract all other items first (round title2, round pos, group title n pos, etc.)

    ## todo/fix:
    ##  cleanup method
    ##   use  buf.index( '//' ) to split string (see found_round_def)
    ##     why? simpler why not?
    ##  - do we currently allow groups if title2 present? add example if it works?

    buf = line.dup
    logger.debug "  find_round_header_title! line-before: >>#{buf}<<"

    buf.gsub!( /\[[^\]]+\]/, '' )   # e.g. remove [ROUND.POS], [ROUND.TITLE2], [GROUP.TITLE+POS] etc.
    buf.strip!    # remove leading and trailing whitespace

    logger.debug "  find_round_title! line-after: >>#{buf}<<"

    ### bingo - assume what's left is the round title

    logger.debug "   title: >>#{buf}<<"
    line.sub!( buf, '[ROUND.TITLE]' )

    buf
  end


  def parse_round_header( line )
    logger.debug "parsing round header line: >#{line}<"

    ## todo/check/fix:
    #   make sure  Round of 16  will not return pos 16 -- how? possible?
    #   add unit test too to verify
    pos = find_round_pos!( line )

    title = find_round_header_title!( line )

    logger.debug "  line: >#{line}<"


    round = @rounds[ title ]
    if round.nil?    ## auto-add / create if missing
      round = Import::Round.new( pos:   pos,
                                 title: title )
      @rounds[ title ] = round
    end

    ## todo/check: if pos match (MUST always match for now)
    @last_round = round
    @last_group = nil   # note: reset group to no group - why? why not?


    ## NB: dummy/placeholder start_at, end_at date
    ##  replace/patch after adding all games for round

=begin
    round_attribs = {
      title:  title,
      title2: title2,
      knockout: knockout_flag
    }

    if pos > 999000
      # no pos (e.g. will get autonumbered later) - try match by title for now
      #  e.g. lets us use title 'Group Replays', for example, multiple times
      @round = Round.find_by_event_id_and_title( @event.id, title )
    else
      @round = Round.find_by_event_id_and_pos( @event.id, pos )
    end

    if @round.present?
      logger.debug "update round #{@round.id}:"
    else
      logger.debug "create round:"
      @round = Round.new

      round_attribs = round_attribs.merge( {
        event_id: @event.id,
        pos:   pos,
        start_at: Date.parse('1911-11-11'),
        end_at:   Date.parse('1911-11-11')
      })
    end

    logger.debug round_attribs.to_json

    @round.update_attributes!( round_attribs )

    @patch_round_ids_pos   << @round.id    if pos > 999000
    ### store list of round ids for patching start_at/end_at at the end
    @patch_round_ids_dates << @round.id   # todo/fix/check: check if round has definition (do NOT patch if definition (not auto-added) present)
=end
  end


  def find_scores!( line, opts={} )
    # note: always call after find_dates !!!
    #  scores match date-like patterns!!  e.g. 10-11  or 10:00 etc.
    #   -- note: score might have two digits too

    finder = ScoresFinder.new
    finder.find!( line, opts )
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


    scores = find_scores!( line )

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
                                   team1:   team1,  ## note: for now always use mapping value e.g. rec (NOT string e.g. team1.title)
                                   team2:   team2,  ## note: for now always use mapping value e.g. rec (NOT string e.g. team2.title)
                                   score1i: scores[0],  ## score1i - half time (first (i) part)
                                   score2i: scores[1],  ## score2i
                                   score1:  scores[2],  ## score1  - full time
                                   score2:  scores[3],  ## score2
                                   round:   round       ? round.title       : nil,   ## note: for now always use string (assume unique canonical name for event)
                                   group:   @last_group ? @last_group.title : nil )  ## note: for now always use string (assume unique canonical name for event)

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
          title: "Matchday #{date.to_date}",
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
      logger.debug( "  using round #{round.pos} >#{round.title}< start_at: #{round.start_at}, end_at: #{round.end_at}" )
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
      logger.debug( "    date: #{date}")

      @last_date = date   # keep a reference for later use
      return true
    else
      return false
    end
  end



end # class MatchParserSimpleV2
end # module SportDb
