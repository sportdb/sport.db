###
#  to run use
#     ruby -I . match/test_match_start_date.rb


require 'helper'


class TestMatchStart < MiniTest::Test

  def test_date
    txt =<<TXT
Matchday 1
[Aug 2]
   A - B
Matchday 2
[Jan 3]
   A - B
Matchday 3
[Aug 4]
  A - B
TXT

   teams =<<TXT
A
B
TXT
    SportDb::Import.config.lang = 'en'

    start = Date.new( 2017, 7, 1 )

    parser = SportDb::MatchParser.new( txt, teams, start )
    matches, rounds  = parser.parse

    pp rounds
    pp matches

    assert_equal Date.new( 2017, 8, 2), matches[0].date
    assert_equal Date.new( 2018, 1, 3), matches[1].date
    assert_equal Date.new( 2018, 8, 4), matches[2].date
  end   # method test_date
end   # class TestMatchStart
