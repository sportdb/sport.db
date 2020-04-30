###
#  sport.db gems / libraries
require 'fifa'
require 'sportdb/teams'


###
# our own code
require 'footballdb/clubs/version' # let version always go first


module FootballDb
  module Import

  def self.build_club_index
    recs = SportDb::Import::Club.read( "#{FootballDb::Clubs.data_dir}/clubs.txt" )
    club_index = SportDb::Import::ClubIndex.new
    club_index.add( recs )
    recs = SportDb::Import::WikiReader.read( "#{FootballDb::Clubs.data_dir}/clubs.wiki.txt" )
    club_index.add_wiki( recs )
    club_index
  end

  end # module Import
end # module FootballDb


puts FootballDb::Clubs.banner   # say hello

