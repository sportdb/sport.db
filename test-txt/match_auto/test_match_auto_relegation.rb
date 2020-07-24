# encoding: utf-8

###
#  to run use
#     ruby -I . match_auto/test_match_auto_relegation.rb


require 'helper'


class TestMatchAutoRelegation < MiniTest::Test

  def test_rel
    txt = <<TXT
Hinspiel
[31.5.]
  SC Wiener Neustadt     0-2  SKN St. Pölten

Rückspiel
[3.6.]
  SKN St. Pölten         1-1  SC Wiener Neustadt
TXT

    start =  Date.new( 2017, 7, 1 )
    SportDb::Import.config.lang = 'de'

    teams, rounds, groups, round_defs, group_defs = SportDb::AutoConfParser.parse( txt, start: start )

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

end   # class TestMatchAutoRelegation
