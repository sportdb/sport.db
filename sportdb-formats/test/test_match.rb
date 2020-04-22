# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_match.rb


require 'helper'

class TestMatch < MiniTest::Test

  Match = SportDb::Import::Match


  def test_round
    m = Match.new( team1: 'Team 1',
                   team2: 'Team 2',
                   round: 3 )
    pp m
    assert_equal 3, m.round
    assert_nil      m.score1
    assert_nil      m.score2

    m = Match.new
    m.update( round: 4 )
    pp m
    assert_equal 4, m.round
  end  # method test_round

end # class TestMatch
