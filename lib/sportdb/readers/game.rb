# encoding: UTF-8

module SportDb


class GameReader

  include LogUtils::Logging

## make models available by default with namespace
#  e.g. lets you use Usage instead of Model::Usage
  include Models

## value helpers e.g. is_year?, is_taglist? etc.
  include TextUtils::ValueHelper

  include FixtureHelpers


  attr_reader :include_path


  def initialize( include_path, opts = {} )
    @include_path = include_path
  end


  def read( name, more_attribs={} )
    reader = EventReader.new( @include_path )
    reader.read( name )

    event    = reader.event      ## was fetch_event( name )
    fixtures = reader.fixtures   ## was fetch_event_fixtures( name )

    ## reset cached values
    ##  for auto-number rounds etc.

    @last_round_pos = nil

    fixtures.each do |fixture|
      read_fixtures( event.key, fixture )  ## use read_for or read_for_event - why ??? why not?? 
    end
  end


  def read_fixtures_from_string( event_key, text )  # load from string (e.g. passed in via web form)

    SportDb.lang.lang = SportDb.lang.classify( text )

    ## todo/fix: move code into LineReader e.g. use LineReader.fromString() - why? why not?
    reader = StringLineReader.new( text )
    
    read_fixtures_worker( event_key, reader )

    ## fix add prop 
    ### Prop.create!( key: "db.#{fixture_name_to_prop_key(name)}.version", value: "file.txt.#{File.mtime(path).strftime('%Y.%m.%d')}" )  
  end


  def read_fixtures( event_key, name )  # load from file system

    ## todo: move name_real_path code to LineReaderV2 ????
    pos = name.index( '!/')
    if pos.nil?
      name_real_path = name   # not found; real path is the same as name
    else
      # cut off everything until !/ e.g.
      #   at-austria!/w-wien/beers becomes
      #   w-wien/beers
      name_real_path = name[ (pos+2)..-1 ]
    end


    path = "#{include_path}/#{name_real_path}.txt"

    logger.info "parsing data '#{name}' (#{path})..."
    
    SportDb.lang.lang = SportDb.lang.classify_file( path )

    reader = LineReader.new( path )
    
    load_fixtures_worker( event_key, reader )

    Prop.create_from_fixture!( name, path )
  end


  def load_fixtures_worker( event_key, reader )
    ## NB: assume active activerecord connection

    ## reset cached values
    @patch_rounds  = {}
    @round         = nil     ## fix: change/rename to @last_round !!!
    @group         = nil     ## fix: change/rename to @last_group !!!
    @last_date     = nil


    #####
    #  fix: move to read and share event/known_teams
    #    for all 1-n fixture files (no need to configure every time!!)

    @event = Event.find_by_key!( event_key )
    
    logger.debug "Event #{@event.key} >#{@event.title}<"

    ### fix: use build_title_table_for ??? why? why not??
    @known_teams  = @event.known_teams_table

    @known_grounds  = TextUtils.build_title_table_for( @event.grounds )


    parse_fixtures( reader )
    
  end   # method load_fixtures



  def parse_group_header( line )
    logger.debug "parsing group header line: >#{line}<"

    title, pos = find_group_title_and_pos!( line )

    logger.debug "    title: >#{title}<"
    logger.debug "    pos: >#{pos}<"
    logger.debug "  line: >#{line}<"

    # set group for games
    @group = Group.find_by_event_id_and_pos!( @event.id, pos )
  end


  def parse_group_def( line )
    logger.debug "parsing group def line: >#{line}<"
    
    match_teams!( line )
    team_keys = find_teams!( line )
      
    title, pos = find_group_title_and_pos!( line )

    logger.debug "  line: >#{line}<"

    group_attribs = {
      title: title
    }
        
    group = Group.find_by_event_id_and_pos( @event.id, pos )
    if group.present?
      logger.debug "update group #{group.id}:"
    else
      logger.debug "create group:"
      group = Group.new
      group_attribs = group_attribs.merge( {
        event_id: @event.id,
        pos:   pos
      })
    end
      
    logger.debug group_attribs.to_json
   
    group.update_attributes!( group_attribs )

    group.teams.clear  # remove old teams
    ## add new teams
    team_keys.each do |team_key|
      team = Team.find_by_key!( team_key )
      logger.debug "  adding team #{team.title} (#{team.code})"
      group.teams << team
    end
  end


  def parse_round_def( line )
    logger.debug "parsing round def line: >#{line}<"

    ### todo/fix/check:  move cut off optional comment in reader for all lines? why? why not?
    cut_off_end_of_line_comment!( line )  # cut off optional comment starting w/ #

    start_at = find_date!( line, start_at: @event.start_at )
    end_at   = find_date!( line, start_at: @event.start_at )
    
    # note: if end_at missing -- assume start_at is (==) end_at
    end_at = start_at  if end_at.nil?

    # note: - NOT needed; start_at and end_at are saved as date only (NOT datetime)
    #  set hours,minutes,secs to beginning and end of day (do NOT use default 12.00)
    #   e.g. use 00.00 and 23.59
    # start_at = start_at.beginning_of_day
    # end_at   = end_at.end_of_day

    # note: make sure start_at/end_at is date only (e.g. use start_at.to_date)
    #   sqlite3 saves datetime in date field as datetime, for example (will break date compares later!)
    start_at = start_at.to_date
    end_at   = end_at.to_date


    pos   = find_round_pos!( line )
    title = find_round_def_title!( line )
    # NB: use extracted round title for knockout check
    knockout_flag = is_knockout_round?( title )


    logger.debug "    start_at: #{start_at}"
    logger.debug "    end_at:   #{end_at}"
    logger.debug "    pos:      #{pos}"
    logger.debug "    title:    >#{title}<"
    logger.debug "    knockout_flag:   #{knockout_flag}"

    logger.debug "  line: >#{line}<"

    #######################################
    # fix: add auto flag is false !!!!

    round_attribs = {
      title:    title,
      knockout: knockout_flag,
      start_at: start_at,
      end_at:   end_at
    }

    round = Round.find_by_event_id_and_pos( @event.id, pos )
    if round.present?
      logger.debug "update round #{round.id}:"
    else
      logger.debug "create round:"
      round = Round.new
          
      round_attribs = round_attribs.merge( {
        event_id: @event.id,
        pos:   pos
      })
    end

    logger.debug round_attribs.to_json
   
    round.update_attributes!( round_attribs )
  end


  def parse_round_header( line )
    logger.debug "parsing round header line: >#{line}<"

    ### todo/fix/check:  move cut off optional comment in reader for all lines? why? why not?
    cut_off_end_of_line_comment!( line )  # cut off optional comment starting w/ #

    # NB: cut off optional title2 starting w/  //  first
    title2 = find_round_header_title2!( line )

    # todo/fix: check if it is possible title2 w/ group?
    #  add an example here
    group_title, group_pos = find_group_title_and_pos!( line )

    ## todo/check/fix:
    #   make sure  Round of 16  will not return pos 16 -- how? possible?
    #   add unit test too to verify
    pos = find_round_pos!( line )

    ## check if pos available; if not auto-number/calculate
    if pos.nil?
      pos = (@last_round_pos||0)+1
      logger.debug( "  no round pos found; auto-number round - use (#{pos})" )
    end

    # store pos for auto-number next round if missing
    #  - note: only if greater/bigger than last; use max
    #  - note: last_round_pos might be nil - thus set to 0
    @last_round_pos = [pos,@last_round_pos||0].max


    title = find_round_header_title!( line )

    ## NB: use extracted round title for knockout check
    knockout_flag = is_knockout_round?( title )


    if group_pos.present?
      @group = Group.find_by_event_id_and_pos!( @event.id, group_pos )
    else
      @group = nil   # reset group to no group
    end

    logger.debug "  line: >#{line}<"
        
    ## NB: dummy/placeholder start_at, end_at date
    ##  replace/patch after adding all games for round

    round_attribs = {
      title:  title,
      title2: title2,
      knockout: knockout_flag
    }


    @round = Round.find_by_event_id_and_pos( @event.id, pos )
    if @round.present?
      logger.debug "update round #{@round.id}:"
    else
      logger.debug "create round:"
      @round = Round.new
          
      round_attribs = round_attribs.merge( {
        event_id: @event.id,
        pos:   pos,
        start_at: Time.utc('1912-12-12'),
        end_at:   Time.utc('1912-12-12')
      })
    end

    logger.debug round_attribs.to_json
   
    @round.update_attributes!( round_attribs )

    ### store list of round is for patching start_at/end_at at the end
    @patch_rounds[ @round.id ] = @round.id
  end


  def try_parse_game( line )
    # note: clone line; for possible test do NOT modify in place for now
    # note: returns true if parsed, false if no match
    parse_game( line.dup )
  end

  def parse_game( line )
    logger.debug "parsing game (fixture) line: >#{line}<"

    match_teams!( line )
    team1_key = find_team1!( line )
    team2_key = find_team2!( line )

    ## note: if we do NOT find two teams; return false - no match found
    if team1_key.nil? || team2_key.nil?
      logger.debug "  no game match (two teams required) found for line: >#{line}<"
      return false
    end

    pos = find_game_pos!( line )

    if is_postponed?( line )
      postponed  = true
      date_v2    = find_date!( line, start_at: @event.start_at )
      date       = find_date!( line, start_at: @event.start_at )
    else
      postponed = false
      date_v2   = nil
      date      = find_date!( line, start_at: @event.start_at )
    end

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


    ####
    # note:
    #  only map ground if we got any grounds (setup/configured in event)
    
    if @event.grounds.count > 0
     
     ## todo/check: use @known_grounds for check?? why? why not??
     ## use in @known_grounds  = TextUtils.build_title_table_for( @event.grounds )

     ##
     # fix: mark mapped title w/ type (ground-) or such!! - too avoid fallthrough match
     #  e.g. three teams match - but only two get mapped, third team gets match for ground
     #    e.g Somalia v Djibouti  @ Djibouti
      map_ground!( line )
      ground_key = find_ground!( line )
      ground =  ground_key.nil? ? nil : Ground.find_by_key!( ground_key )
    else
      # no grounds configured; always nil
      ground = nil
    end

    logger.debug "  line: >#{line}<"


    ### todo: cache team lookups in hash?

    team1 = Team.find_by_key!( team1_key )
    team2 = Team.find_by_key!( team2_key )


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
      end

      # store pos for auto-number next round if missing
      #  - note: only if greater/bigger than last; use max
      #  - note: last_round_pos might be nil - thus set to 0
      @last_round_pos = [round.pos,@last_round_pos||0].max

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
      score1:    scores[0],
      score2:    scores[1],
      score1et:  scores[2],
      score2et:  scores[3],
      score1p:   scores[4],
      score2p:   scores[5],
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

    return true   # game match found
  end # method parse_game


  def try_parse_date_header( line )
    # note: clone line; for possible test do NOT modify in place for now
    # note: returns true if parsed, false if no match
    parse_date_header( line.dup )
  end

  def parse_date_header( line )
    # note: returns true if parsed, false if no match
 
    # line with NO teams  plus include date e.g.
    #   [Fri Jun/17]  or
    #   Jun/17  or
    #   Jun/17:   etc.


    match_teams!( line )
    team1_key = find_team1!( line )
    team2_key = find_team2!( line )

    date  = find_date!( line, start_at: @event.start_at )

    if date && team1_key.nil? && team2_key.nil?
      logger.debug( "date header line found: >#{line}<")
      logger.debug( "    date: #{date}")
      
      @last_date = date   # keep a reference for later use
      return true
    else
      return false
    end
  end



  def parse_fixtures( reader )
      
    reader.each_line do |line|

      if is_round_def?( line ) 
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
        logger.info "skipping line (no match found): >#{line}<"
      end
    end # lines.each


###
#  fix: do NOT patch if auto flag is set to false !!!
#   e.g. rounds got added w/ round def (not w/ round header)

    @patch_rounds.each do |k,v|
      logger.debug "patch start_at/end_at date for round #{k}:"
      round = Round.find( k )
      games = round.games.order( 'play_at asc' ).all
      
      ## skip rounds w/ no games
      
      ## todo/fix: what's the best way for checking assoc w/ 0 recs?
      next if games.size == 0
    
      round_attribs = {}
      
      ## todo: check for no records
      ##  e.g. if game[0].present? or just if game[0]  ??

      # note: make sure start_at/end_at is date only (e.g. use play_at.to_date)
      #   sqlite3 saves datetime in date field as datetime, for example (will break date compares later!)

      round_attribs[:start_at] = games[0].play_at.to_date
      round_attribs[:end_at  ] = games[-1].play_at.to_date

      logger.debug round_attribs.to_json
      round.update_attributes!( round_attribs )
    end
    
  end # method parse_fixtures

end # class GameReader
end # module SportDb
