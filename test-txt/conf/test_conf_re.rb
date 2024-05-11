###
#  to run use
#     ruby -I . conf/test_conf_re.rb


require 'helper'


class TestConfRe < Minitest::Test

  COUNTRY_RE = SportDb::ConfParser::COUNTRY_RE
  TABLE_RE   = SportDb::ConfParser::TABLE_RE

  def test_country
    m=COUNTRY_RE.match( 'Manchester United › ENG' )
    pp m
    pp m[0]
    assert_equal  'ENG', m[:country]

    m=COUNTRY_RE.match( 'Manchester United›ENG' )
    pp m
    pp m[0]
    assert_equal  'ENG', m[:country]
  end

  def test_table
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

end   # class TestConfRe
