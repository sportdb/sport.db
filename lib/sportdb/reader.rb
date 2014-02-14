# encoding: utf-8

module SportDb

module Matcher

  include WorldDb::Matcher

  def match_leagues_for_country( name, &blk )
    match_xxx_for_country( name, 'leagues', &blk )
  end

  def match_teams_for_country( name, &blk )
    match_xxx_for_country( name, 'teams', &blk )
  end

  def match_tracks_for_country( name, &blk )
    match_xxx_for_country( name, 'tracks', &blk )
  end

  def match_skiers_for_country( name, &blk )
    match_xxx_for_country( name, 'skiers', &blk )
  end

  def match_stadiums_for_country( name, &blk )
    match_xxx_for_country( name, 'stadiums', &blk )
  end

end # module Matcher


class Reader

  include LogUtils::Logging


## make models available in sportdb module by default with namespace
#  e.g. lets you use Team instead of Models::Team 
  include SportDb::Models
  include SportDb::Matcher # lets us use match_teams_for_country etc.


  attr_reader :include_path

  def initialize( include_path, opts={})
    @include_path = include_path
  end

  def load_setup( name )
    path = "#{include_path}/#{name}.yml"

    logger.info "parsing data '#{name}' (#{path})..."

    reader = FixtureReader.new( path )

    reader.each do |fixture_name|
      load( fixture_name )
    end
  end # method load_setup


  def load( name )   # convenience helper for all-in-one reader

    logger.debug "enter load( name=>>#{name}<<, include_path=>>#{include_path}<<)"
    
    if name  =~ /^circuits/  # e.g. circuits.txt in formula1.db
      load_tracks( name )
    elsif match_tracks_for_country( name ) do |country_key|  # name =~ /^([a-z]{2})\/tracks/
            # auto-add country code (from folder structure) for country-specific tracks
            #  e.g. at/tracks  or at-austria/tracks
            country = Country.find_by_key!( country_key )
            load_tracks( name, country_id: country.id )
          end
    elsif name  =~ /^tracks/  # e.g. tracks.txt in ski.db
      load_tracks( name )
    elsif name =~ /^drivers/ # e.g. drivers.txt in formula1.db
      load_persons( name )
    elsif match_skiers_for_country( name ) do |country_key|  # name =~ /^([a-z]{2})\/skiers/
            # auto-add country code (from folder structure) for country-specific skiers (persons)
            #  e.g. at/skiers  or at-austria/skiers.men
            country = Country.find_by_key!( country_key )
            load_persons( name, country_id: country.id )
          end
    elsif name =~ /^skiers/ # e.g. skiers.men.txt in ski.db
      load_persons( name )
    elsif name =~ /^teams/   # e.g. teams.txt in formula1.db
      load_teams( name )
    elsif name =~ /\/races/  # e.g. 2013/races.txt in formula1.db
      load_races( name )
    elsif name =~ /\/squads/ || name =~ /\/rosters/  # e.g. 2013/squads.txt in formula1.db
      load_rosters( name )
    elsif name =~ /\/([0-9]{2})-/
      race_pos = $1.to_i
      # NB: assume @event is set from previous load 
      race = Race.find_by_event_id_and_pos( @event.id, race_pos )
      load_records( name, race_id: race.id ) # e.g. 2013/04-gp-monaco.txt in formula1.db
    elsif name =~ /(?:^|\/)seasons/  # NB: ^seasons or also possible at-austria!/seasons
      load_seasons( name )
    elsif match_stadiums_for_country( name ) do |country_key|
            country = Country.find_by_key!( country_key )
            load_stadiums( name, country_id: country.id )
          end
    elsif match_leagues_for_country( name ) do |country_key|  # name =~ /^([a-z]{2})\/leagues/
            # auto-add country code (from folder structure) for country-specific leagues
            #  e.g. at/leagues
            country = Country.find_by_key!( country_key )
            load_leagues( name, club: true, country_id: country.id )
          end
    elsif name =~ /(?:^|\/)leagues/   # NB: ^leagues or also possible world!/leagues  - NB: make sure goes after leagues_for_country!!
      if name =~ /-cup!?\//          ||   # NB: -cup/ or -cup!/
         name =~ /copa-america!?\//       # NB: copa-america/ or copa-america!/
        # e.g. national team tournaments/leagues (e.g. world-cup/ or euro-cup/)
        load_leagues( name, club: false )
      else
        # e.g. leagues_club
        load_leagues( name, club: true )
      end
    elsif match_teams_for_country( name ) do |country_key|   # name =~ /^([a-z]{2})\/teams/
            # auto-add country code (from folder structure) for country-specific teams
            #  e.g. at/teams at/teams.2 de/teams etc.                
            country = Country.find_by_key!( country_key )
            load_teams( name, club: true, country_id: country.id )
          end
    elsif name =~ /(?:^|\/)teams/
      if name =~ /-cup!?\//         ||    # NB: -cup/ or -cup!/
         name =~ /copa-america!?\//       # NB: copa-america/ or copa-america!/
        # assume national teams
        # e.g. world-cup/teams  amercia-cup/teams_northern
        load_teams( name, club: false )
      else
        # club teams (many countries)
        # e.g. club/europe/teams
        load_teams( name, club: true )
      end
    elsif name =~ /\/(\d{4}|\d{4}_\d{2})\// || name =~ /\/(\d{4}|\d{4}_\d{2})$/
      # e.g. must match /2012/ or /2012_13/
      #  or   /2012 or /2012_13   e.g. brazil/2012 or brazil/2012_13
      load_event( name )
      event    = fetch_event( name )
      fixtures = fetch_event_fixtures( name )
      fixtures.each do |fx|
        load_fixtures( event.key, fx )
      end
    else
      logger.error "unknown sportdb fixture type >#{name}<"
      # todo/fix: exit w/ error
    end
  end # method load

 
  def load_stadiums( name, more_attribs={} )
    reader = ValuesReaderV2.new( name, include_path, more_attribs )

    reader.each_line do |new_attributes, values|
      Ground.create_or_update_from_values( new_attributes, values )
    end # each lines
  end


  def load_leagues( name, more_attribs={} )

    reader = ValuesReaderV2.new( name, include_path, more_attribs )

    reader.each_line do |new_attributes, values|
      League.create_or_update_from_values( new_attributes, values )
    end # each lines

  end # load_leagues


  def load_tracks( name, more_attribs={} )

    reader = ValuesReaderV2.new( name, include_path, more_attribs )

    reader.each_line do |new_attributes, values|
      Track.create_or_update_from_values( new_attributes, values )
    end # each lines

  end # load_tracks



  def load_persons( name, more_attribs={} )

    reader = ValuesReaderV2.new( name, include_path, more_attribs )

    reader.each_line do |new_attributes, values|
      Person.create_or_update_from_values( new_attributes, values )
    end # each lines

  end # load_persons


  def load_seasons( name )

    reader = LineReaderV2.new( name, include_path )

