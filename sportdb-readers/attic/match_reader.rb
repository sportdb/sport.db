def parse( season: nil )
  recs = LeagueOutlineReader.parse( @txt, season: season )
  pp recs

  recs.each do |rec|
    league = Sync::League.find_or_create( rec[:league] )
    season = Sync::Season.find_or_create( rec[:season] )

    ## hack for now: switch lang
    ##
    ##  todo/fix: use rec[:league] and rec[:season] here (hold off dependency on ActiveRecord!!! )
    if rec[:league].intl?   ## todo/fix: add intl? to ActiveRecord league!!!
      SportDb.lang.lang = 'en'
      DateFormats.lang  = 'en'
    else  ## assume national/domestic
      if ['de', 'at'].include?( league.country.key )
        SportDb.lang.lang = 'de'
        DateFormats.lang  = 'de'
      elsif ['fr'].include?( league.country.key )
        SportDb.lang.lang = 'fr'
        DateFormats.lang  = 'fr'
      elsif ['it'].include?( league.country.key )
        SportDb.lang.lang = 'it'
        DateFormats.lang  = 'it'
      elsif ['es', 'mx'].include?( league.country.key )
        SportDb.lang.lang = 'es'
        DateFormats.lang  = 'es'
      elsif ['pt', 'br'].include?( league.country.key )
        SportDb.lang.lang = 'pt'
        DateFormats.lang  = 'pt'
      else
        SportDb.lang.lang = 'en'
        DateFormats.lang  = 'en'
      end
    end

    ## todo/fix:
    ##    always auto create
    ##   1) check for teams count on event/stage - only if count == 0 use autoconf!!!
    ##   2) add lang switch for date/lang too!!!!

    event = Sync::Event.find_or_create_by( league: rec[:league],
                                           season: Import::Season.new(rec[:season]) )

    stage = if rec[:stage]
      Sync::Stage.find_or_create( rec[:stage], event: event )
    else
      nil
    end


    auto_conf_teams, _ = AutoConfParser.parse( rec[:lines],
                                               start: event.start_at )

    ## step 1: map/find teams
    team_mapping = {}   ## name => database (ActiveRecord) record

    teams     =  stage ? stage.teams    : event.teams
    team_ids  =  stage ? stage.team_ids : event.team_ids


    ## note: loop over keys (holding the names); values hold the usage counter!! e.g. 'Arsenal' => 2, etc.
    if rec[:league].clubs?
      if rec[:league].intl?    ## todo/fix: add intl? to ActiveRecord league!!!

      ### quick hack mods for popular/known ambigious club names
      ##    todo/fix: make more generic / reuseable!!!!
      mods = {
       'uefa.cl' => { 'Liverpool'     => catalog.clubs.find_by!( name: 'Liverpool FC', country: 'ENG' ),
                      'Liverpool FC'  => catalog.clubs.find_by!( name: 'Liverpool FC', country: 'ENG' ),
                      'Arsenal'       => catalog.clubs.find_by!( name: 'Arsenal FC',   country: 'ENG' ),
                      'Arsenal FC'    => catalog.clubs.find_by!( name: 'Arsenal FC',   country: 'ENG' ),
                      'Barcelona'     => catalog.clubs.find_by!( name: 'FC Barcelona', country: 'ESP' ),
                      'Valencia'      => catalog.clubs.find_by!( name: 'Valencia CF',  country: 'ESP' ),
                    }
      }
      mods[ 'uefa.el' ] = mods[ 'uefa.cl' ]   ## europa league uses same mods as champions league

      known_club_mods  = mods[ rec[:league].key ]

      ## build a quick lookup map (w/ canonical name) to check if club alreay in db
      ##  todo/fix: to double check use club.title+club.country.key  for lookup (that is,add country.key) - why? why not?
      known_clubs      = teams.reduce( {} ) {|h,club| h[club.title]=club; h }

      auto_conf_teams.keys.each do |name|
        club_rec = nil
        m = catalog.clubs.match( name )
        if m.nil?
          puts "no match found for club >#{name}<; sorry - add to clubs repo"
          exit 1
        elsif m.size == 1
          club_rec = m[0]
        else  ## assume more than one match
          ## 1) check for "hard-coded" club mod
          if known_club_mods
            m = m.select {|club_rec| club_rec == known_club_mods[name] }
          end
          ## 2) check for best match in db config next (if still ambigious)
          if m.size > 1
            m = m.select {|club_rec| known_clubs[ club_rec.name ] }
          end

          if m.empty?
            puts "no db config match found for club >#{name}<; sorry - update db config >#{rec[:league].name}<:"
            pp known_clubs
            exit 1
          elsif m.size > 1
            puts "too many db config matches found for club >#{name}<; sorry - update db config >#{rec[:league].name}<:"
            pp m
            pp known_clubs
            exit 1
          else
            club_rec = m[0]
          end
        end

        ## todo/fix:  (double) check for matching country and/or club included in db config!!!
        ##  note: only warn if known_clubs NOT empty
        if known_clubs.size > 0
          club = known_clubs[ club_rec.name ]
          if club.nil?
            puts "!! WARN: club >#{name}< => >#{club_rec.name}, #{club_rec.country.name} (#{club_rec.country.key})< not found in db config for intl competition:"
            pp known_clubs
          end
        end

        team = Sync::Club.find_or_create( club_rec )
        team_mapping[ name ] = team
      end
    else  ## assume clubs in domestic/national league tournament
      country = league.country
      auto_conf_teams.keys.each do |name|
        club_rec = catalog.clubs.find_by!( name: name, country: country )

        team = Sync::Club.find_or_create( club_rec )
        team_mapping[ name ] = team
      end
    end
  else  ## assume national teams (not clubs)
    auto_conf_teams.keys.each do |name|
      team_rec = catalog.national_teams.find!( name )

      team = Sync::NationalTeam.find_or_create( team_rec )
      team_mapping[ name ] = team
    end
  end

    ## todo/fix: check if all teams are unique
    ##   check if uniq works for club record (struct) - yes,no ??
    team_uniq = team_mapping.values.uniq

    ## step 2: add to database
    team_uniq.each do |team|
      ## add teams to event
      ##   for now check if team is alreay included
      ##   todo/fix: clear/destroy_all first - why? why not!!!

      teams << team    unless team_ids.include?( team.id )
    end



    ## todo/fix: set lang for now depending on league country!!!
    parser = MatchParserSimpleV2.new( rec[:lines],
                              team_mapping,
                              event.start_at )   ## note: keep season start_at date for now (no need for more specific stage date need for now)

    match_recs, round_recs, group_recs = parser.parse

    pp round_recs
    pp group_recs

    round_recs.each do |round_rec|
      ## quick hack:  if pos missing fill with dummy 999 for now
      round_rec.pos = 999    if round_rec.pos.nil?
      round = Sync::Round.find_or_create( round_rec, event: event )  ## check: use/rename to EventRound why? why not?
    end

    group_recs.each do |group_rec|
      group = Sync::Group.find_or_create( group_rec, event: event )   ## check: use/rename to EventGroup why? why not?
    end

    match_recs.each do |match_rec|
      ## todo/fix: pass along stage (if present): stage  - optional!!!!
      match = Sync::Match.create_or_update( match_rec, event: event )
    end
  end

  recs
end # method parse
