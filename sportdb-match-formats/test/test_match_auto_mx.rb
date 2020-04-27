# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_match_auto_mx.rb


require 'helper'


class TestMatchAutoMx < MiniTest::Test

  def test_mx
    txt, exp = read_test( 'match_auto/es/mx.txt')

    teams, rounds = parse_auto_conf( txt, lang: 'es' )

    # puts JSON.pretty_generate( { teams: teams,
    #                              rounds: rounds } )

    assert_equal exp['teams'],  teams.deep_stringify_keys
    assert_equal exp['rounds'], rounds.deep_stringify_keys
  end
end   # class TestMatchAutoMx
