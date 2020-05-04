# encoding: utf-8

module SportDb

class MatchReaderV2    ## todo/check: rename to MatchReaderV2 (use plural?) why? why not?

  def self.read( path, season: nil )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ).read
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
    recs = LeagueOutlineReader.parse( @txt, season: season )
    pp recs
    ## todo/fix: rename recs to  secs (sections) or to outlines or ???
    ##  do NOT use recs EVER!!!! use/reserve for ActiveRecord DB records

    recs.each do |rec|
      ## hack for now: switch lang
      ##
      ##  todo/fix: use rec[:league] and rec[:season] here (hold off dependency on ActiveRecord!!! )
      if rec[:league].intl?   ## todo/fix: add intl? to ActiveRecord league!!!
        Import.config.lang = 'en'
      else  ## assume national/domestic
        if ['de', 'at'].include?( rec[:league].country.key )
          Import.config.lang = 'de'
        elsif ['fr'].include?( rec[:league].country.key )
          Import.config.lang = 'fr'
        elsif ['it'].include?( rec[:league].country.key )
          Import.config.lang = 'it'
        elsif ['es', 'mx'].include?( rec[:league].country.key )
          Import.config.lang = 'es'
        elsif ['pt', 'br'].include?( rec[:league].country.key )
          Import.config.lang = 'pt'
        else
          Import.config.lang = 'en'
        end
      end

      ## todo/fix:
      ##    always auto create
      ##   1) check for teams count on event/stage - only if count == 0 use autoconf!!!
      ##   2) add lang switch for date/lang too!!!!

      season_rec = Import::Season.new( rec[:season ])
      start =      if season_rec.year?
                     Date.new( season_rec.start_year, 1, 1 )
                   else
                     Date.new( season_rec.start_year, 7, 1 )
                   end

      auto_conf_teams, _ = AutoConfParser.parse( rec[:lines],
                                                 start: start )

      ## step 1: map/find teams
      team_mapping = {}   ## name => team struct record

      ## note: loop over keys (holding the names); values hold the usage counter!! e.g. 'Arsenal' => 2, etc.
      if rec[:league].clubs?
        if rec[:league].intl?    ## todo/fix: add intl? to ActiveRecord league!!!

        ### quick hack mods for popular/known ambigious club names
        ##    todo/fix: make more generic / reuseable!!!!
        club_mods_by_league = {
         'uefa.cl' => build_club_mapping({ 'Liverpool | Liverpool FC'  => 'Liverpool FC, ENG',
                                            'Arsenal  | Arsenal FC'    => 'Arsenal FC, ENG',
                                            'Barcelona'                => 'FC Barcelona, ESP',
                                            'Valencia'                 => 'Valencia CF, ESP'  })
        }
        club_mods_by_league[ 'uefa.el' ] = club_mods_by_league[ 'uefa.cl' ]   ## europa league uses same mods as champions league

        club_mods = club_mods_by_league[ rec[:league].key ] || {}

        auto_conf_teams.keys.each do |name|
          club_rec = nil

          if club_mods[ name ]
            club_rec = club_mods[ name ]
          else
            ## todo/fix:  just use clubs.find!() - why? why not?
            m = catalog.clubs.match( name )
            if m.nil?
              puts "no match found for club >#{name}<; sorry - add to clubs repo"
              exit 1
            elsif m.size > 1
              puts "too many matches (#{m.size}) found for club >#{name}<; sorry - use unique key in >#{rec[:league].name}<:"
              pp m
              exit 1
            else  ## assume more than one match
              club_rec = m[0]
            end
          end

          team_mapping[ name ] = club_rec
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



      ## todo/fix: set lang for now depending on league country!!!
      parser = MatchParserSimpleV2.new( rec[:lines],
                                team_mapping,
                                start )   ## note: keep season start_at date for now (no need for more specific stage date need for now)

      match_recs, round_recs, group_recs = parser.parse

      pp round_recs
      pp group_recs

     ######################################################
     ## step 2: add to database

     event = Sync::Event.find_or_create_by( league: rec[:league],
                                            season: Import::Season.new(rec[:season]) )

     stage = if rec[:stage]
                Sync::Stage.find_or_create( rec[:stage], event: event )
             else
                 nil
             end

     teams     =  stage ? stage.teams    : event.teams
     team_ids  =  stage ? stage.team_ids : event.team_ids

      ## todo/fix: check if all teams are unique
      ##   check if uniq works for club record (struct) - yes,no ??
      new_teams = Sync::Team.find_or_create( team_mapping.values.uniq )

     new_teams.each do |team|
       ## add teams to event
       ##   for now check if team is alreay included
       ##   todo/fix: clear/destroy_all first - why? why not!!!
       teams << team    unless team_ids.include?( team.id )
     end


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

    true   ## success/ok
  end # method parse


  ######################
  # (convenience) helpers

  def catalog() Import.catalog; end

  def build_club_mapping( mapping )
    ## e.g.
    ##  { 'Arsenal   | Arsenal FC'    => 'Arsenal, ENG',
    ##    'Liverpool | Liverpool FC'  => 'Liverpool, ENG',
    ##    'Barcelona'                 => 'Barcelona, ESP',
    ##    'Valencia'                  => 'Valencia, ESP' }

    mapping.reduce({}) do |h,(club_names, club_line)|

      values = club_line.split( ',' )
      values = values.map { |value| value.strip }  ## strip all spaces

      ## todo/fix: make sure country is present !!!!
      club_name, country_name = values
      club = catalog.clubs.find_by!( name: club_name, country: country_name )

      values = club_names.split( '|' )
      values = values.map { |value| value.strip }  ## strip all spaces

      values.each do |club_name|
        h[club_name] = club
      end
      h
    end
  end

end # class MatchReaderV2
end # module SportDb
