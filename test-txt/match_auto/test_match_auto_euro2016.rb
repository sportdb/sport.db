###
#  to run use
#     ruby match_auto/test_match_auto_euro2016.rb


require_relative '../helper'


class TestMatchAutoEuro2016 < Minitest::Test

  def test_euro_2016
    txt, exp = read_test( 'match_auto/euro_2016.txt')

    teams, rounds, groups, round_defs, group_defs,
    grounds  = parse_auto_conf( txt, lang: 'en' )

     # puts JSON.pretty_generate( { teams: teams,
     #                             rounds: rounds,
     #                             groups: groups } )

     assert_equal exp['teams'],  teams.deep_stringify_keys
     assert_equal exp['rounds'], rounds.deep_stringify_keys
     assert_equal exp['groups'], groups.deep_stringify_keys

    puts "#{teams.size} teams:"
    pp teams
    puts "rounds:"
    pp rounds
    puts "groups:"
    pp groups
    puts "round defs:"
    pp round_defs
    puts "#{group_defs.size} group defs:"
    pp group_defs
    puts "#{grounds.size} grounds (cities etc.):"
    pp grounds
  end
end   # class TestMatchAutoEuro2016
