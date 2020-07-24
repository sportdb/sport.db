###
#  to run use
#     ruby -I . match/test_match_champs.rb


require 'helper'


class TestMatchChamps < MiniTest::Test

  def test_parse
    txt, exp, teams = read_test( 'match/champs_group.txt' )

    start = Date.new( 2017, 7, 1 )

    SportDb::Import.config.lang = 'en'

    parser = SportDb::MatchParser.new( txt, teams, start )
    matches, rounds, groups  = parser.parse

    pp rounds
    pp groups
    pp matches[-1]     ## only dump last record for now
  end   # method test_parse
end   # class TestMatchChamps
