# encoding: utf-8

module SportDb

## todo: "old" classic reader - rename to FileReader ?? why? why not?

class Reader < ReaderBase

  attr_reader :include_path

  def initialize( include_path, opts={})
    @include_path = include_path
  end

  def create_fixture_reader( name )
    path = "#{@include_path}/#{name}.txt"

    logger.info "parsing data (setup) '#{name}' (#{path})..."

    FixtureReader.from_file( path )
  end  

  def create_club_squad_reader( name, more_attribs={} )
    real_name = name_to_real_name( name )
    path = "#{@include_path}/#{real_name}.txt"

    logger.info "parsing data (club squad) '#{name}' (#{path})..."
    ClubSquadReader.from_file( path, more_attribs )
  end

  def create_national_team_squad_reader( name, more_attribs={} )
    real_name = name_to_real_name( name )
    path = "#{@include_path}/#{real_name}.txt"

    logger.info "parsing data (national team squad) '#{name}' (#{path})..."
    NationalTeamSquadReader.from_file( path, more_attribs )
  end

  def create_season_reader( name )
    real_name = name_to_real_name( name )
    path = "#{@include_path}/#{real_name}.txt"

    logger.info "parsing data (season) '#{name}' (#{path})..."
    SeasonReader.from_file( path )
  end

  def create_assoc_reader( name )
    real_name = name_to_real_name( name )
    path = "#{@include_path}/#{real_name}.txt"

    logger.info "parsing data (assoc) '#{name}' (#{path})..."
    AssocReader.from_file( path )
  end

  def create_ground_reader( name, more_attribs={} )
    real_name = name_to_real_name( name )
    path = "#{@include_path}/#{real_name}.txt"

    logger.info "parsing data (ground) '#{name}' (#{path})..."
    GroundReader.from_file( path, more_attribs )
  end

  def create_league_reader( name, more_attribs={} )
    real_name = name_to_real_name( name )
    path = "#{@include_path}/#{real_name}.txt"

    logger.info "parsing data (league) '#{name}' (#{path})..."
    LeagueReader.from_file( path, more_attribs )
  end

  def create_team_reader( name, more_attribs={} )
    real_name = name_to_real_name( name )
    path = "#{@include_path}/#{real_name}.txt"

    logger.info "parsing data (team) '#{name}' (#{path})..."
    TeamReader.from_file( path, more_attribs )
  end

  def create_event_reader( name, more_attribs={} )
    real_name = name_to_real_name( name )
    path = "#{@include_path}/#{real_name}.yml"

    logger.info "parsing data (event) '#{name}' (#{path})..."
    EventReader.from_file( path, more_attribs )
  end

  def create_game_reader( name, more_attribs={} )
    real_name = name_to_real_name( name )
    path = "#{@include_path}/#{real_name}.txt"

    logger.info "parsing data (fixture) '#{name}' (#{path})..."
    GameReader.from_file( path, more_attribs )
  end



  def create_person_reader( name, more_attribs={} )
    ## fix-fix-fix: change to new format e.g. from_file, from_zip etc!!!
    ## reader = PersonDb::PersonReader.new( include_path )
    # reader.read( name, country_id: country.id )
  end

private

  def name_to_real_name( name )
    # map name to real_name path
    # name might include !/ for virtual path (gets cut off)
    # e.g. at-austria!/w-wien/beers becomse w-wien/beers
    pos = name.index( '!/')
    if pos.nil?
      name # not found; real path is the same as name
    else
      # cut off everything until !/ e.g.
      # at-austria!/w-wien/beers becomes
      # w-wien/beers
      name[ (pos+2)..-1 ]
    end
  end # method name_to_real_name


end # class Reader
end # module SportDb
