# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_reader_from_string.rb
#  or better
#     rake -I ./lib test


require 'helper'

class TestReaderFromString < MiniTest::Unit::TestCase

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

    eventreader  = EventReader.new( SportDb.test_data_path )
    eventreader.read( 'at-austria/2013_14/bl' )

    bl = Event.find_by_key!( 'at.2013/14' )

    assert_equal  10, bl.teams.count
    assert_equal   0, bl.rounds.count
    assert_equal   0, bl.games.count  # 36x5 = 180


    bl_txt    = File.read( "#{SportDb.test_data_path}/at-austria/2013_14/bl.txt" )
    bl_txt_ii = File.read( "#{SportDb.test_data_path}/at-austria/2013_14/bl_ii.txt" )

    text_ary = [bl_txt,bl_txt_ii]

    ## try reading from string -- fix: /tmp is a placeholder/remove
    gamereader = GameReader.new( '/tmp' )
    gamereader.read_fixtures_from_string( bl.key, text_ary )

    assert_equal  36, bl.rounds.count
    assert_equal 180, bl.games.count  # 36x5 = 180
    
    ## check if is stable (update will not create new matches and rounds) on second pass/rerun
    gamereader.read_fixtures_from_string( bl.key, text_ary )

    assert_equal  36, bl.rounds.count
    assert_equal 180, bl.games.count  # 36x5 = 180
  end


end # class TestReaderFromString
