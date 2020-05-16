# encoding: UTF-8

#######
## note: uses SportDb namespace by design (not RacingDb) !!!
##


module SportDb


class RecordReader

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

    ### SportDb.lang.lang = LangChecker.new.analyze( name, include_path )

    reader = LineReader.new( path )

    ## for now: use all tracks (later filter/scope by event)
    # @known_tracks = Track.known_tracks_table

    ## fix: add @known_teams  - for now; use teams (not scoped by event)
    @known_teams   = TextUtils.build_title_table_for( Team.all )
    ## and for now use all persons
    @known_persons = TextUtils.build_title_table_for( Person.all )

    read_records_worker( reader, more_attribs )

    Prop.create_from_fixture!( name, path )
  end


  def read_records_worker( reader, more_attribs )

    reader.each_line do |line|
      logger.debug "  line: >#{line}<"

      cut_off_end_of_line_comment!( line )

      state = find_record_leading_state!( line )

      map_team!( line )
      team_key = find_team!( line )
      team = Team.find_by_key!( team_key )

      map_person!( line )
      person_key = find_person!( line )
      person = Person.find_by_key!( person_key )

      timeline = find_record_timeline!( line )

      laps  = find_record_laps!( line )
      
      comment = find_record_comment!( line )

      logger.debug "  line2: >#{line}<"

      record_attribs = {
        state:  state,
        ## team_id: team.id,   ## NB: not needed for db 
        person_id: person.id,
        timeline: timeline,
        comment: comment,
        laps: laps
      }

      record_attribs = record_attribs.merge( more_attribs )

      ### check if record exists
      record = Record.find_by_race_id_and_person_id( record_attribs[ :race_id ],
                                                     record_attribs[ :person_id ])

      if record.present?
        logger.debug "update Record #{record.id}:"
      else
        logger.debug "create Record:"
        record = Record.new
      end

      logger.debug record_attribs.to_json

      record.update_attributes!( record_attribs )

    end # lines.each

  end # method read_records_worker


end # class RecordReader
end # module SportDb
