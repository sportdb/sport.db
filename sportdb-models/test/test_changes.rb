###
#  to run use
#     ruby test/test_changes.rb

require_relative  'helper'


class TestChanges < Minitest::Test

  def test_score
    match1 = Match.new
    match1.score1 = 1
    match1.score2 = 2

    match2 = Match.new
    match2.score1   = 1
    match2.score2   = 1
    match2.score1p  = 5
    match2.score2p  = 3

    match_attribs = {
      score1: 1,
      score2: 2,
      score1et: nil,
      score2et: nil,
      score1p:  nil,
      score2p:  nil
    }

    assert_equal  false, match1.check_for_changes( match_attribs )
    assert_equal  true,  match2.check_for_changes( match_attribs )
  end

  def test_date
    match1 = Match.new
    match1.score1 = 1
    match1.score2 = 2
    match1.date   = Date.new( 2012, 11, 5 )

    match2 = Match.new
    match2.score1   = 1
    match2.score2   = 2
    match2.date     = DateTime.new( 2012, 12, 24 )

    match_attribs = {
      score1:  1,
      score2:  2,
      date: DateTime.new( 2012, 11, 5 )
    }

    assert_equal  false, match1.check_for_changes( match_attribs )
    assert_equal  true,  match2.check_for_changes( match_attribs )
  end

  def test_group_id
    match1 = Match.new
    match1.score1 = 1
    match1.score2 = 2
    match1.group_id = 1

    match2 = Match.new
    match2.score1   = 1
    match2.score2   = 2
    match2.group_id = 2

    match_attribs = {
      score1:  1,
      score2:  2,
      group_id: 1
    }

    assert_equal  false, match1.check_for_changes( match_attribs )
    assert_equal  true,  match2.check_for_changes( match_attribs )
  end


end # class TestChanges
