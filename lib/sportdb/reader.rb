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
    
    ## depcrecated - for now check if "new" format exsits
    ##  - if not fall back to old format
    unless File.exists?( path )
      puts "  deprecated manifest/setup format [SportDb.Reader]; use new plain text format"
      ## try old yml format
      path = "#{include_path}/#{name}.yml"
    end

    logger.info "parsing data '#{name}' (#{path})..."

    reader = FixtureReader.new( path )

    reader.each do |fixture_name|
      load( fixture_name )
    end
  end # method load_setup


  def load( name )   # convenience helper for all-in-one reader

    logger.debug "enter load( name=>>#{name}<<, include_path=>>#{include_path}<<)"

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
      reader = TeamReader.new( include_path )
      reader.read( name )
    elsif name =~ /\/races/  # e.g. 2013/races.txt in formula1.db
      reader = RaceReader.new( include_path )
      reader.read( name )
    elsif name =~ /\/squads/ || name =~ /\/rosters/  # e.g. 2013/squads.txt in formula1.db
      reader = RosterReader.new( include_path )
      reader.read( name )
    elsif name =~ /\/([0-9]{2})-/
      race_pos = $1.to_i
      # NB: assume @event is set from previous load 
      race = Race.find_by_event_id_and_pos( @event.id, race_pos )
      reader = RecordReader.new( include_path )
      reader.read( name, race_id: race.id ) # e.g. 2013/04-gp-monaco.txt in formula1.db
    elsif name =~ /(?:^|\/)seasons/  # NB: ^seasons or also possible at-austria!/seasons
      reader = SeasonReader.new( include_path )
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
      if name =~ /-cup!?\//          ||   # NB: -cup/ or -cup!/
         name =~ /copa-america!?\//       # NB: copa-america/ or copa-america!/
        # e.g. national team tournaments/leagues (e.g. world-cup/ or euro-cup/)
        reader = LeagueReader.new( include_path )
        reader.read( name, club: false )
      else
        # e.g. leagues_club
        reader = LeagueReader.new( include_path )
        reader.read( name, club: true )
      end
    elsif match_teams_for_country( name ) do |country_key|   # name =~ /^([a-z]{2})\/teams/
            # auto-add country code (from folder structure) for country-specific teams
            #  e.g. at/teams at/teams.2 de/teams etc.                
            country = Country.find_by_key!( country_key )
            reader = TeamReader.new( include_path )
            reader.read( name, club: true, country_id: country.id )
          end
    elsif name =~ /(?:^|\/)teams/
      if name =~ /-cup!?\//         ||    # NB: -cup/ or -cup!/
         name =~ /copa-america!?\//       # NB: copa-america/ or copa-america!/
        # assume national teams
        # e.g. world-cup/teams  amercia-cup/teams_northern
        reader = TeamReader.new( include_path )
        reader.read( name, club: false )
      else
        # club teams (many countries)
        # e.g. club/europe/teams
        reader = TeamReader.new( include_path )
        reader.read( name, club: true )
      end
    elsif name =~ /\/(\d{4}|\d{4}_\d{2})\// || name =~ /\/(\d{4}|\d{4}_\d{2})$/
      # e.g. must match /2012/ or /2012_13/
      #  or   /2012 or /2012_13   e.g. brazil/2012 or brazil/2012_13
      reader = GameReader.new( include_path )
      reader.read( name )
    else
      logger.error "unknown sportdb fixture type >#{name}<"
      # todo/fix: exit w/ error
    end
  end # method load


  ####
  ## fix: move to persondb for (re)use

  def load_persons( name, more_attribs={} )

    reader = ValuesReaderV2.new( name, include_path, more_attribs )

    reader.each_line do |new_attributes, values|
      Person.create_or_update_from_values( new_attributes, values )
    end # each lines

  end # load_persons

  
end # class Reader
end # module SportDb
