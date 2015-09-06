# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_rsssf_reader.rb


require 'helper'

class TestRsssfReader < MiniTest::Test

  def setup
    WorldDb.delete!
    SportDb.delete!
    SportDb.read_builtin
  end

  def xxx_test_bl_2016
    at = Country.create!( key: 'at', name: 'Austria', code: 'AUT', pop: 1, area: 1)

    teamreader = TestTeamReader.from_file( 'at-austria/teams', country_id: at.id )
    teamreader.read()
    teamreader = TestTeamReader.from_file( 'at-austria/teams_2', country_id: at.id )
    teamreader.read()

    leaguereader = TestLeagueReader.from_file( 'at-austria/leagues', country_id: at.id )
    leaguereader.read()

    eventreader = TestEventReader.from_file( 'at-austria/2015_16/1-bundesliga' )
    eventreader.read

    assert true   ## if we get here; assume everything ok

    text = File.read_utf8( "#{SportDb.test_data_path}/rsssf/at-2015-16--1-bundesliga.txt" )

    ## bl = Event.find_by_key!( 'at.2015/16' )

    r = SportDb::RsssfGameReader.from_string( 'at.2015/16', text )
    r.read

    ## assert_equal  10, bl.teams.count
    ## assert_equal  36, bl.rounds.count
    ## assert_equal 180, bl.games.count  # 36x5 = 180
  end

  def test_bl_2015
    at = Country.create!( key: 'at', name: 'Austria', code: 'AUT', pop: 1, area: 1)

    teamreader = TestTeamReader.from_file( 'at-austria/teams', country_id: at.id )
    teamreader.read()
    teamreader = TestTeamReader.from_file( 'at-austria/teams_2', country_id: at.id )
    teamreader.read()

    leaguereader = TestLeagueReader.from_file( 'at-austria/leagues', country_id: at.id )
    leaguereader.read()

    eventreader = TestEventReader.from_file( 'at-austria/2014_15/1-bundesliga' )
    eventreader.read

    assert true   ## if we get here; assume everything ok

    text = File.read_utf8( "#{SportDb.test_data_path}/rsssf/at-2014-15--1-bundesliga.txt" )

    ## bl = Event.find_by_key!( 'at.2014/15' )

    r = SportDb::RsssfGameReader.from_string( 'at.2014/15', text )
    r.read

    ## assert_equal  10, bl.teams.count
    ## assert_equal  36, bl.rounds.count
    ## assert_equal 180, bl.games.count  # 36x5 = 180
  end


end # class TestRsssfReader

