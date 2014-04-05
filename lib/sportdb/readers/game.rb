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
   
    ## assume active activerecord connection
    ##
    
    ## reset cached values
    @patch_rounds  = {}
    @knockout_flag = false
    @round         = nil
    
    
    @event = Event.find_by_key!( event_key )
    
    logger.debug "Event #{@event.key} >#{@event.title}<"

    ### fix: use build_title_table_for ??? why? why not??
    @known_teams  = @event.known_teams_table

    @known_grounds  = TextUtils.build_title_table_for( @event.grounds )


    parse_fixtures( reader )
    
  end   # method load_fixtures


  def parse_group( line )
    logger.debug "parsing group line: >#{line}<"
    
    match_teams!( line )
    team_keys = find_teams!( line )
      
    title, pos = find_group_title_and_pos!( line )

    logger.debug "  line: >#{line}<"

    group_attribs = {
      title: title
    }
        
    @group = Group.find_by_event_id_and_pos( @event.id, pos )
    if @group.present?
      logger.debug "update group #{@group.id}:"
    else
      logger.debug "create group:"
      @group = Group.new
      group_attribs = group_attribs.merge( {
        event_id: @event.id,
        pos:   pos
      })
    end
      
    logger.debug group_attribs.to_json
   
    @group.update_attributes!( group_attribs )

    @group.teams.clear  # remove old teams
    ## add new teams
    team_keys.each do |team_key|
      team = Team.find_by_key!( team_key )
      logger.debug "  adding team #{team.title} (#{team.code})"
      @group.teams << team
    end
  end
  
  def parse_round( line )
    logger.debug "parsing round line: >#{line}<"

    ### todo/fix/check:  move cut off optional comment in reader for all lines? why? why not?
    cut_off_end_of_line_comment!( line )  # cut off optional comment starting w/ #

    # NB: cut off optional title2 starting w/  //  first
    title2 = find_round_title2!( line )

    group_title, group_pos = find_group_title_and_pos!( line )

    pos = find_round_pos!( line )

    title = find_round_title!( line )

    ## NB: use extracted round title for knockout check
    @knockout_flag = is_knockout_round?( title )


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
      knockout: @knockout_flag
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

  def parse_game( line )
    logger.debug "parsing game (fixture) line: >#{line}<"

    pos = find_game_pos!( line )

    match_teams!( line )
    team1_key = find_team1!( line )
    team2_key = find_team2!( line )

    if is_postponed?( line )
      postponed  = true
      date_v2    = find_date!( line, start_at: @event.start_at )
      date       = find_date!( line, start_at: @event.start_at )
    else
      postponed = false
      date_v2   = nil
      date      = find_date!( line, start_at: @event.start_at )
    end

    scores = find_scores!( line )


    map_ground!( line )
    ground_key = find_ground!( line )
    ground =   ground_key.nil? ? nil : Ground.find_by_key!( ground_key )


    logger.debug "  line: >#{line}<"


    ### todo: cache team lookups in hash?

    team1 = Team.find_by_key!( team1_key )
    team2 = Team.find_by_key!( team2_key )


    ### check if games exists
    ##  with this teams in this round if yes only update
    game = Game.find_by_round_id_and_team1_id_and_team2_id(
                         @round.id, team1.id, team2.id
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
      knockout:  @knockout_flag,
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
          round_id:  @round.id,
          team1_id: team1.id,
          team2_id: team2.id
        }
          
        ## NB: use round.games.count for pos
        ##  lets us add games out of order if later needed
        more_game_attribs[ :pos ] = @round.games.count+1   if pos.nil? 

        game_attribs = game_attribs.merge( more_game_attribs )
      end

      logger.debug game_attribs.to_json
      game.update_attributes!( game_attribs )
    end

  end # method parse_game


  def parse_fixtures( reader )
      
    reader.each_line do |line|
      if is_round?( line )
        parse_round( line )
      elsif is_group?( line ) ## NB: group goes after round (round may contain group marker too)
        parse_group( line )
      else
        parse_game( line )
      end
    end # lines.each
    
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
      
      round_attribs[:start_at] = games[0].play_at
      round_attribs[:end_at  ] = games[-1].play_at

      logger.debug round_attribs.to_json
      round.update_attributes!( round_attribs )
    end
    
  end # method parse_fixtures

end # class GameReader
end # module SportDb
