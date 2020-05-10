# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_league_outline_reader.rb


require 'helper'


class TestLeagueOutlineReader < MiniTest::Test

  def test_parse
txt = <<TXT
= ENG PL 2019/20

line
line

= ENG CS 2019/20

line
line

= ENG PL 2020/1

line
line
TXT

    secs = SportDb::LeagueOutlineReader.parse( txt )
    pp secs

    assert_equal 3, secs.size

    league = secs[0][:league]
    assert_equal 'English Premier League', league.name
    assert_equal 'eng.1',                  league.key
    assert_equal 'England',                league.country.name
    assert_equal 'eng',                    league.country.key

    season = secs[0][:season]
    assert_equal '2019/20',                season.key

    ## try with season filter
    secs = SportDb::LeagueOutlineReader.parse( txt, season: '2020/21' )
    pp secs

    assert_equal 1, secs.size

    season = secs[0][:season]
    assert_equal '2020/21',                season.key
  end

end # class TestLeagueOutlineReader
