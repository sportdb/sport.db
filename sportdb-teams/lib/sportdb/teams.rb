# encoding: utf-8


###
#  sport.db gems / libraries
require 'sportdb/countries'


###
# our own code
require 'sportdb/teams/version' # let version always go first
require 'sportdb/teams/club_reader'
require 'sportdb/teams/club_reader_props'
require 'sportdb/teams/club_index'
require 'sportdb/teams/wiki_reader'
require 'sportdb/teams/national_team_index'


###
# add convenience helpers / shortcuts
module SportDb
module Import
class Club
  def self.read( path )  ClubReader.read( path ); end
  def self.parse( txt )  ClubReader.parse( txt ); end

  def self.read_props( path )  ClubPropsReader.read( path ); end
  def self.parse_props( txt )  ClubPropsReader.parse( txt ); end
  ##  todo/check: use ClubProps.read and ClubProps.parse convenience alternate shortcuts - why? why not?
end # class Club
end   # module Import
end   # module SportDb





puts SportDb::Teams.banner   # say hello
