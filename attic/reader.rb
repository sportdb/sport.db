

  def is_club_fixture?( name )
    ### fix: move to attic - no longer needed ??
    ##   - use clubs.txt for clubs; and teams.txt for national teams

    ## guess (heuristic) if it's a national team event (e.g. world cup, copa america, etc.)
    ##  or club event (e.g. bundesliga, club world cup, etc.)

    if name =~ /club-world-cup!?\//      # NB: must go before -cup (special case)
      true
    elsif name =~ /copa-america!?\// ||  # NB: copa-america/ or copa-america!/
          name =~ /-cup!?\//             # NB: -cup/ or -cup!/
      false
    else
      true
    end
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

  ####
  # todo/fix: move to EventReader - why? why not??
  ##  store fixtures attrib and event attrib
  ##  for later queries?? (single-read/parse op) - why? why not??

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


