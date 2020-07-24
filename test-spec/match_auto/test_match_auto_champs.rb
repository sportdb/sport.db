# encoding: utf-8

###
#  to run use
#     ruby -I . match_auto/test_match_auto_champs.rb


require 'helper'


class TestMatchAutoChamps < MiniTest::Test

  def test_champs_group
    txt, exp = read_test( 'match_auto/champs_group.txt')

    teams, rounds, groups, round_defs, group_defs = parse_auto_conf( txt, lang: 'en' )

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

  def test_champs_finals
    txt, exp = read_test( 'match_auto/champs_finals.txt')

    teams, rounds = parse_auto_conf( txt, lang: 'en' )

    assert_equal exp['teams'],  teams.deep_stringify_keys
    assert_equal exp['rounds'], rounds.deep_stringify_keys

    pp teams
    pp rounds
  end
end   # class TestMatchAutChamps
