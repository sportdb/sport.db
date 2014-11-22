# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_reader.rb
#  or better
#     rake -I ./lib test


require 'helper'

class TestReader < MiniTest::Test

  def setup
    WorldDb.delete!
    SportDb.delete!
    SportDb.read_builtin
  end

  def test_bl
    at = Country.create!( key: 'at', name: 'Austria', code: 'AUT', pop: 1, area: 1)
    
    teamreader = TeamReader.new( SportDb.test_data_path )
    teamreader.read( 'at-austria/teams',   country_id: at.id )

    leaguereader = LeagueReader.new( SportDb.test_data_path )
    leaguereader.read( 'at-austria/leagues', country_id: at.id )

    gamereader = GameReader.new( SportDb.test_data_path )
    ## check/fix: is country_id more_attribs needed? why? why not?
    gamereader.read( 'at-austria/2013_14/bl', country_id: at.id )

    bl = Event.find_by_key!( 'at.2013/14' )

    assert_equal  10, bl.teams.count
    assert_equal  36, bl.rounds.count
    assert_equal 180, bl.games.count  # 36x5 = 180
  end


  def test_game_reader
    at = Country.create!( key: 'at', name: 'Austria', code: 'AUT', pop: 1, area: 1)
    
    teamreader = TeamReader.new( SportDb.test_data_path )
    teamreader.read( 'at-austria/teams',   country_id: at.id )
    teamreader.read( 'at-austria/teams_2', country_id: at.id )

    austria = Team.find_by_key!( 'austria' )
    rapid   = Team.find_by_key!( 'rapid' )
    sturm   = Team.find_by_key!( 'sturm' )

    assert_equal 'FK Austria Wien', austria.title
    assert_equal 'SK Rapid Wien', rapid.title
    assert_equal 'SK Sturm Graz', sturm.title

    assert_equal 'AUS', austria.code
    assert_equal 'RAP', rapid.code
    assert_equal 'STU', sturm.code

    leaguereader = LeagueReader.new( SportDb.test_data_path )
    leaguereader.read( 'at-austria/leagues', country_id: at.id )

    at1   = League.find_by_key!( 'at' )
    at2   = League.find_by_key!( 'at.2' )
    atcup = League.find_by_key!( 'at.cup' )

    assert_equal 'Österr. Bundesliga', at1.title
    assert_equal 'Österr. Erste Liga', at2.title
    assert_equal 'ÖFB Cup', atcup.title

    gamereader = GameReader.new( SportDb.test_data_path )
    ## check/fix: is country_id more_attribs needed? why? why not?
    gamereader.read( 'at-austria/2013_14/bl', country_id: at.id )
    gamereader.read( 'at-austria/2013_14/el', country_id: at.id )

    bl = Event.find_by_key!( 'at.2013/14' )
    el = Event.find_by_key!( 'at.2.2013/14' )

    assert_equal  10, bl.teams.count
    assert_equal  36, bl.rounds.count
    assert_equal 180, bl.games.count  # 36x5 = 180

    assert_equal  10, el.teams.count
  end

end # class TestReader
