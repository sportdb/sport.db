# encoding: utf-8

module SportDb

class Reader

  include LogUtils::Logging


## make models available in sportdb module by default with namespace
#  e.g. lets you use Team instead of Model::Team
  include SportDb::Models
  include SportDb::Matcher # lets us use match_teams_for_country etc.


  attr_reader :include_path

  def initialize( include_path, opts={})
    @include_path = include_path
  end

  def load_setup( name )
    path = "#{include_path}/#{name}.txt"

    logger.info "parsing data '#{name}' (#{path})..."

    reader = FixtureReader.new( path )

    reader.each do |fixture_name|
      load( fixture_name )
    end
  end # method load_setup


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

  def fix_fix_load_racing_fix_fix
=begin
    if name  =~ /^circuits/  # e.g. circuits.txt in formula1.db
      reader = TrackReader.new( include_path )
      reader.read( name )
    elsif match_tracks_for_country( name ) do |country_key|  # name =~ /^([a-z]{2})\/tracks/
            # auto-add country code (from folder structure) for country-specific tracks
            #  e.g. at/tracks  or at-austria/tracks
            country = Country.find_by_key!( country_key )
            reader = TrackReader.new( include_path )
            reader.read( name, country_id: country.id )
          end
    elsif name  =~ /^tracks/  # e.g. tracks.txt in ski.db
      reader = TrackReader.new( include_path )
      reader.read( name )
    elsif name =~ /^drivers/ # e.g. drivers.txt in formula1.db
      reader = PersonDb::PersonReader.new( include_path )
      reader.read( name )
    elsif match_skiers_for_country( name ) do |country_key|  # name =~ /^([a-z]{2})\/skiers/
            # auto-add country code (from folder structure) for country-specific skiers (persons)
            #  e.g. at/skiers  or at-austria/skiers.men
            country = Country.find_by_key!( country_key )
            reader = PersonDb::PersonReader.new( include_path )
            reader.read( name, country_id: country.id )
          end
    elsif name =~ /^skiers/ # e.g. skiers.men.txt in ski.db
      reader = PersonDb::PersonReader.new( include_path )
      reader.read( name )
    elsif name =~ /\/races/  # e.g. 2013/races.txt in formula1.db
      ## fix/bug:  NOT working for now; sorry
      #   need to read event first and pass along to read (event_id: event.id) etc.
      reader = RaceReader.new( include_path )
      reader.read( name )
    elsif name =~ /^teams/   # e.g. teams.txt in formula1.db   ### fix: check if used for football ? - add clubs
      reader = TeamReader.new( include_path )
      reader.read( name )
##  fix!!! - find a better unique pattern  to generic???
##
##    fix: use two routes/tracks/modes:
##
##    races w/ records etc   and  teams/matches etc.   split into two to make code easier to read/extend!!!
##
    elsif name =~ /\/([0-9]{2})-/
      race_pos = $1.to_i
      # NB: assume @event is set from previous load 
      race = Race.find_by_event_id_and_pos( @event.id, race_pos )
      reader = RecordReader.new( include_path )
      reader.read( name, race_id: race.id ) # e.g. 2013/04-gp-monaco.txt in formula1.db

    elsif name =~ /\/squads/ || name =~ /\/rosters/  # e.g. 2013/squads.txt in formula1.db
      reader = RaceTeamReader.new( include_path )
      reader.read( name )

