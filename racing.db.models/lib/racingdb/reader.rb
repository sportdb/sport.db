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
    else
      logger.error "unknown sportdb fixture type >#{name}<"
      # todo/fix: exit w/ error
    end
  end # method load


end # class Reader
end # module SportDb

