# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_league_reader.rb


require 'helper'

class TestClubReader < MiniTest::Test

  def test_parse_at
    recs = SportDb::Import::LeagueReader.parse( <<TXT )
==============================
= Austria
1       Bundesliga
         | AUT BL | Österreich Bundesliga
2       2. Liga
         | Österreich Zweite Liga

3.o     Regionalliga Ost
         | AUT RLO | Österreich Regionalliga Ost
3.m     Regionalliga Mitte
         | AUT RLM | Österreich Regionalliga Mitte
3.sbg   Regionalliga Salzburg
         | RL SBG
3.t     Regionalliga Tirol
         | RL TIR
TXT

    pp recs

    assert_equal 6, recs.size
    assert_equal '2. Liga',     recs[1].name
    assert_equal 'at.2',        recs[1].key
    assert_equal 'Austria',     recs[1].country.name
    assert_equal 'at',          recs[1].country.key
  end

  def test_parse_us
    recs = SportDb::Import::LeagueReader.parse( <<TXT )
=============================================
= United States
1       Major League Soccer
         | USA MLS | USA Major League Soccer
cup     US Open Cup
         | USA US Open Cup
TXT

    pp recs

    assert_equal 2, recs.size
    assert_equal 'Major League Soccer',  recs[0].name
    assert_equal 'us.1',                 recs[0].key
    assert_equal 'United States',        recs[0].country.name
    assert_equal 'us',                   recs[0].country.key

    assert_equal 'US Open Cup',          recs[1].name
    assert_equal 'us.cup',               recs[1].key
  end

end # class TestLeagueReader
