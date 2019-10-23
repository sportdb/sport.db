# encoding: utf-8


###
#  sport.db gems / libraries
require 'fifa'
require 'sportdb/leagues'


###
# our own code
require 'footballdb/leagues/version' # let version always go first


module FootballDb
module Import

## add "fake" configuration for stand-alone usage
class Configuration
  def initialize
    recs       = Fifa.countries
    @countries = SportDb::Import::CountryIndex.new( recs )
  end

  def countries() @countries; end
end




class League    ## todo/check: use a module instead of class - why? why not?
  def self.leagues()    league_index.leagues; end     ## return all leagues (struct-like) records
  def self.all()        leagues; end  ## use ActiveRecord-like alias for leagues

  def self.mappings()   league_index.mappings; end

  def self.match( name )               league_index.match( name ); end
  def self.match_by( name:, country: ) league_index.match_by( name: name, country: country ); end


  def self.league_index
    @league_index ||= build_league_index
    @league_index
  end

private
  def self.build_league_index
    if defined?( SportDb::Import::Configuration )
       # assume running "inside" sportdb - (re)use sportdb configuration
    else
       # assume running "stand-alone" - setup configuration for countries / country mapping
       config = Configuration.new
       SportDb::Import::LeagueReader.config = config
       SportDb::Import::LeagueIndex.config  = config
    end

    recs = SportDb::Import::LeagueReader.read( "#{FootballDb::Leagues.data_dir}/leagues.txt" )
    league_index = SportDb::Import::LeagueIndex.new
    league_index.add( recs )
    league_index
  end
end # class League

end # module Import
end # module FootballDb



### add top-level (global) convenience alias
League = FootballDb::Import::League



puts FootballDb::Leagues.banner   # say hello
