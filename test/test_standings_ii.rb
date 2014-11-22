# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_standings_ii.rb
#  or better
#     rake -I ./lib test


require 'helper'

class TestStandingsII < MiniTest::Test

  def setup
    WorldDb.delete!
    SportDb.delete!
    SportDb.read_builtin
  end

  def test_bl
    at = Country.create!( key: 'at', name: 'Austria', code: 'AUT', pop: 1, area: 1)
    
    teamreader = TestTeamReader.from_file( 'at-austria/teams', country_id: at.id )
    teamreader.read()

    leaguereader = TestLeagueReader.from_file( 'at-austria/leagues', country_id: at.id )
    leaguereader.read()

    ## check/fix: is country_id more_attribs needed? why? why not?
    gamereader = TestGameReader.from_file( 'at-austria/2013_14/bl', country_id: at.id )
    gamereader.read()

    bl = Event.find_by_key!( 'at.2013/14' )

    assert_equal  10, bl.teams.count
    assert_equal  36, bl.rounds.count
    assert_equal 180, bl.games.count  # 36x5 = 180

    standings = SportDb::Standings.new
    standings.update( bl.games )
    
    pp standings.to_a
  end


end # class TestStandingsII
