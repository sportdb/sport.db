# encoding: UTF-8

module SportDb


class RaceReader

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


  ###
  ## fix: use read_fixtures( event_key, name )
  ##
  ## move EventReader out of read - why?? why not??

  def read( name, more_attribs={} )

    # must have .yml file with same name for event definition 
    evreader = EventReader.new( include_path )
    evreader.read( name )

    @event = evreader.event

    logger.info "  event: #{@event.key} >>#{@event.full_title}<<"

    path = "#{include_path}/#{name}.txt"

    logger.info "parsing data '#{name}' (#{path})..."
    
    ### SportDb.lang.lang = LangChecker.new.analyze( name, include_path )

    ## for now: use all tracks (later filter/scope by event)
    @known_tracks = Track.known_tracks_table

    reader = LineReader.new( path )
        
    read_races_worker( reader )

    Prop.create_from_fixture!( name, path )
  end


  def read_races_worker( reader )

    reader.each_line do |line|
      logger.debug "  line: >#{line}<"

      cut_off_end_of_line_comment!( line )

      pos = find_leading_pos!( line )

      map_track!( line )
      track_key = find_track!( line )
      track = Track.find_by_key!( track_key )

      date      = find_date!( line )

      logger.debug "  line2: >#{line}<"

      ### check if games exists
      race = Race.find_by_event_id_and_track_id( @event.id, track.id )

      if race.present?
        logger.debug "update race #{race.id}:"
      else
        logger.debug "create race:"
        race = Race.new
      end
          
      race_attribs = {
        pos:      pos,
        track_id: track.id,
        start_at:  date,
        event_id:  @event.id
      }

      logger.debug race_attribs.to_json

      race.update_attributes!( race_attribs )
    end # lines.each

  end # method read_races_worker


end # class RaceReader
end # module SportDb
