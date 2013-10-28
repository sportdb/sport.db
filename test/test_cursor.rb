# encoding: utf-8

require 'helper'

class TestCursor < MiniTest::Unit::TestCase

  def test_games
    games = []
    
    games << SportDb::Models::Game.new( score1: 3, score2: 1, play_at: DateTime.new(2013, 8, 9) )
    games << SportDb::Models::Game.new( score1: 1, score2: 3, play_at: DateTime.new(2013, 8, 10) )
    games << SportDb::Models::Game.new( score1: 2, score2: 0, play_at: DateTime.new(2013, 8, 10) )
    games << SportDb::Models::Game.new( score1: 3, score2: 2, play_at: DateTime.new(2013, 8, 12) )  # new_week

    SportDb::Models::GameCursor.new( games ).each do |game,state|
      if state.index == 0
        assert_equal 3, game.score1
        assert_equal 1, game.score2
        assert_equal true, state.new_date?
        assert_equal true, state.new_year?
        assert_equal true, state.new_week?
      end

      if state.index == 1
        assert_equal 1, game.score1
        assert_equal 3, game.score2
        assert_equal true, state.new_date?
        assert_equal false, state.new_year?
        assert_equal false, state.new_week?
      end

      if state.index == 2
        assert_equal 2, game.score1
        assert_equal 0, game.score2
        assert_equal false, state.new_date?
        assert_equal false, state.new_year?
        assert_equal false, state.new_week?
      end

      if state.index == 3
        assert_equal 3, game.score1
        assert_equal 2, game.score2
        assert_equal true,  state.new_date?
        assert_equal true,  state.new_week?
        assert_equal false, state.new_year?
      end
    end
  end

end # class TestCursor
