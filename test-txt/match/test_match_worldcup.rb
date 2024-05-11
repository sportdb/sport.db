###
#  to run use
#     ruby -I . match/test_match_worldcup.rb


require 'helper'


class TestMatchWorld < Minitest::Test

  def test_parse
    txt, exp, teams = read_test( 'match/worldcup_2018_finals.txt' )

    start = Date.new( 2018, 1, 1 )

    SportDb::Import.config.lang = 'en'

    parser = SportDb::MatchParser.new( txt, teams, start )
    matches, rounds, groups  = parser.parse

    pp rounds
    pp groups
    pp matches[-1]     ## only dump last record for now
  end   # method test_parse
end   # class TestMatchWorld
