# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_match.rb


require 'helper'


class TestMatchParser < MiniTest::Test

  def test_parse
    txt, exp, teams = read_test( 'match/eng.txt' )

    start = Date.new( 2017, 7, 1 )

    DateFormats.lang = 'en'
    SportDb.lang.lang = 'en'

    parser = SportDb::MatchParserSimpleV2.new( txt, teams, start )
    matches, rounds  = parser.parse

    pp rounds
    pp matches[-1]   ## only dump last record for now
  end   # method test_parse
end   # class TestMatchParser
