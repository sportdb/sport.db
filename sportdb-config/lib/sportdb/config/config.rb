# encoding: utf-8

module SportDb
  module Import


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
    recs = read_csv( "#{SportDb::Boot.data_dir}/world/countries.txt" )
    CountryIndex.new( recs )
  end



  def clubs
    @clubs  ||= build_club_index
    @clubs
  end

  ####
  #  todo/fix:  find a better way to configure club / team datasets
  attr_accessor   :clubs_dir
  def clubs_dir()   @clubs_dir ||= './clubs'; end


  CLUBS_REGEX = %r{  (?:^|/)               # beginning (^) or beginning of path (/)
                       (?:[a-z]{1,3}\.)?   # optional country code/key e.g. eng.clubs.txt
                       clubs\.txt$
                   }x


  CLUBS_WIKI_REGEX = %r{  (?:^|/)               # beginning (^) or beginning of path (/)
                           (?:[a-z]{1,3}\.)?   # optional country code/key e.g. eng.clubs.wiki.txt
                          clubs\.wiki\.txt$
                       }x


  def self.find_datafiles( path, pattern )
     datafiles = []   ## note: [country, path] pairs for now

     ## check all txt files as candidates  (MUST include country code for now)
     candidates = Dir.glob( "#{path}/**/*.txt" )
     pp candidates
     candidates.each do |candidate|
       datafiles << candidate    if pattern.match( candidate )
     end

     pp datafiles
     datafiles
  end
  def self.find_datafiles_clubs( path )       find_datafiles( path, CLUBS_REGEX ); end
  def self.find_datafiles_clubs_wiki( path )  find_datafiles( path, CLUBS_WIKI_REGEX ); end


  def build_club_index
    ## unify team names; team (builtin/known/shared) name mappings
    ## cleanup team names - use local ("native") name with umlaut etc.
    ## todo/fix: add to teamreader
    ##              check that name and alt_names for a club are all unique (not duplicates)

    clubs = ClubIndex.build( clubs_dir )
    if clubs.errors?
      puts ""
      puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      puts " #{clubs.errors.size} errors:"
      pp clubs.errors
      ## exit 1
    end

    clubs
end # method build_club_index




def leagues
  read_leagues()      if @leagues.nil?
  @leagues
end

def read_leagues
    #####
    # add / read-in leagues config
    @leagues = LeagueConfig.new

    self  ## return self for chaining
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
