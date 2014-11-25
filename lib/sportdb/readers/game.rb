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

  def self.from_zip( zip_file, entry_path, more_attribs={} )

    logger = LogKernel::Logger.root

    reader = EventReader.from_zip( zip_file, entry_path )
    reader.read()

    event    = reader.event      ## was fetch_event( name )
    fixtures = reader.fixtures   ## was fetch_event_fixtures( name )

    if fixtures.empty?
      ## logger.warn "no fixtures found for event - >#{name}<; assume fixture name is the same as event"
      ## change extension from .yml to .txt
      fixtures_with_path = [ entry_path.sub('.yml','.txt') ]
    else
      ## add path to fixtures (use path from event e.g)
      #  - bl    + at-austria!/2012_13/bl  -> at-austria!/2012_13/bl
      #  - bl_ii + at-austria!/2012_13/bl  -> at-austria!/2012_13/bl_ii

      dir = File.dirname( entry_path ) # use dir for fixtures

      fixtures_with_path = fixtures.map do |fx|
        fx_new = "#{dir}/#{fx}.txt"   # add path upfront
        logger.debug "fx: #{fx_new} | >#{fx}< + >#{dir}<"
        fx_new
      end
    end

    ## fix-fix-fix: change file extension to ??
    text_ary = []
    fixtures_with_path.each do |fixture_path|
      entry = zip_file.find_entry( fixture_path )

      text = entry.get_input_stream().read()
      text = text.force_encoding( Encoding::UTF_8 )

      text_ary << text
    end

    self.from_string( event, text_ary, more_attribs )
  end

  def self.from_file( path, more_attribs={} )

    logger = LogKernel::Logger.root

    ### NOTE: fix-fix-fix - pass in event path!!!!!!! (not fixture path!!!!)
    
    ## - ## note: assume/enfore utf-8 encoding (with or without BOM - byte order mark)
    ## - ## - see textutils/utils.rb
    ## - text = File.read_utf8( path )

    reader = EventReader.from_file( path )
    reader.read()

    event    = reader.event      ## was fetch_event( name )
    fixtures = reader.fixtures   ## was fetch_event_fixtures( name )


    if fixtures.empty?
      ## logger.warn "no fixtures found for event - >#{name}<; assume fixture name is the same as event"
      ## change extension from .yml to .txt
      fixtures_with_path = [ path.sub('.yml','.txt') ]
    else
      ## add path to fixtures (use path from event e.g)
      #  - bl    + at-austria!/2012_13/bl  -> at-austria!/2012_13/bl
      #  - bl_ii + at-austria!/2012_13/bl  -> at-austria!/2012_13/bl_ii

      dir = File.dirname( path ) # use dir for fixtures

      fixtures_with_path = fixtures.map do |fx|
        fx_new = "#{dir}/#{fx}.txt"   # add path upfront
        logger.debug "fx: #{fx_new} | >#{fx}< + >#{dir}<"
        fx_new
      end
    end

    ## fix-fix-fix: change file extension to ??
    text_ary = []
    fixtures_with_path.each do |fixture_path|
       text_ary << File.read_utf8( fixture_path )
    end

    self.from_string( event, text_ary, more_attribs )
  end


  def self.from_string( event, text_or_text_ary, more_attribs={} )
    ### fix - fix -fix:
    ##  change event to event_or_event_key !!!!!  - allow event_key as string passed in
    GameReader.new( event, text_or_text_ary, more_attribs )
  end  


  def initialize( event, text_or_text_ary, more_attribs={} )
    ### fix - fix -fix:
    ##  change event to event_or_event_key !!!!!  - allow event_key as string passed in

    ## todo/fix: how to add opts={} ???
    @event             = event
    @text_or_text_ary  = text_or_text_ary
    @more_attribs      = more_attribs
  end


  def read()
    if @text_or_text_ary.is_a?( String )
      text_ary = [@text_or_text_ary]
    else
      text_ary = @text_or_text_ary
    end

    ## reset cached values
    ##  for auto-number rounds etc.
    @last_round_pos = nil

    text_ary.each do |text|
      ## assume en for now? why? why not?
      ##  fix (cache) store lang in event table (e.g. auto-add and auto-update)!!!
      SportDb.lang.lang = SportDb.lang.classify( text )

      reader = LineReader.from_string( text )

      read_fixtures_worker( @event.key, reader )
    end

    ## fix add prop ??
    ### Prop.create!( key: "db.#{fixture_name_to_prop_key(name)}.version", value: "file.txt.#{File.mtime(path).strftime('%Y.%m.%d')}" )  
  end


  def read_fixtures_worker( event_key, reader )
    ## NB: assume active activerecord connection

    ## reset cached values
    @patch_round_ids_dates = []
    @patch_round_ids_pos   = []

    @round         = nil     ## fix: change/rename to @last_round !!!
    @group         = nil     ## fix: change/rename to @last_group !!!
    @last_date     = nil

    @last_team1    = nil    # used for goals (to match players via squads)
    @last_team2    = nil
    @last_game     = nil


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

    # note: group header resets (last) round  (allows, for example):
    #  e.g.
    #  Group Playoffs/Replays       -- round header
    #    team1 team2                -- match 
    #  Group B:                     -- group header
    #    team1 team2 - match  (will get new auto-matchday! not last round)
    @round         = nil     ## fix: change/rename to @last_round !!!

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
      if @patch_round_ids_pos.empty?
        pos = (@last_round_pos||0)+1
        logger.debug( "  no round pos found; auto-number round - use (#{pos})" )
      else
        # note: if any rounds w/o pos already seen (add for auto-numbering at the end)
        #  will get auto-numbered sorted by start_at date
        pos = 999001+@patch_round_ids_pos.length   # e.g. 999<count> - 999001,999002,etc.
        logger.debug( "  no round pos found; auto-number round w/ patch (backtrack) at the end" )
      end
    end

    # store pos for auto-number next round if missing
    #  - note: only if greater/bigger than last; use max
    #  - note: last_round_pos might be nil - thus set to 0
    if pos > 999000
      # note: do NOT update last_round_pos for to-be-patched rounds
    else
      @last_round_pos = [pos,@last_round_pos||0].max
    end


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
    
    @last_game = game   # store for later reference (e.g. used for goals etc.)

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


  def parse_goals( line )
    logger.debug "parsing goals (fixture) line: >#{line}<"

    goals = GoalsFinder.new.find!( line )

    ## check if squads/rosters present for player mappings
    #
    squad1_count = Roster.where( event_id: @event.id, team_id: @last_team1 ).count
    if squad1_count > 0
       squad1 = Roster.where( event_id: @event.id, team_id: @last_team1 ) 
    else
       squad1 = []
    end

    squad2_count = Roster.where( event_id: @event.id, team_id: @last_team2 ).count 
    if squad2_count > 0
      squad2 = Roster.where( event_id: @event.id, team_id: @last_team2 )
    else
      squad2 = []
    end

    #####
    # todo/fix: try lookup by squads first!!!
    #   issue warning if player not included in squad!!

    ##########
    # try mapping player names to player

    ## note: first delete all goals for match (and recreate new ones
    #     no need to figure out update/merge strategy)
    @last_game.goals.delete_all


    goals.each do |goal|
      player_name = goal.name

      player = Person.where( name: player_name ).first
      if player
        logger.info "  player match (name eq) - using player key #{player.key}"
      else
        # try like match (player name might only include part of name e.g. Messi)
        #  try three variants
        # try %Messi
        # try Messi%
        # try %Messi%   -- check if there's an easier way w/ "one" where clause?
        player = Person.where( 'name LIKE ? OR name LIKE ? OR name LIKE ?',
                              "%#{player_name}",
                              "#{player_name}%",
                              "%#{player_name}%"
                             ).first

        if player
          logger.info "  player match (name like) - using player key #{player.key}"
        else
           # try synonyms
           player = Person.where( 'synonyms LIKE ? OR synonyms LIKE ? OR synonyms LIKE ?',
                              "%#{player_name}",
                              "#{player_name}%",
                              "%#{player_name}%"
                             ).first
           if player
             logger.info "  player match (synonyms like) - using player key #{player.key}"
           else
             # auto-create player (player not found)
             logger.info "  player NOT found >#{player_name}< - auto-create"
             
             ## fix: add auto flag (for auto-created persons/players)
             ## fix: move title_to_key logic to person model etc.
             player_key = TextUtils.title_to_key( player_name )
             player_attribs = {
               key:   player_key,
               title: player_name
             }
             logger.info "   using attribs: #{player_attribs.inspect}"
             
             player = Person.create!( player_attribs )
           end
        end
      end

      goal_attribs = {
        game_id:   @last_game.id,
        team_id:   goal.team == 1 ? @last_team1.id : @last_team2.id, 
        person_id: player.id,
        minute:    goal.minute,
        offset:    goal.offset,
        penalty:   goal.penalty,
        owngoal:   goal.owngoal,
        score1:    goal.score1,
        score2:    goal.score2
      }

      logger.info "  adding goal using attribs: #{goal_attribs.inspect}"
      Goal.create!( goal_attribs )
    end # each goals

  end # method parse_goals


