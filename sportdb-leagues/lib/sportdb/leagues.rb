# encoding: utf-8


###
#  sport.db gems / libraries
require 'sportdb/countries'



###
# our own code
require 'sportdb/leagues/version' # let version always go first
require 'sportdb/leagues/league'
require 'sportdb/leagues/league_reader'
require 'sportdb/leagues/league_index'


##
## add convenience helper / short-cuts
module SportDb
module Import
class League
  def self.read( path ) LeagueReader.read( path ); end
  def self.parse( txt ) LeagueReader.parse( txt ); end
end   # class League
end   # module Import
end   # module SportDb





puts SportDb::Leagues.banner   # say hello
