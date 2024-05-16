###
#  to run use
#     ruby match/test_match_euro.rb


require_relative '../helper'


class TestMatchEuro < Minitest::Test

  def test_parse
    txt, exp, teams = read_test( 'match/euro_2016.txt' )

    start = Date.new( 2016, 1, 1 )

    SportDb::Import.config.lang = 'en'

    parser = SportDb::MatchParser.new( txt, teams, start )
    matches, rounds, groups  = parser.parse

    pp rounds
    pp groups
    pp matches[0]     ## only dump first & last record for now
    pp matches[-1]   
  end   # method test_parse
end   # class TestMatchEuro
