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


  def load( name )   # convenience helper for all-in-one reader

    logger.debug "enter load( name=>>#{name}<<, include_path=>>#{include_path}<<)"


    if match_players_for_country( name ) do |country_key|
            country = Country.find_by_key!( country_key )
            reader = PersonDb::PersonReader.new( include_path )
            reader.read( name, country_id: country.id )
          end
    elsif name =~ /\/squads\/([a-z0-9]{3,})$/    # e.g. ajax.txt bayern.txt etc.
      ## note: for now assume club (e.g. no dash (-) allowed for country code e.g. br-brazil etc.)
      team = Team.find_by_key!( $1 )
      ## note: pass in @event.id - that is, last seen event (e.g. parsed via GameReader/MatchReader)
      reader = ClubSquadReader.new( include_path )
      reader.read( name, team_id: team.id, event_id: @event.id )
    elsif name =~ /\/squads\/([a-z]{2,3})-[^\/]+$/
      ## fix: add to country matcher new format
      ##   name is country! and parent folder is type name e.g. /squads/br-brazil
      
      # note: if two letters, assume country key
      #       if three letters, assume team key
  
      ##   allow three letter codes
      ##  assume three letter code are *team* codes (e.g. fdr, gdr, etc)
      ##      not country code (allows multiple teams per country)

      if $1.length == 2
        ## get national team via country
        country = Country.find_by_key!( $1 )
        ###  for now assume country code matches team for now (do NOT forget to downcase e.g. BRA==bra)
        logger.info "  assume country code == team code for #{country.code}"
        team = Team.find_by_key!( country.code.downcase )
      else  # assume length == 3
        ## get national team directly (use three letter fifa code)
        team = Team.find_by_key!( $1 )
      end
      ## note: pass in @event.id - that is, last seen event (e.g. parsed via GameReader/MatchReader)
      reader = NationalTeamSquadReader.new( include_path )
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
      reader.read( name )
    elsif match_teams_for_country( name ) do |country_key|   # name =~ /^([a-z]{2})\/teams/
            # auto-add country code (from folder structure) for country-specific teams
            #  e.g. at/teams at/teams.2 de/teams etc.
            country = Country.find_by_key!( country_key )
            reader = TeamReader.new( include_path )
            reader.read( name, country_id: country.id )
          end
    elsif match_clubs_for_country( name ) do |country_key|   # name =~ /^([a-z]{2})\/clubs/
            # auto-add country code (from folder structure) for country-specific clubs
            #  e.g. at/teams at/teams.2 de/teams etc.                
            country = Country.find_by_key!( country_key )
            reader = TeamReader.new( include_path )
            reader.read( name, club: true, country_id: country.id )  ## note: always sets club flag to true
          end
    elsif name =~ /(?:^|\/)teams/   ## fix: check if teams rule above (e.g. /^teams/ )conflicts/matches first ???
      ### fix: use new NationalTeamReader ??? why? why not?
      reader = TeamReader.new( include_path )
      reader.read( name )  ## note: always sets club flag to true / national to true
    elsif name =~ /(?:^|\/)clubs/
      ### fix: use new ClubReader ??? why? why not?
      reader = TeamReader.new( include_path )
      reader.read( name, club: true )   ## note: always sets club flag to true / national to false
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
