# encoding: utf-8


###
#  sport.db gems / libraries
require 'sportdb/countries'


###
# our own code
require 'sportdb/clubs/version' # let version always go first
require 'sportdb/clubs/club'
require 'sportdb/clubs/club_reader'
require 'sportdb/clubs/club_linter'
require 'sportdb/clubs/club_index'
require 'sportdb/clubs/wiki_reader'


###
# add convenience helpers / shortcuts
module SportDb
module Import
class Club
  def self.read( path )  ClubReader.read( path ); end
  def self.parse( txt )  ClubReader.parse( txt ); end
end # class Club

class ClubLinter
  def self.read( path )  ClubLintReader.read( path ); end
  def self.parse( txt )  ClubLintReader.parse( txt ); end
end # class ClubLinter

class ConfLinter
  def self.read( path )  ConfLintReader.read( path ); end
  def self.parse( txt )  ConfLintReader.parse( txt ); end
end # class ConfLinter

end   # module Import
end   # module SportDb





puts SportDb::Clubs.banner   # say hello
