# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_csv_reader.rb


require 'helper'

class TestCsvReader < MiniTest::Test

  def setup
    WorldDb.delete!
    SportDb.delete!
    SportDb.read_builtin
  end

  def test_bl_2014
    de = Country.create!( key: 'de', name: 'Deutschland', code: 'GER', pop: 1, area: 1 )

    teamreader = TestTeamReader.from_file( 'de-deutschland/teams', country_id: de.id )
    teamreader.read()

    leaguereader = TestLeagueReader.from_file( 'de-deutschland/leagues', country_id: de.id )
    leaguereader.read()

    eventreader = TestEventReader.from_file( 'de-deutschland/2013-14/1-bundesliga' )
    eventreader.read

    assert true   ## if we get here; assume everything ok

    text = File.read_utf8( "#{SportDb.test_data_path}/csv/de-2013-14--1-bundesliga.txt" )

    ## bl = Event.find_by_key!( 'de.2013/14' )

    r = SportDb::CsvGameReader.from_string( 'de.2013/14', text )
    r.read

    ## assert_equal  10, bl.teams.count
    ## assert_equal  36, bl.rounds.count
    ## assert_equal 180, bl.games.count  # 36x5 = 180
  end

end # class TestCsvReader

