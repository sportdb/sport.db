# encoding: UTF-8

module SportDb


### squad/roster reader for races
class RaceTeamReader

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
    ## todo: move name_real_path code to LineReaderV2 ????
    pos = name.index( '!/')
    if pos.nil?
      name_real_path = name   # not found; real path is the same as name
    else
      # cut off everything until !/ e.g.
      #   at-austria!/w-wien/beers becomes
      #   w-wien/beers
      name_real_path = name[ (pos+2)..-1 ]
    end

    path = "#{include_path}/#{name_real_path}.txt"

    logger.info "parsing data '#{name}' (#{path})..."
    ### SportDb.lang.lang = LangChecker.new.analyze( name, include_path )

    reader = LineReader.new( path )

    ## for now: use all tracks (later filter/scope by event)
    # @known_tracks = Track.known_tracks_table

    ## fix: add @known_teams  - for now; use teams (not scoped by event)
    ## for now use all teams
    @known_teams   = TextUtils.build_title_table_for( Team.all )
    ## and for now use all persons
    @known_persons = TextUtils.build_title_table_for( Person.all )


    read_worker( reader )

    Prop.create_from_fixture!( name, path )  
  end


  def read_worker( reader )

    reader.each_line do |line|
      logger.debug "  line: >#{line}<"

      cut_off_end_of_line_comment!( line )

      pos = find_leading_pos!( line )

      map_team!( line )
      team_key = find_team!( line )
      team = Team.find_by_key!( team_key )

      map_person!( line )
      person_key = find_person!( line )
      person = Person.find_by_key!( person_key )

      logger.debug "  line2: >#{line}<"

      ### check if roster record exists
      roster = Roster.find_by_event_id_and_team_id_and_person_id( @event.id, team.id, person.id )

      if roster.present?
        logger.debug "update Roster #{roster.id}:"
      else
        logger.debug "create Roster:"
        roster = Roster.new
      end

      roster_attribs = {
        pos:       pos,
        team_id:   team.id,
        person_id: person.id,
        event_id:  @event.id   # NB: reuse/fallthrough from races - make sure load_races goes first (to setup event)
      }

      logger.debug roster_attribs.to_json

      roster.update_attributes!( roster_attribs )
    end # lines.each

  end # method read_worker


end # class RaceTeamReader
end # module SportDb
