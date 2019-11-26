# encoding: utf-8

module SportDb

class MatchParserSimpleV2   ## simple match parser for club match schedules

  def self.parse( lines, teams, start: )
    ##  todo/fix: add support for txt and lines
    ##    check if lines_or_txt is an array or just a string
    ##   use teams: like start:  why? why not?
    parser = new( lines, teams, start )
    parser.parse
  end


  include LogUtils::Logging

  def initialize( lines, teams, start )
     @lines        = lines     ## todo/check: change to text instead of array of lines - why? why not?
     @mapper_teams = TeamMapper.new( teams )
     @start        = start

     ## build lookup hash by (team) key
     @teams =  teams.reduce({}) { |h,team| h[team.key]=team; h }

     ## debug_dump_teams( teams )
     ## exit 1
  end

  def debug_dump_teams( teams )
    puts "== #{teams.size} teams"
    teams.each do |team|
      print "#{team.key}, "
      print "#{team.title}, "
      print "#{team.synonyms.split('|').join(', ')}"
      puts
    end
  end



  Round = Struct.new( :pos, :title )
  ##
  ##  todo:  change db schema
  ##    make start and end date optional
  ##    change pos to num - why? why not?
  ##    make pos/num optional too
  ##
  ##    sort round by scheduled/planed start date
  Match = Struct.new( :date,
                      :team1,     :team2,      ## todo/fix: use team1_name, team2_name or similar - for compat with db activerecord version? why? why not?
                      :score1i,   :score2i,    ## half time (first (i) part)
                      :score1,    :score2,     ## full time
                      :round )

  def parse
    @last_date    = nil
    @last_round   = nil
    @rounds  = {}
    @matches = []


    @lines.each do |line|
      if is_round?( line )
        parse_round_header( line )
      elsif try_parse_game( line )
        # do nothing here
      elsif try_parse_date_header( line )
        # do nothing here
      else
        logger.info "skipping line (no match found): >#{line}<"
      end
    end # lines.each

    [@rounds.values, @matches]
  end # method parse


  def is_round?( line )
    ## note: =~ return nil if not match found, and 0,1, etc for match
    (line =~ SportDb.lang.regex_round) != nil
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
    if round.nil?
      round = Round.new( pos, title )
      @rounds[ title ] = round
    end
    ## todo/check: if pos match (MUST always match for now)
    @last_round = round


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

    @mapper_teams.map_teams!( line )   ### todo/fix: limit mapping to two(2) teams - why? why not?  might avoid matching @ Barcelona ??
    team_keys = @mapper_teams.find_teams!( line )
    team1_key = team_keys[0]
    team2_key = team_keys[1]

    ## note: if we do NOT find two teams; return false - no match found
    if team1_key.nil? || team2_key.nil?
      logger.debug "  no game match (two teams required) found for line: >#{line}<"
      return false
    end

    ## pos = find_game_pos!( line )

      date      = find_date!( line, start: @start )

    ###
    # check if date found?
    #   NB: ruby falsey is nil & false only (not 0 or empty array etc.)
    if date
      ### check: use date_v2 if present? why? why not?
      @last_date = date    # keep a reference for later use
    else
      date = @last_date    # no date found; (re)use last seen date
    end


    scores = find_scores!( line )

    logger.debug "  line: >#{line}<"


    ## todo/check: scores are integers or strings?
    @matches << Match.new( date,
                           @teams[ team1_key ],
                           @teams[ team2_key ],
                           scores[0],  ## score1i - half time (first (i) part)
                           scores[1],  ## score2i
                           scores[2],  ## score1  - full time
                           scores[3],  ## score2
                           @last_round )

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
    team_keys = @mapper_teams.find_teams!( line )
    team1_key = team_keys[0]
    team2_key = team_keys[1]

    date = find_date!( line, start: @start )

    if date && team1_key.nil? && team2_key.nil?
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