####
## fix!!!!!
##   use Season.create_or_update_from_hash or similar
##   use Season.create_or_update_from_hash_reader?? or similar
#   move parsing code to model

    reader.each_line do |line|

      # for now assume single value
      logger.debug ">#{line}<"

      key = line

      logger.debug "  find season key: #{key}"
      season = Season.find_by_key( key )

      season_attribs = {}

      ## check if it exists
      if season.present?
        logger.debug "update season #{season.id}-#{season.key}:"
      else
        logger.debug "create season:"
        season = Season.new
        season_attribs[ :key ] = key
      end

      season_attribs[ :title ] = key # for now key n title are the same
     
      logger.debug season_attribs.to_json
          
      season.update_attributes!( season_attribs )
    end # each line

  end  # load_seasons


  def fetch_event_fixtures( name )
    # todo: merge with fetch_event to make it single read op - why? why not??
    reader = HashReaderV2.new( name, include_path )

    fixtures = []

    reader.each_typed do |key, value|
      if key == 'fixtures' && value.kind_of?( Array )
        logger.debug "fixtures:"
        logger.debug value.to_json
        ## todo: make sure we get an array!!!!!
        fixtures = value
      else
        # skip; do nothing
      end
    end # each key,value

    if fixtures.empty?
      ## logger.warn "no fixtures found for event - >#{name}<; assume fixture name is the same as event"
      fixtures = [name]
    else
      ## add path to fixtures (use path from event e.g)
      #  - bl    + at-austria!/2012_13/bl  -> at-austria!/2012_13/bl
      #  - bl_ii + at-austria!/2012_13/bl  -> at-austria!/2012_13/bl_ii

      dir = File.dirname( name ) # use dir for fixtures

      fixtures = fixtures.map do |fx|
        fx_new = "#{dir}/#{fx}"   # add path upfront
        logger.debug "fx: #{fx_new} | >#{fx}< + >#{dir}<"
        fx_new
      end
    end

    fixtures
  end


  def fetch_event( name )
    # get/fetch/find event from yml file

    ## todo/fix: use h = HashFile.load( path ) or similar instead of HashReader!!

    ## todo/fix: add option for not adding prop automatically?? w/ HashReaderV2

    reader = HashReaderV2.new( name, include_path )

    event_attribs = {}

    reader.each_typed do |key, value|

      ## puts "processing event attrib >>#{key}<< >>#{value}<<..."

      if key == 'league'
        league = League.find_by_key!( value.to_s.strip )
        event_attribs[ 'league_id' ] = league.id
      elsif key == 'season'
        season = Season.find_by_key!( value.to_s.strip )
        event_attribs[ 'season_id' ] = season.id
      else
        # skip; do nothing
      end
    end # each key,value

    league_id = event_attribs['league_id']
    season_id = event_attribs['season_id']
    
    event = Event.find_by_league_id_and_season_id!( league_id, season_id )
    event
  end


  def load_event( name )

