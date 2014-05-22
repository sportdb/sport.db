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

    # event
    @event = Event.find( more_attribs[:event_id] )
    pp @event

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
    
    ## note: use @team - share/use in worker method
    @team = Team.find_by_key!( country.code.downcase )
    pp @team

    ### SportDb.lang.lang = LangChecker.new.analyze( name, include_path )

    reader = LineReader.new( path )

    logger.info "  persons count for country: #{country.persons.count}"
    known_persons_old = TextUtils.build_title_table_for( country.persons )

    ### fix:  add auto camelcase/titlecase
    ## move to textutils
    ##  make it an option for name to auto Camelcase/titlecase?
    ##  e.g. BONFIM COSTA SANTOS    becomes
    ##       Bonfim Costa Santos  etc.
    ##  fix: better move into person parser?
    ##   store all alt_names titleized!!!!!

    @known_persons = []
    known_persons_old.each do |person_pair|
       key    = person_pair[0]
       values = person_pair[1].map { |value| titleize(value) }

       @known_persons << [ key, values ]
    end

    pp @known_persons


    read_worker( reader )

    Prop.create_from_fixture!( name, path )  
  end


  def titleize( str )
    ## fix: for now works only with ASCII only
    ##  words 2 letters and ups
    str.gsub(/\b[A-Z]{2,}\b/) { |match| match.capitalize }
  end


  def read_worker( reader )

    pos_counter = 999000   # pos counter for undefined players w/o pos

    reader.each_line do |line|
      logger.debug "  line: >#{line}<"

      cut_off_end_of_line_comment!( line )

      pos = find_leading_pos!( line )

      if pos.nil?
        pos_counter+=1       ## e.g. 999001,999002 etc.
        pos = pos_counter
      end

      # map_team!( line )
      # team_key = find_team!( line )
      # team = Team.find_by_key!( team_key )

      map_person!( line )
      person_key = find_person!( line )
      person = Person.find_by_key!( person_key )

      logger.debug "  line2: >#{line}<"

      ### check if roster record exists
      roster = Roster.find_by_event_id_and_team_id_and_person_id( @event.id, @team.id, person.id )

      if roster.present?
        logger.debug "update Roster #{roster.id}:"
      else
        logger.debug "create Roster:"
        roster = Roster.new
      end

      roster_attribs = {
        pos:       pos,
        person_id: person.id,
        team_id:   @team.id,
        event_id:  @event.id   # NB: reuse/fallthrough from races - make sure load_races goes first (to setup event)
      }

      logger.debug roster_attribs.to_json

      roster.update_attributes!( roster_attribs )
    end # lines.each

  end # method read_worker


end # class NationTeamReader
end # module SportDb
