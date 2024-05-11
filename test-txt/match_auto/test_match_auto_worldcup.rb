# encoding: utf-8

###
#  to run use
#     ruby -I . match_auto/test_match_auto_worldcup.rb


require 'helper'


class TestMatchAutoWorldCup < Minitest::Test

  def test_2018
    txt, exp = read_test( 'match_auto/worldcup_2018.txt')

    start = Date.new( 2018, 1, 1 )

    teams, rounds, groups, round_defs, group_defs = parse_auto_conf( txt, lang: 'en', start: start )

     # puts JSON.pretty_generate( { teams: teams,
     #                             rounds: rounds,
     #                             groups: groups } )

     assert_equal exp['teams'],  teams.deep_stringify_keys
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

  def test_2018_finals
    txt, exp = read_test( 'match_auto/worldcup_2018_finals.txt')

    start = Date.new( 2018, 1, 1 )

    teams, rounds, groups, round_defs, group_defs = parse_auto_conf( txt, lang: 'en', start: start )

     assert_equal exp['teams'],  teams.deep_stringify_keys
     assert_equal exp['rounds'], rounds.deep_stringify_keys

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

end   # class TestMatchAutoWorldCup
