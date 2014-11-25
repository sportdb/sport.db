# encoding: utf-8

module SportDb


class ZipReader < ReaderBase

  def initialize( name, include_path, opts = {} )

    ## todo/fix: make include_path an opts (included in opts?) - why? why not??

    path = "#{include_path}/#{name}.zip"
    ## todo: check if zip exists

    @zip_file = Zip::File.open( path )   ## NOTE: do NOT create if file is missing; let it crash
    
    ### allow prefix (path) in name
    ###    e.g. assume all files relative to setup manifest
    ## e.g. at-austria-master/setups/all.txt or
    ##      be-belgium-master/setups/all.txt
    ##  for
    ##    setups/all.txt
    ###
    ##  will get (re)set w/ fixture/setup reader
    ##
    ## todo/fix: change/rename to @relative_path ?? - why? why not? 
    @zip_prefix = ''
  end

  def close
    ## todo/check: add a close method - why? why not ???
    @zip_file.close
  end


  def create_fixture_reader( name )
    ## e.g. pass in =>  setups/all  or setups/test etc.  e.g. w/o .txt extension
    query = "**/#{name}.txt"

    ## note: returns an array of Zip::Entry
    candidates = @zip_file.glob( query )
    pp candidates

    ## use first candidates entry as match
    ## todo/fix: issue warning if more than one entries/matches!!

    ## get fullpath e.g. at-austria-master/setups/all.txt
    path = candidates[0].name
    logger.debug "  zip entry path >>#{path}<<"

    ## cut-off at-austria-master/    NOTE: includes trailing slash (if present)
    ## logger.debug "  path.size #{path.size} >>#{path}<<"
    ## logger.debug "  name.size #{name.size+4} >>#{name}<<"

    ## note: add +4 for extension (.txt)
    @zip_prefix = path[ 0...(path.size-(name.size+4)) ]
    logger.debug "  zip entry prefix >>#{@zip_prefix}<<"

    logger.info "parsing data in zip '#{name}' (#{path})..."

    FixtureReader.from_zip( @zip_file, path )
  end

  def create_club_squad_reader( name, more_attribs={} )
    path = name_to_zip_entry_path( name )

    logger.info "parsing data in zip (club squad) '#{name}' (#{path})..."
    ClubSquadReader.from_zip( @zip_file, path, more_attribs )
  end

  def create_national_team_squad_reader( name, more_attribs={} )
    path = name_to_zip_entry_path( name )

    logger.info "parsing data in zip (national team squad) '#{name}' (#{path})..."
    NationalTeamSquadReader.from_zip( @zip_file, path, more_attribs )
  end

  def create_season_reader( name )
    path = name_to_zip_entry_path( name )

    logger.info "parsing data in zip (season) '#{name}' (#{path})..."
    SeasonReader.from_zip( @zip_file, path )
  end

  def create_assoc_reader( name )
    path = name_to_zip_entry_path( name )

    logger.info "parsing data in zip (assoc) '#{name}' (#{path})..."
    AssocReader.from_zip( @zip_file, path )
  end

  def create_ground_reader( name, more_attribs={} )
    path = name_to_zip_entry_path( name )

    logger.info "parsing data in zip (ground) '#{name}' (#{path})..."
    GroundReader.from_zip( @zip_file, path, more_attribs )
  end

  def create_league_reader( name, more_attribs={} )
    path = name_to_zip_entry_path( name )

    logger.info "parsing data in zip (league) '#{name}' (#{path})..."
    LeagueReader.from_zip( @zip_file, path, more_attribs )
  end

  def create_team_reader( name, more_attribs={} )
    path = name_to_zip_entry_path( name )

    logger.info "parsing data in zip (team) '#{name}' (#{path})..."
    TeamReader.from_zip( @zip_file, path, more_attribs )
  end

  def create_event_reader( name, more_attribs={} )
    path = name_to_zip_entry_path( name, '.yml' )   ## NOTE: use .yml extension

    logger.info "parsing data in zip (event) '#{name}' (#{path})..."
    EventReader.from_zip( @zip_file, path, more_attribs )
  end

  def create_game_reader( name, more_attribs={} )
    ## NOTE: pass in .yml as path (that is, event config!!!!)
    path = name_to_zip_entry_path( name, '.yml' )     ## NOTE: use .yml extension
    
    logger.info "parsing data in zip (fixture) '#{name}' (#{path})..."
    GameReader.from_zip( @zip_file, path, more_attribs )
  end


  def create_person_reader( name, more_attribs={} )
    ## fix-fix-fix: change to new format e.g. from_file, from_zip etc!!!
    ## reader = PersonDb::PersonReader.new( include_path )
    # reader.read( name, country_id: country.id )
  end

private

  def path_to_real_path( path )
    # map name to name_real_path
    # name might include !/ for virtual path (gets cut off)
    # e.g. at-austria!/w-wien/beers becomse w-wien/beers
    pos = path.index( '!/')
    if pos.nil?
      path # not found; real path is the same as name
    else
      # cut off everything until !/ e.g.
      # at-austria!/w-wien/beers becomes
      # w-wien/beers
      path[ (pos+2)..-1 ]
    end
  end

  def name_to_zip_entry_path( name, extension='.txt' )
    path = "#{name}#{extension}"

    real_path = path_to_real_path( path )

    # NOTE: add possible zip entry prefix path
    #          (if present includes trailing slash e.g. /)
    entry_path = "#{@zip_prefix}#{real_path}"
    entry_path
  end

end # class ZipReader

end # module SportDb
