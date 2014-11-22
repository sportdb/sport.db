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

    ClubSquadReader.from_file( path, more_attribs )
  end

  def create_national_team_squad_reader( name, more_attribs={} )

    NationalTeamSquadReader.from_file( path, more_attribs )
  end

  def create_season_reader( name )

    SeasonReader.from_file( path )
  end



  def create_person_reader( name, more_attribs={} )
    ## fix-fix-fix: change to new format e.g. from_file, from_zip etc!!!
    ## reader = PersonDb::PersonReader.new( include_path )
    # reader.read( name, country_id: country.id )
  end


end # class Reader

end # module SportDb