=begin
###### add to person and use!!!
def self.create_or_update_from_values( values, more_attribs={} )
    ## key & title required

    attribs, more_values = find_key_n_title( values )
    attribs = attribs.merge( more_attribs )

    ## check for optional values
    Person.create_or_update_from_attribs( attribs, more_values )
  end
=end


  def parse_fixtures( reader )
      
    reader.each_line do |line|

      if is_goals?( line )
        parse_goals( line )
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
        logger.info "skipping line (no match found): >#{line}<"
      end
    end # lines.each

    ###########################
    # backtrack and patch round pos and round dates (start_at/end_at)
    #  note: patch dates must go first! (otherwise sort_by_date will not work for round pos)

    unless @patch_round_ids_dates.empty?
      ###
      #  fix: do NOT patch if auto flag is set to false !!!
      #   e.g. rounds got added w/ round def (not w/ round header)

      # note: use uniq - to allow multiple round headers (possible?)

      Round.find( @patch_round_ids_dates.uniq ).each do |r|
        logger.debug "patch round start_at/end_at date for #{r.title}:"

        ## note:
        ## will add "scope" pos first e.g
        #
        ## SELECT "games".* FROM "games"  WHERE "games"."round_id" = ?
        # ORDER BY pos, play_at asc  [["round_id", 7]]
        #   thus will NOT order by play_at but by pos first!!!
        # =>
        #  need to unscope pos!!! or use unordered_games - games_by_play_at_date etc.??
        #   thus use reorder()!!! - not just order('play_at asc')

        games = r.games.reorder( 'play_at asc' ).all

        ## skip rounds w/ no games

        ## todo/check/fix: what's the best way for checking assoc w/ 0 recs?
        next if games.size == 0

        # note: make sure start_at/end_at is date only (e.g. use play_at.to_date)
        #   sqlite3 saves datetime in date field as datetime, for example (will break date compares later!)

        round_attribs = {
          start_at: games[0].play_at.to_date,   # use games.first ?
          end_at:   games[-1].play_at.to_date  # use games.last ? why? why not?
        }

        logger.debug round_attribs.to_json
        r.update_attributes!( round_attribs )
      end
    end

    unless @patch_round_ids_pos.empty?

      # step 0: check for offset (last_round_pos)
      if @last_round_pos
        offset = @last_round_pos
        logger.info "  +++ patch round pos - use offset; start w/ #{offset}"
      else
        offset = 0
        logger.debug "  patch round pos - no offset; start w/ 0"
      end

      # step 1: sort by date
      # step 2: update pos
      # note: use uniq - to allow multiple round headers (possible?)
      Round.order( 'start_at asc').find( @patch_round_ids_pos.uniq ).each_with_index do |r,idx|
        # note: starts counting w/ zero(0)
        logger.debug "[#{idx+1}] patch round pos >#{offset+idx+1}< for #{r.title}:"
        round_attribs = {
          pos: offset+idx+1
        }

        # update title if Matchday XXXX  e.g. use Matchday 1 etc.
        if r.title.starts_with?('Matchday')
          round_attribs[:title] = "Matchday #{offset+idx+1}"
        end

        logger.debug round_attribs.to_json
        r.update_attributes!( round_attribs )

        # update last_round_pos offset too
        @last_round_pos = [offset+idx+1,@last_round_pos||0].max
      end
    end

  end # method parse_fixtures

end # class GameReader
end # module SportDb