####
## fix!!!!!
##   use Event.create_or_update_from_hash or similar
##   use Event.create_or_update_from_hash_reader?? or similar
#   move parsing code to model

    reader = HashReaderV2.new( name, include_path )

    event_attribs = {}
    
    ## set default sources to basename by convention
    #  e.g  2013_14/bl  => bl
    #  etc.
    # use fixtures/sources: to override default

    event_attribs[ 'sources' ] = File.basename( name )
    event_attribs[ 'config'  ] = File.basename( name )  # name a of .yml file

    reader.each_typed do |key, value|

      ## puts "processing event attrib >>#{key}<< >>#{value}<<..."

      if key == 'league'
        league = League.find_by_key( value.to_s.strip )

        ## check if it exists
        if league.present?
          event_attribs['league_id'] = league.id
        else
          logger.error "league with key >>#{value.to_s.strip}<< missing"
          exit 1
        end
       
      elsif key == 'season'
        season = Season.find_by_key( value.to_s.strip )

        ## check if it exists
        if season.present?
          event_attribs['season_id'] = season.id
        else
          logger.error "season with key >>#{value.to_s.strip}<< missing"
          exit 1
        end
        
      elsif key == 'start_at' || key == 'begin_at'
        
        if value.is_a?(DateTime) || value.is_a?(Date)
          start_at = value
        else # assume it's a string
          start_at = DateTime.strptime( value.to_s.strip, '%Y-%m-%d' )
        end
        
        event_attribs['start_at'] = start_at

      elsif key == 'end_at' || key == 'stop_at'
        
        if value.is_a?(DateTime) || value.is_a?(Date)
          end_at = value
        else # assume it's a string
          end_at = DateTime.strptime( value.to_s.strip, '%Y-%m-%d' )
        end
        
        event_attribs['end_at'] = end_at

      elsif key == 'grounds' || key == 'stadiums' || key == 'venues'
        ## assume grounds value is an array
        
        ground_ids = []
        value.each do |item|
          ground_key = item.to_s.strip
          ground = Ground.find_by_key!( ground_key )
          ground_ids << ground.id
        end
        
        event_attribs['ground_ids'] = ground_ids
      elsif key == 'teams'
        ## assume teams value is an array
        
        team_ids = []
        value.each do |item|
          team_key = item.to_s.strip
          team = Team.find_by_key!( team_key )
          team_ids << team.id
        end
        
        event_attribs['team_ids'] = team_ids
        
      elsif key == 'team3'
        ## for now always assume false  # todo: fix - use value and convert to boolean if not boolean
        event_attribs['team3'] = false
      elsif key == 'fixtures' || key == 'sources'
        if value.kind_of?(Array)
          event_attribs['sources'] = value.join(',') 
        else # assume plain (single fixture) string
          event_attribs['sources'] = value.to_s
        end
      else
        ## todo: add a source location struct to_s or similar (file, line, col)
        logger.error "unknown event attrib #{key}; skipping attrib"
      end

    end # each key,value

    league_id = event_attribs['league_id']
    season_id = event_attribs['season_id']

    logger.debug "find event - league_id: #{league_id}, season_id: #{season_id}"

    event = Event.find_by_league_id_and_season_id( league_id, season_id )

    ## check if it exists
    if event.present?
      logger.debug "*** update event #{event.id}-#{event.key}:"
    else
      logger.debug "*** create event:"
      event = Event.new
    end
    
    logger.debug event_attribs.to_json
    
    event.update_attributes!( event_attribs )

  end  # load_event



  def load_fixtures_from_string( event_key, text )  # load from string (e.g. passed in via web form)

    SportDb.lang.lang = SportDb.lang.classify( text )

    ## todo/fix: move code into LineReader e.g. use LineReader.fromString() - why? why not?
    reader = StringLineReader.new( text )
    
    load_fixtures_worker( event_key, reader )

    ## fix add prop 
    ### Prop.create!( key: "db.#{fixture_name_to_prop_key(name)}.version", value: "file.txt.#{File.mtime(path).strftime('%Y.%m.%d')}" )  
  end

  def load_fixtures( event_key, name )  # load from file system

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



  def load_records( name, more_attribs={} )
    path = "#{include_path}/#{name}.txt"

    logger.info "parsing data '#{name}' (#{path})..."

    ### SportDb.lang.lang = LangChecker.new.analyze( name, include_path )

    reader = LineReader.new( path )

    ## for now: use all tracks (later filter/scope by event)
    # @known_tracks = Track.known_tracks_table

    ## fix: add @known_teams  - for now; use teams (not scoped by event)
    @known_teams   = TextUtils.build_title_table_for( Team.all )
    ## and for now use all persons
    @known_persons = TextUtils.build_title_table_for( Person.all )

    load_records_worker( reader, more_attribs )

    Prop.create_from_fixture!( name, path )
  end

  def load_records_worker( reader, more_attribs )

    reader.each_line do |line|
      logger.debug "  line: >#{line}<"

      cut_off_end_of_line_comment!( line )

      state = find_record_leading_state!( line )

      map_team!( line )
      team_key = find_team!( line )
      team = Team.find_by_key!( team_key )

      map_person!( line )
      person_key = find_person!( line )
      person = Person.find_by_key!( person_key )

      timeline = find_record_timeline!( line )

      laps  = find_record_laps!( line )
      
      comment = find_record_comment!( line )

      logger.debug "  line2: >#{line}<"

      record_attribs = {
        state:  state,
        ## team_id: team.id,   ## NB: not needed for db 
        person_id: person.id,
        timeline: timeline,
        comment: comment,
        laps: laps
      }

      record_attribs = record_attribs.merge( more_attribs )

      ### check if record exists
      record = Record.find_by_race_id_and_person_id( record_attribs[ :race_id ],
                                                     record_attribs[ :person_id ])

      if record.present?
        logger.debug "update Record #{record.id}:"
      else
        logger.debug "create Record:"
        record = Record.new
      end

      logger.debug record_attribs.to_json

      record.update_attributes!( record_attribs )

    end # lines.each

  end # method load_record_worker



  def load_rosters( name )
    path = "#{include_path}/#{name}.txt"

    logger.info "parsing data '#{name}' (#{path})..."

    ### SportDb.lang.lang = LangChecker.new.analyze( name, include_path )

    reader = LineReader.new( path )

    ## for now: use all tracks (later filter/scope by event)
    # @known_tracks = Track.known_tracks_table

    ## fix: add @known_teams  - for now; use teams (not scoped by event)
    ## for now use all teams
    @known_teams   = TextUtils.build_title_table_for( Team.all )
    ## and for now use all persons
    @known_persons = TextUtils.build_title_table_for( Person.all )


    load_rosters_worker( reader )

    Prop.create_from_fixture!( name, path )  
  end

  def load_rosters_worker( reader )

    reader.each_line do |line|
      logger.debug "  line: >#{line}<"

      cut_off_end_of_line_comment!( line )

      pos = find_leading_pos!( line )

      map_team!( line )
      team_key = find_team!( line )
      team = Team.find_by_key!( team_key )

      map_person!( line )
      person_key = find_person!( line )
      person = Person.find_by_key!( person_key )

      logger.debug "  line2: >#{line}<"

      ### check if roster record exists
      roster = Roster.find_by_event_id_and_team_id_and_person_id( @event.id, team.id, person.id )

      if roster.present?
        logger.debug "update Roster #{roster.id}:"
      else
        logger.debug "create Roster:"
        roster = Roster.new
      end

      roster_attribs = {
        pos:       pos,
        team_id:   team.id,
        person_id: person.id,
        event_id:  @event.id   # NB: reuse/fallthrough from races - make sure load_races goes first (to setup event)
      }

      logger.debug roster_attribs.to_json

      roster.update_attributes!( roster_attribs )
    end # lines.each

  end # method load_rosters_worker



  def load_races( name )
    load_event( name )   # must have .yml file with same name for event definition
    @event = fetch_event( name )

    logger.info "  event: #{@event.key} >>#{@event.full_title}<<"

    path = "#{include_path}/#{name}.txt"

    logger.info "parsing data '#{name}' (#{path})..."
    
    ### SportDb.lang.lang = LangChecker.new.analyze( name, include_path )

    reader = LineReader.new( path )
    
    ## for now: use all tracks (later filter/scope by event)
    @known_tracks = Track.known_tracks_table
    
    load_races_worker( reader )

    Prop.create_from_fixture!( name, path )
  end


  def load_races_worker( reader )

    reader.each_line do |line|
      logger.debug "  line: >#{line}<"

      cut_off_end_of_line_comment!( line )

      pos = find_leading_pos!( line )

      map_track!( line )
      track_key = find_track!( line )
      track = Track.find_by_key!( track_key )

      date      = find_date!( line )

      logger.debug "  line2: >#{line}<"

      ### check if games exists
      race = Race.find_by_event_id_and_track_id( @event.id, track.id )

      if race.present?
        logger.debug "update race #{race.id}:"
      else
        logger.debug "create race:"
        race = Race.new
      end
          
      race_attribs = {
        pos:      pos,
        track_id: track.id,
        start_at:  date,
        event_id:  @event.id
      }

      logger.debug race_attribs.to_json

      race.update_attributes!( race_attribs )
    end # lines.each

  end # method load_races_worker


  def load_teams( name, more_attribs={} )
    reader = ValuesReaderV2.new( name, include_path, more_attribs )

    reader.each_line do |new_attributes, values|
      Team.create_or_update_from_values( new_attributes, values )
    end # each lines
  end # load_teams

private

  include SportDb::FixtureHelpers

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

  
end # class Reader
end # module SportDb
