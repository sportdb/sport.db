# encoding: utf-8

### our own sportdb libs / gems
require 'sportdb/countries'
require 'sportdb/leagues'
require 'sportdb/clubs'


### "built-in" default dataset libs / gems
require 'fifa'    ## get a list of all fifa countries with (three letter) codes
require 'footballdb/leagues'
require 'footballdb/clubs'


###
# our own code
require 'sportdb/config/version' # let version always go first
require 'sportdb/config/wiki_index'
require 'sportdb/config/national_team_index'

module SportDb
  module Import

# add builder convenience helper to ClubIndex - why? why not?
class ClubIndex

  def self.build( path )
    pack = Package.new( path )   ## lets us use direcotry or zip archive

    recs = []
    pack.each_clubs do |entry|
      recs += Club.parse( entry.read )
    end
    recs

    clubs = new
    clubs.add( recs )

    ## add wiki(pedia) anchored links
    recs = []
    pack.each_clubs_wiki do |entry|
       recs += WikiReader.parse( entry.read )
    end

    pp recs
    clubs.add_wiki( recs )
    clubs
  end
end # class ClubIndex


class LeagueIndex

  def self.build( path )
    pack = Package.new( path )   ## lets us use direcotry or zip archive

    recs = []
    pack.each_leagues do |entry|
      recs += League.parse( entry.read )
    end
    recs

    leagues = new
    leagues.add( recs )
    leagues
  end
end # class LeagueIndex

  end   # module Import
end   # module SportDb


require 'sportdb/config/catalog'
require 'sportdb/config/config'




puts SportDb::Boot.banner   # say hello
