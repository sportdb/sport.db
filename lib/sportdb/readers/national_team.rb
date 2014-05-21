# encoding: UTF-8

module SportDb


### squad/roster reader for national teams
class NationalTeamReader

  include LogUtils::Logging

## make models available by default with namespace
#  e.g. lets you use Usage instead of Model::Usage
  include Models

## value helpers e.g. is_year?, is_taglist? etc.
  include TextUtils::ValueHelper

  include FixtureHelpers


  attr_reader :include_path


  def initialize( include_path, opts = {} )
    @include_path = include_path
  end


  def read( name, more_attribs={} )
    path = "#{include_path}/#{name}.txt"

    logger.info "parsing data '#{name}' (#{path})..."

    ## check/fix:
    ##   allow three letter codes
    ##  assume three letter code are *team* codes (e.g. fdr, gdr, etc)
    ##      not country code (allows multiple teams per country)

    ### check for country_id
    ##  fix: check for country_key  - allow (convert to country_id)

    country = Country.find( more_attribs[:country_id] )
    logger.info "  find national team squad/lineup for #{country.name}"

    ## todo/fix: find national team for country - use event.teams w/ where country.id ??
    ###  for now assume country code matches team for now (do NOT forget to downcase e.g. BRA==bra)
    logger.info "  assume country code == team code for #{country.code}"
    team = Team.find_by_key!( country.code.downcase )
    pp team

    ### SportDb.lang.lang = LangChecker.new.analyze( name, include_path )

    reader = LineReader.new( path )

    logger.info "  persons count for country: #{country.persons.count}"
    @known_persons = TextUtils.build_title_table_for( country.persons )

    read_worker( reader )

    Prop.create_from_fixture!( name, path )  
  end


  def read_worker( reader )

    reader.each_line do |line|
      logger.debug "  line: >#{line}<"

      cut_off_end_of_line_comment!( line )

      pos = find_leading_pos!( line )

      # map_team!( line )
      # team_key = find_team!( line )
      # team = Team.find_by_key!( team_key )

      map_person!( line )
      person_key = find_person!( line )
      person = Person.find_by_key!( person_key )

      logger.debug "  line2: >#{line}<"
    end # lines.each

  end # method read_worker


end # class NationTeamReader
end # module SportDb
