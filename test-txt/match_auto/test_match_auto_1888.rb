###
#  to run use
#     ruby -I . match_auto/test_match_auto_1888.rb


require 'helper'



###
# test match schedule WITHOUT rounds
#   use the English Football League 1888/9 example and others


class TestMatchAuto1888 < MiniTest::Test

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

    teams, rounds, groups, round_defs, group_defs = parse_auto_conf( txt, lang: 'en' )

    puts "teams:"
    pp teams
    puts "rounds:"
    pp rounds
    puts "groups:"
    pp groups
    puts "round defs:"
    pp round_defs
    puts "group defs:"
    pp group_defs
  end

end   # class TestMatchAuto1888
