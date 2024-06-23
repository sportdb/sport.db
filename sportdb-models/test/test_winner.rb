###
#  to run use
#     ruby test/test_winner.rb


require_relative 'helper'


class TestWinner < Minitest::Test

  def test_1_2
    match = Match.new
    match.score1 = 1
    match.score2 = 2
    match.calc_winner

    assert_equal 2,     match.winner90
    assert_equal 2,     match.winner
    assert_equal true,  match.winner2?
    assert_equal false, match.winner1?
    assert_equal false, match.draw?
  end

  def test_1_1
    match = Match.new
    match.score1 = 1
    match.score2 = 1
    match.calc_winner

    assert_equal 0,     match.winner90
    assert_equal 0,     match.winner
    assert_equal true,  match.draw?
    assert_equal false, match.winner1?
    assert_equal false, match.winner2?
  end

  def test_2_1
    match = Match.new
    match.score1 = 2
    match.score2 = 1
    match.calc_winner

    assert_equal 1,     match.winner90
    assert_equal 1,     match.winner
    assert_equal true,  match.winner1?
    assert_equal false, match.winner2?
    assert_equal false, match.draw?
  end

  def test_1_1__2_1
    match = Match.new
    match.score1   = 1
    match.score2   = 1
    match.score1et = 2
    match.score2et = 1
    match.calc_winner

    assert_equal 0,     match.winner90
    assert_equal 1,     match.winner
    assert_equal true,  match.winner1?
    assert_equal false, match.winner2?
    assert_equal false, match.draw?
  end

  def test_1_1__2_2__3_5
    match = Match.new
    match.score1   = 1
    match.score2   = 1
    match.score1et = 2
    match.score2et = 2
    match.score1p  = 3
    match.score2p  = 5
    match.calc_winner

    assert_equal 0,     match.winner90
    assert_equal 2,     match.winner
    assert_equal true,  match.winner2?
    assert_equal false, match.winner1?
    assert_equal false, match.draw?
  end

  def test_1_1_x_3_5
    match = Match.new
    match.score1   = 1
    match.score2   = 1
    match.score1et = nil
    match.score2et = nil
    match.score1p  = 3
    match.score2p  = 5
    match.calc_winner

    assert_equal 0,     match.winner90
    assert_equal 2,     match.winner
    assert_equal true,  match.winner2?
    assert_equal false, match.winner1?
    assert_equal false, match.draw?
  end

end # class TestWinner
