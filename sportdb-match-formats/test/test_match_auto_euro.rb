# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_match_auto_euro.rb


require 'helper'


class TestMatchAutoEuro < MiniTest::Test

  def test_euro_2016
    txt, exp = read_test( 'match_auto/euro_2016.txt')

    teams, rounds, groups, round_defs, group_defs = parse_auto_conf( txt, lang: 'en' )

     # puts JSON.pretty_generate( { teams: teams,
     #                             rounds: rounds,
     #                             groups: groups } )

     assert_equal exp['teams'],  teams.deep_stringify_keys
     assert_equal exp['rounds'], rounds.deep_stringify_keys
     assert_equal exp['groups'], groups.deep_stringify_keys

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
end   # class TestMatchAutoEuro
