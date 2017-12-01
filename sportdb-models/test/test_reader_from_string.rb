# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_reader_from_string.rb
#  or better
#     rake -I ./lib test


require 'helper'

class TestReaderFromString < MiniTest::Test

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

    eventreader  = TestEventReader.from_file( 'at-austria/2013_14/bl' )
    eventreader.read()

    bl = Event.find_by_key!( 'at.2013/14' )

    assert_equal  10, bl.teams.count
    assert_equal   0, bl.rounds.count
    assert_equal   0, bl.games.count  # 36x5 = 180


    bl_txt    = File.open( "#{SportDb.test_data_path}/at-austria/2013_14/bl.txt", 'r:bom|utf-8' ).read
    bl_txt_ii = File.open( "#{SportDb.test_data_path}/at-austria/2013_14/bl_ii.txt", 'r:bom|utf-8' ).read

    text_ary = [bl_txt,bl_txt_ii]

    gamereader = GameReader.from_string( bl, text_ary )
    gamereader.read()

    ## fix: add bl.key - allow event_keys too
    ## gamereader = GameReader.from_string( bl.key, text_ary )
    ## gamereader.read()


    assert_equal  36, bl.rounds.count
    assert_equal 180, bl.games.count  # 36x5 = 180

    ## check if is stable (update will not create new matches and rounds) on second pass/rerun
    gamereader.read()

    assert_equal  36, bl.rounds.count
    assert_equal 180, bl.games.count  # 36x5 = 180
  end


end # class TestReaderFromString
