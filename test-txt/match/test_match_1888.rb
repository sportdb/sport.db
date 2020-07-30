###
#  to run use
#     ruby -I . match/test_match_1888.rb


###
# test match schedule WITHOUT rounds
#   use the English Football League 1888/9 example and others


require 'helper'


class TestMatch1888 < MiniTest::Test

  def test_eng_1888
    txt =<<TXT
[Sat Sep/8]
  Bolton Wanderers FC         3-6  Derby County FC
  Wolverhampton Wanderers FC  1-1  Aston Villa FC
  Preston North End FC        5-2  Burnley FC
  Everton FC                  2-1  Accrington FC
  Stoke FC                    0-2  West Bromwich Albion FC

[Sat Sep/15]
  Derby County FC             1-2  West Bromwich Albion FC
  Everton FC                  2-1  Notts County FC
  Blackburn Rovers FC         5-5  Accrington FC
  Wolverhampton Wanderers FC  0-4  Preston North End FC
  Bolton Wanderers FC         3-4  Burnley FC
  Aston Villa FC             5-1  Stoke FC
TXT


    teams =<<TXT
Bolton Wanderers FC
Derby County FC
Wolverhampton Wanderers FC
Aston Villa FC
Preston North End FC
Burnley FC
Everton FC
Accrington FC
Stoke FC
West Bromwich Albion FC
Notts County FC
Blackburn Rovers FC
TXT

    start = Date.new( 1888, 7, 1 )

    SportDb::Import.config.lang = 'en'

    parser = SportDb::MatchParser.new( txt, teams, start )
    matches, rounds, groups  = parser.parse

    pp rounds
    pp groups
    pp matches[-1]     ## only dump last record for now
  end
end   # class TestMatch1888
