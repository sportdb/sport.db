###
#  sport.db gems / libraries
require 'fifa'
require 'sportdb/leagues'


###
# our own code
require 'footballdb/leagues/version' # let version always go first


module FootballDb
module Import

  def self.build_league_index
    recs = SportDb::Import::League.read( "#{FootballDb::Leagues.data_dir}/leagues.txt" )
    index = SportDb::Import::LeagueIndex.new
    index.add( recs )
    index
  end

end # module Import
end # module FootballDb


puts FootballDb::Leagues.banner   # say hello



