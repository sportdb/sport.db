# encoding: utf-8

module SportDb

class MatchReader    ## todo/check: rename to MatchReaderV2 (use plural?) why? why not?

  def self.read( path, season: nil )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ) {|f| f.read }
    parse( txt, season: season )
  end

  def self.parse( txt, season: nil )
    new( txt ).parse( season: season )
  end


  include Logging

  def initialize( txt )
    @txt = txt
  end

  def parse( season: nil )
    secs = LeagueOutlineReader.parse( @txt, season: season )
    pp secs


    ###
    ## todo/check/fix:  move to LeagueOutlineReader for (re)use - why? why not?
    ##                    use sec[:lang] or something?
    langs = {    ## map country keys to lang codes
      'de' => 'de', ## de - Deutsch (German)
      'at' => 'de',
      'ch' => 'de',
      'fr' => 'fr', ## fr - French
      'it' => 'it', ## it - Italian
      'es' => 'es', ## es - Español (Spanish)
      'mx' => 'es',
      'ar' => 'es', ## Argentina
      'pt' => 'pt', ## pt -  Português (Portuguese)
      'br' => 'pt',
    }

    secs.each do |sec|   ## sec(tion)s
      season = sec[:season]
      league = sec[:league]
      stage  = sec[:stage]
      lines  = sec[:lines]

      ## hack for now: switch lang
      ## todo/fix: set lang for now depending on league country!!!
      if league.intl?   ## todo/fix: add intl? to ActiveRecord league!!!
        Import.config.lang = 'en'
      else  ## assume national/domestic
        Import.config.lang = langs[ league.country.key ] || 'en'
      end

      ### check if event info availabe - use start_date;
      ##    otherwise we have to guess (use a "synthetic" start_date)
      event_info = catalog.events.find_by( season: season,
                                           league: league )

      start = if event_info && event_info.start_date
                  event_info.start_date
              else
                if season.year?
                  Date.new( season.start_year, 1, 1 )
                else
                  Date.new( season.start_year, 7, 1 )
                end
              end


      ### todo/check: make sure team include teams from group def too!!!!!
      auto_conf_teams, _ = AutoConfParser.parse( lines,
                                                 start: start )

      ## step 1: map/find teams

      ## note: loop over keys (holding the names); values hold the usage counter!! e.g. 'Arsenal' => 2, etc.
      mods = nil
      if league.clubs? && league.intl?    ## todo/fix: add intl? to ActiveRecord league!!!
                ### quick hack mods for popular/known ambigious club names
                ##    todo/fix: make more generic / reuseable!!!!
                mods = {}
                ## europa league uses same mods as champions league
                mods[ 'uefa.el.quali' ] =
                mods[ 'uefa.cl.quali' ] =
                mods[ 'uefa.el' ] =
                mods[ 'uefa.cl' ] = catalog.clubs.build_mods(
                  { 'Liverpool | Liverpool FC' => 'Liverpool FC, ENG',
                    'Arsenal  | Arsenal FC'    => 'Arsenal FC, ENG',
                    'Barcelona'                => 'FC Barcelona, ESP',
                    'Valencia'                 => 'Valencia CF, ESP'  })
       end

       teams = catalog.teams.find_by!( name:   auto_conf_teams.keys,
                                       league: league,
                                       mods:   mods )

       ## build mapping - name => team struct record
       team_mapping =  auto_conf_teams.keys.zip( teams ).to_h


      parser = MatchParser.new( lines,
                                team_mapping,
                                start )   ## note: keep season start_at date for now (no need for more specific stage date need for now)

      matches, rounds, groups = parser.parse

      pp rounds
      pp groups


     ######################################################
     ## step 2: add to database

     event_rec = Sync::Event.find_or_create_by( league: league,
                                                season: season )

     stage_rec = if stage
                  Sync::Stage.find_or_create( stage, event: event_rec )
                 else
                   nil
                 end

     team_recs  =  stage_rec ? stage_rec.teams    : event_rec.teams
     team_ids   =  stage_rec ? stage_rec.team_ids : event_rec.team_ids

      ## todo/fix: check if all teams are unique
      ##   check if uniq works for club record (struct) - yes,no ??
      new_team_recs = Sync::Team.find_or_create( team_mapping.values.uniq )

     new_team_recs.each do |team_rec|
       ## add teams to event
       ##   for now check if team is alreay included
       ##   todo/fix: clear/destroy_all first - why? why not!!!
       team_recs << team_rec    unless team_ids.include?( team_rec.id )
     end


       ## build a lookup cache for team_recs  (used by group lookup)
       ##   lookup by "canonical" name
       cache_team_recs = new_team_recs.reduce({}) { |h,rec| h[rec.name] = rec; h }

      groups.each do |group|
        group_rec = Sync::Group.find_or_create( group, event: event_rec )   ## check: use/rename to EventGroup why? why not?

        ########
        ## add/update teams  - todo/fix/clean-up - find a better way or move to sync? - possible?
        ##   e.g. group.teams assumes an array of team names e.g.
        ##      ["Spain", "Czech Republic", "Turkey", "Croatia"]
        group_team_ids = []
        group.teams.each do |team_name|
          team_rec = cache_team_recs[ team_name ]
          if team_rec.nil? ## assume team MUST always be present/known in mapping (via autoconfig parser)
            puts "!! ERROR - no (cached) team rec found for team in group >#{group.name}< for >#{team_name}<"
            exit 1
          end
          group_team_ids << team_rec.id
        end
        group_rec.team_ids = group_team_ids   ## reset/update all teams at once (via ids)
      end


      rounds.each do |round|
        round_rec = Sync::Round.find_or_create( round, event: event_rec )  ## check: use/rename to EventRound why? why not?
      end

      matches.each do |match|
        ## note: pass along stage (if present): stage  - optional from heading!!!!
        match = match.update( stage: stage )   if stage
        match_rec = Sync::Match.create_or_update( match, event: event_rec )
      end
    end

    true   ## success/ok
  end # method parse


  ######################
  # (convenience) helpers

  def catalog() Import.catalog; end

end # class MatchReader
end # module SportDb
