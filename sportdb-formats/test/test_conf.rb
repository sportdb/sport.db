# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_conf.rb


require 'helper'


class TestConf < MiniTest::Test

  COUNTRY_RE = SportDb::ConfParser::COUNTRY_RE
  TABLE_RE   = SportDb::ConfParser::TABLE_RE

  def test_re
    m=COUNTRY_RE.match( 'Manchester United › ENG' )
    pp m
    pp m[0]
    assert_equal  'ENG', m[:country]

    m=COUNTRY_RE.match( 'Manchester United›ENG' )
    pp m
    pp m[0]
    assert_equal  'ENG', m[:country]


    m=TABLE_RE.match( '1  Manchester City         38  32  4  2 106-27 100' )
    pp m
    assert_equal 'Manchester City', m[:team]

    m=TABLE_RE.match( '1.  Manchester City         38  32  4  2 106:27 100' )
    pp m
    assert_equal 'Manchester City', m[:team]

    m=TABLE_RE.match( '-  Manchester City         38  32  4  2 106 - 27 100' )
    pp m
    assert_equal 'Manchester City', m[:team]


    m=TABLE_RE.match( '1.  1. FC Mainz           38  32  4  2 106-27 100  [-7]' )
    pp m
    assert_equal '1. FC Mainz', m[:team]
  end


  def test_conf
    %w[conf/at_cup.txt
       conf/at_reg.txt
       conf/at_champs.txt
       conf/eng.txt
       conf/champs.txt
      ].each do |path|
         txt, exp = read_test( path )

         puts "testing conf #{path}..."
         teams = parse_conf( txt )

         ## note: json always returns hash tables with string keys (not symbols),
         ##        thus, always stringify keys before comparing!!!!
         assert_equal exp, teams.deep_stringify_keys
      end
  end

end   # class TestConf