=end
  end


  def load( name )   # convenience helper for all-in-one reader

    logger.debug "enter load( name=>>#{name}<<, include_path=>>#{include_path}<<)"


    if match_players_for_country( name ) do |country_key|
            country = Country.find_by_key!( country_key )
            reader = PersonDb::PersonReader.new( include_path )
            reader.read( name, country_id: country.id )
          end
    elsif name =~ /\/squads\/([a-z]{2,3})-[^\/]+$/
      ## fix: add to country matcher new format
      ##   name is country! and parent folder is type name e.g. /squads/br-brazil
      
      # note: if two letters, assume country key
      #       if three letters, assume team key
  
      ##   allow three letter codes
      ##  assume three letter code are *team* codes (e.g. fdr, gdr, etc)
      ##      not country code (allows multiple teams per country)

      if $1.length == 2
        country = Country.find_by_key!( $1 )
        ###  for now assume country code matches team for now (do NOT forget to downcase e.g. BRA==bra)
        logger.info "  assume country code == team code for #{country.code}"
        team = Team.find_by_key!( country.code.downcase )
      else  # assume length == 3
        team = Team.find_by_key!( $1 )
      end

      reader = SquadReader.new( include_path )
      ## note: pass in @event.id - that is, last seen event (e.g. parsed via GameReader/MatchReader)
      reader.read( name, team_id: team.id, event_id: @event.id )
    elsif name =~ /(?:^|\/)seasons/  # NB: ^seasons or also possible at-austria!/seasons
      reader = SeasonReader.new( include_path )
      reader.read( name )
    elsif name =~ /(?:^|\/)assocs/  # NB: ^assocs or also possible national-teams!/assocs
      reader = AssocReader.new( include_path )
      reader.read( name )
    elsif match_stadiums_for_country( name ) do |country_key|
            country = Country.find_by_key!( country_key )
            reader = GroundReader.new( include_path )
            reader.read( name, country_id: country.id )
          end
    elsif match_leagues_for_country( name ) do |country_key|  # name =~ /^([a-z]{2})\/leagues/
            # auto-add country code (from folder structure) for country-specific leagues
            #  e.g. at/leagues
            country = Country.find_by_key!( country_key )
            reader = LeagueReader.new( include_path )
            reader.read( name, club: true, country_id: country.id )
          end
    elsif name =~ /(?:^|\/)leagues/   # NB: ^leagues or also possible world!/leagues  - NB: make sure goes after leagues_for_country!!
      reader = LeagueReader.new( include_path )
      reader.read( name, club: is_club_fixture?( name ) )
    elsif match_teams_for_country( name ) do |country_key|   # name =~ /^([a-z]{2})\/teams/
            # auto-add country code (from folder structure) for country-specific teams
            #  e.g. at/teams at/teams.2 de/teams etc.                
            country = Country.find_by_key!( country_key )
            reader = TeamReader.new( include_path )
            reader.read( name, club: true, country_id: country.id )  ## fix: club flag - do NOT set - why? why not?
          end
    elsif match_clubs_for_country( name ) do |country_key|   # name =~ /^([a-z]{2})\/clubs/
            # auto-add country code (from folder structure) for country-specific clubs
            #  e.g. at/teams at/teams.2 de/teams etc.                
            country = Country.find_by_key!( country_key )
            reader = TeamReader.new( include_path )
            reader.read( name, club: true, country_id: country.id )  ## note: always sets club flag to true
          end
    elsif name =~ /(?:^|\/)teams/   ## fix: check if teams rule above (e.g. /^teams/ )conflicts/matches first ???
      reader = TeamReader.new( include_path )
      reader.read( name, club: is_club_fixture?( name ) )  ## fix: cleanup - use is_club_fixture? still needed w/ new clubs in name?
    elsif name =~ /(?:^|\/)clubs/
      reader = TeamReader.new( include_path )
      reader.read( name, club: true )   ## note: always sets club flag to true
    elsif name =~ /\/(\d{4}|\d{4}[_\-]\d{2})(--[^\/]+)?\// ||
          name =~ /\/(\d{4}|\d{4}[_\-]\d{2})$/

      # note: allow 2013_14 or 2013-14 (that, is dash or underscore)

      # note: keep a "public" reference of last event in @event  - e.g. used/required by squads etc.
      eventreader = EventReader.new( include_path )
      eventreader.read( name )
      @event    = eventreader.event

      # e.g. must match /2012/ or /2012_13/  or   /2012--xxx/ or /2012_13--xx/
      #  or   /2012 or /2012_13   e.g. brazil/2012 or brazil/2012_13
      reader = GameReader.new( include_path )
      reader.read( name )
    else
      logger.error "unknown sportdb fixture type >#{name}<"
      # todo/fix: exit w/ error
    end
  end # method load


end # class Reader
end # module SportDb
