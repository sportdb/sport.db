# encoding: utf-8


###
#  sport.db gems / libraries
require 'fifa'
require 'sportdb/clubs'


###
# our own code
require 'footballdb/clubs/version' # let version always go first


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




class Club    ## todo/check: use a module instead of class - why? why not?
  def self.clubs()      club_index.clubs; end   ## return all clubs (struct-like) records
  def self.all()   clubs; end  ## use ActiveRecord-like alias for clubs

  def self.mappings()   club_index.mappings; end

  def self.[]( name )   club_index[ name ]; end  ## lookup by canoncial name only
  def self.match( name ) club_index.match( name ); end
  def self.match_by( name:, country: ) club_index.match_by( name: name, country: country ); end


  def self.club_index
    @club_index ||= build_club_index
    @club_index
  end

private
  def self.build_club_index
    if defined?( SportDb::Import::Configuration )
       # assume running "inside" sportdb - (re)use sportdb configuration
    else
       # assume running "stand-alone" - setup configuration for countries / country mapping
       config = Configuration.new
       SportDb::Import::ClubReader.config = config
       SportDb::Import::ClubIndex.config  = config
       SportDb::Import::WikiReader.config = config
    end

    recs = SportDb::Import::ClubReader.read( "#{FootballDb::Clubs.data_dir}/clubs.txt" )
    club_index = SportDb::Import::ClubIndex.new
    club_index.add( recs )
    recs = SportDb::Import::WikiReader.read( "#{FootballDb::Clubs.data_dir}/clubs.wiki.txt" )
    club_index.add_wiki( recs )
    club_index
  end
end # class Club

end # module Import
end # module FootballDb



### add top-level (global) convenience alias
Club = FootballDb::Import::Club



puts FootballDb::Clubs.banner   # say hello
