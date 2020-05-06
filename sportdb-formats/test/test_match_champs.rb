# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_match_champs.rb


require 'helper'


class TestMatchChamps < MiniTest::Test

  def test_parse
    txt, exp, teams = read_test( 'match/champs_group.txt' )

    start = Date.new( 2017, 7, 1 )

    DateFormats.lang = 'en'
    SportDb.lang.lang = 'en'

    parser = SportDb::MatchParserSimpleV2.new( txt, teams, start )
    matches, rounds, groups  = parser.parse

    pp rounds
    pp groups
    pp matches[-1]     ## only dump last record for now
  end   # method test_parse
end   # class TestMatchChamps
