###
#  to run use
#     ruby  test/test_cursor.rb


require_relative 'helper'

class TestCursor < Minitest::Test

  def test_matches
    matches = []

    matches << Match.new( score1: 3, score2: 1, date: Date.new(2013, 8, 9) )
    matches << Match.new( score1: 1, score2: 3, date: Date.new(2013, 8, 10) )
    matches << Match.new( score1: 2, score2: 0, date: Date.new(2013, 8, 10) )
    matches << Match.new( score1: 3, score2: 2, date: Date.new(2013, 8, 12) )  # new_week

    MatchCursor.new( matches ).each do |match,state|
      if state.index == 0
        assert_equal 3, match.score1
        assert_equal 1, match.score2
        assert_equal true, state.new_date?
        assert_equal true, state.new_year?
        assert_equal true, state.new_week?
      end

      if state.index == 1
        assert_equal 1, match.score1
        assert_equal 3, match.score2
        assert_equal true, state.new_date?
        assert_equal false, state.new_year?
        assert_equal false, state.new_week?
      end

      if state.index == 2
        assert_equal 2, match.score1
        assert_equal 0, match.score2
        assert_equal false, state.new_date?
        assert_equal false, state.new_year?
        assert_equal false, state.new_week?
      end

      if state.index == 3
        assert_equal 3, match.score1
        assert_equal 2, match.score2
        assert_equal true,  state.new_date?
        assert_equal true,  state.new_week?
        assert_equal false, state.new_year?
      end
    end
  end

end # class TestCursor
