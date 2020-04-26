# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_match_auto_mu.rb


require 'helper'


class TestMatchAutoMu < MiniTest::Test

  def test_mauritius
    txt, exp = read_test( 'match_auto/mu.txt' )

    teams, rounds = parse_auto_conf( txt )

    ## note: json always returns hash tables with string keys (not symbols),
    ##        thus, always stringify keys before comparing!!!!
    assert_equal exp['teams'],  teams.deep_stringify_keys
    assert_equal exp['rounds'], rounds.deep_stringify_keys

    # puts JSON.pretty_generate( { clubs:  clubs,
    #                             rounds: rounds
    #                           } )
    # exit 1
  end

end  # class TestMatchAutoMu
