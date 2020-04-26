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



class NationalTeamIndex

  attr_reader :teams     ## all (national) team records

  def initialize( recs )
    @teams         = []
    @teams_by_code = {}
    @teams_by_name = {}

    add( recs )
  end

  include NameHelper
  ## incl. strip_year( name )
  ##       has_year?( name)
  ##       strip_lang( name )
  ##       normalize( name )


  def add( recs )
    ###########################################
    ## auto-fill national teams
    ## pp recs
    recs.each do |rec|
      @teams << rec

      ## add fifa code lookup
      if @teams_by_code[ rec.code.downcase ]
        puts "** !! ERROR !! national team code (code) >#{rec.code}< already exits!!"
        exit 1
      else
        @teams_by_code[ rec.code.downcase ] = rec
      end


      ##  add all names (canonical name + alt names
      names = [rec.name] + rec.alt_names
      more_names = []
      ## check "hand-typed" names for year (auto-add)
      ## check for year(s) e.g. (1887-1911), (-2013),
      ##                        (1946-2001,2013-) etc.
      names.each do |name|
        if has_year?( name )
          more_names <<  strip_year( name )
        end
      end

      names += more_names
      ## check for duplicates - simple check for now - fix/improve
      ## todo/fix: (auto)remove duplicates - why? why not?
      count      = names.size
      count_uniq = names.uniq.size
      if count != count_uniq
        puts "** !!! ERROR !!! - #{count-count_uniq} duplicate name(s) in national teams:"
        pp names
        pp rec
        exit 1
      end

      names.each_with_index do |name,i|
        ## check lang codes e.g. [en], [fr], etc.
        ##  todo/check/fix:  move strip_lang up in the chain - check for duplicates (e.g. only lang code marker different etc.) - why? why not?
        name = strip_lang( name )
        norm = normalize( name )
        old_rec = @teams_by_name[ norm ]
        if old_rec
          ## check if tame name already is included or is new team rec
            msg = "** !!! ERROR !!! - national team name conflict/duplicate - >#{name}< will overwrite >#{old_rec.name}< with >#{rec.name}<"
            puts msg
            exit 1
        else
          @teams_by_name[ norm ] = rec
        end
      end
    end  ## each record
  end # method initialize

  ##  fix/todo: add  find_by (alias for find_by_name/find_by_code)
  def find_by_code( code )
    code = code.to_s.downcase   ## allow symbols (and always downcase e.g. AUT to aut etc.)
    @teams_by_code[ code ]
  end

  def find_by_name( name )
    name = normalize( name.to_s )  ## allow symbols too (e.g. use to.s first)
    @teams_by_name[ name ]
  end

  def find( q )
    ## check longest match first (assume name is longer than code)
    ## try lookup / find by (normalized) name first
    team = find_by_name( q )
    team = find_by_code( q )  if team.nil?
    team
  end
end   # class NationalTeamIndex




class Configuration

  ##
  ##  todo: allow configure of countries_dir like clubs_dir
  ##         "fallback" and use a default built-in world/countries.txt

  ## todo/check:  rename to country_mappings/index - why? why not?
  ##    or countries_by_code or countries_by_key
  def countries()      @countries      ||= build_country_index; end
  def national_teams() @national_teams ||= build_national_team_index; end
  def clubs()          @clubs          ||= build_club_index; end
  def leagues()        @leagues        ||= build_league_index; end


  ####
  #  todo/check:  find a better way to configure club / team datasets - why? why not?
  attr_accessor   :clubs_dir
  def clubs_dir()      @clubs_dir; end   ### note: return nil if NOT set on purpose for now - why? why not?

  attr_accessor   :leagues_dir
  def leagues_dir()    @leagues_dir; end


  def build_country_index    ## todo/check: rename to setup_country_index or read_country_index - why? why not?
    CountryIndex.new( Fifa.countries )
  end

  def build_national_team_index
    ## auto-build national teams from Fifa.countries for now
    teams = []
    Fifa.countries.each do |country|
      team = NationalTeam.new( key:        country.key,
                               name:       country.name,
                               code:       country.fifa,    ## note: use fifa code
                               alt_names:  country.alt_names )
      teams << team
    end

    NationalTeamIndex.new( teams )
  end

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
