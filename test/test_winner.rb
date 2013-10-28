# encoding: utf-8

require 'helper'

class TestWinner < MiniTest::Unit::TestCase

  def test_1_2
    game = SportDb::Models::Game.new
    game.score1 = 1
    game.score2 = 2
    game.calc_winner
    
    assert_equal 2,     game.winner90
    assert_equal 2,     game.winner
    assert_equal true,  game.winner2?
    assert_equal false, game.winner1?
    assert_equal false, game.draw?
  end

  def test_1_1
    game = SportDb::Models::Game.new
    game.score1 = 1
    game.score2 = 1
    game.calc_winner
    
    assert_equal 0,     game.winner90
    assert_equal 0,     game.winner
    assert_equal true,  game.draw?
    assert_equal false, game.winner1?
    assert_equal false, game.winner2?
  end

  def test_2_1
    game = SportDb::Models::Game.new
    game.score1 = 2
    game.score2 = 1
    game.calc_winner
    
    assert_equal 1,     game.winner90
    assert_equal 1,     game.winner
    assert_equal true,  game.winner1?
    assert_equal false, game.winner2?
    assert_equal false, game.draw?
  end

  def test_1_1__2_1
    game = SportDb::Models::Game.new
    game.score1   = 1
    game.score2   = 1
    game.score1et = 2
    game.score2et = 1
    game.calc_winner
    
    assert_equal 0,     game.winner90
    assert_equal 1,     game.winner
    assert_equal true,  game.winner1?
    assert_equal false, game.winner2?
    assert_equal false, game.draw?
  end

  def test_1_1__2_2__3_5
    game = SportDb::Models::Game.new
    game.score1   = 1
    game.score2   = 1
    game.score1et = 2
    game.score2et = 2
    game.score1p  = 3
    game.score2p  = 5
    game.calc_winner

    assert_equal 0,     game.winner90
    assert_equal 2,     game.winner
    assert_equal true,  game.winner2?
    assert_equal false, game.winner1?
    assert_equal false, game.draw?
  end

  def test_1_1_x_3_5
    game = SportDb::Models::Game.new
    game.score1   = 1
    game.score2   = 1
    game.score1et = nil
    game.score2et = nil
    game.score1p  = 3
    game.score2p  = 5
    game.calc_winner

    assert_equal 0,     game.winner90
    assert_equal 2,     game.winner
    assert_equal true,  game.winner2?
    assert_equal false, game.winner1?
    assert_equal false, game.draw?
  end

end # class TestWinner
