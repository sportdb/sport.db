# encoding: utf-8

###
#  to run use
#     ruby -I . match/test_match_eng.rb


require 'helper'


class TestMatchEng < MiniTest::Test

  def test_eng
    txt, exp, teams = read_test( 'match/eng.txt' )

    SportDb::Import.config.lang = 'en'

    start = Date.new( 2017, 7, 1 )

    parser = SportDb::MatchParser.new( txt, teams, start )
    matches, rounds  = parser.parse

    pp rounds
    pp matches[-1]   ## only dump last record for now
  end   # method test_end
end   # class TestMatchEng
