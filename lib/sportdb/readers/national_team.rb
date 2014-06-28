# encoding: UTF-8

### fix: change/rename file to squads.rb !!!


module SportDb

### squad/roster reader for national teams

## todo: rename to SquadsNationalTeamReader or similar ?? why? why not?


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
    @known_persons = TextUtils.build_title_table_for( country.persons )


    read_worker( reader )

    Prop.create_from_fixture!( name, path )  
  end


  def read_worker( reader )
    ##
    ## fix: use num (optional) for offical jersey number
    #  use pos for internal use only (ordering)

    pos_counter = 999000   # pos counter for undefined players w/o pos

    reader.each_line do |line|
      logger.debug "  line: >#{line}<"

      cut_off_end_of_line_comment!( line )

      pos = find_leading_pos!( line )

      if pos.nil?
        pos_counter+=1       ## e.g. 999001,999002 etc.
        pos = pos_counter
      end

      #####
      #  - for now do NOT map team
      # map_team!( line )
      # team_key = find_team!( line )
      # team = Team.find_by_key!( team_key )

      map_person!( line )
      person_key = find_person!( line )

      logger.debug "  line2: >#{line}<"

      if person_key.nil?
        ## no person match found; try auto-add person
        logger.info "  !! no player match found; try auto-create player"

        buf = line.clone
        # remove (single match) if line starts w/ - (allow spaces)  e.g. | - or |-  note: must start line e.g. anchor ^ used
        buf = buf.sub( /^[ ]*-[ ]*/, '' )
        buf = buf.gsub( /\[[^\]]+\]/, '' )         # remove [POS] or similar
        buf = buf.gsub( /\b(GK|DF|MF|FW)\b/, '' )   # remove position marker - use sub (just single marker?)
        buf = buf.strip   # remove leading and trailing spaces

        ## assume what's left is player name
        logger.info "   player_name >#{buf}<"

        ## fix: add auto flag (for auto-created persons/players)
        ## fix: move title_to_key logic to person model etc.
        person_attribs = {
               key:   TextUtils.title_to_key( buf ),
               title: buf
        }
        logger.info "   using attribs: #{person_attribs.inspect}"

        person = Person.create!( person_attribs )
      else
        person = Person.find_by_key( person_key )

        if person.nil?
          logger.error " !!!!!! no mapping found for player in line >#{line}< for team #{@team.code} - #{@team.title}"
          next   ## skip further processing of line; can NOT save w/o person; continue w/ next record
        end
      end


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
