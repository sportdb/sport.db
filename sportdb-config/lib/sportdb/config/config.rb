# encoding: utf-8


module SportDb
  module Import

# add builder convenience helper to ClubIndex - why? why not?
class ClubIndex

  def self.build( path )
    recs = []
    datafiles = Datafile.find_clubs( path )
    datafiles.each do |datafile|
      recs += Club.read( datafile )
    end
    recs

    clubs = new
    clubs.add( recs )

    ## add wiki(pedia) anchored links
    recs = []
    datafiles = Datafile.find_clubs_wiki( path )
    datafiles.each do |datafile|
       recs += WikiReader.read( datafile )
    end

    pp recs
    clubs.add_wiki( recs )
    clubs
  end
end # class ClubIndex


class LeagueIndex

  def self.build( path )
    recs = []
    datafiles = Datafile.find_leagues( path )
    datafiles.each do |datafile|
      recs += League.read( datafile )
    end
    recs

    leagues = new
    leagues.add( recs )
    leagues
  end
end # class LeagueIndex


class Configuration

  ##
  ##  todo: allow configure of countries_dir like clubs_dir
  ##         "fallback" and use a default built-in world/countries.txt

  ## todo/check:  rename to country_mappings/index - why? why not?
  ##    or countries_by_code or countries_by_key
  def countries
    @countries ||= build_country_index
    @countries
  end

  def build_country_index    ## todo/check: rename to setup_country_index or read_country_index - why? why not?
    CountryIndex.new( Fifa.countries )
  end



  def clubs
    @clubs  ||= build_club_index
    @clubs
  end

  def leagues
    @leagues ||= build_league_index
    @leagues
  end


  ####
  #  todo/fix:  find a better way to configure club / team datasets
  attr_accessor   :clubs_dir
  def clubs_dir()      @clubs_dir; end   ### note: return nil if NOT set on purpose for now - why? why not?

  attr_accessor   :leagues_dir
  def leagues_dir()    @leagues_dir; end



  def build_club_index
    ## unify team names; team (builtin/known/shared) name mappings
    ## cleanup team names - use local ("native") name with umlaut etc.
    ## todo/fix: add to teamreader
    ##              check that name and alt_names for a club are all unique (not duplicates)

    clubs = if clubs_dir   ## check if clubs_dir is defined / set (otherwise it's nil)
              ClubIndex.build( clubs_dir )
            else   ## no clubs_dir set - try using builtin from footballdb-clubs
              ## todo/fix:  use build_club_index make public (remove private)!!!!
              FootballDb::Import::Club.club_index
            end

    if clubs.errors?
      puts ""
      puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      puts " #{clubs.errors.size} errors:"
      pp clubs.errors
      ## exit 1
    end

    clubs
end # method build_club_index

def build_league_index
  leagues = if leagues_dir   ## check if clubs_dir is defined / set (otherwise it's nil)
              LeagueIndex.build( leagues_dir )
            else   ## no leagues_dir set - try using builtin from footballdb-leagues
              ## todo/fix:  use build_league_index make public (remove private)!!!!
              FootballDb::Import::League.league_index
            end
end


end # class Configuration


## lets you use
##   SportDb::Import.configure do |config|
##      config.hello = 'World'
##   end

def self.configure
  yield( config )
end

def self.config
  @config ||= Configuration.new
end

end   # module Import
end   # module SportDb
