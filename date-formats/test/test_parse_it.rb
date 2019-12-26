# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parse_it.rb


require 'helper'

class TestParseIt < MiniTest::Test

  def test_date
    data = [
      [ 'Sab. 24.8.',     '2019-08-24', '[IT_DAY_MM_DD]' ],
      [ 'Sab. 24.08.',    '2019-08-24', '[IT_DAY_MM_DD]' ],
      [ 'Sab 24.8.',      '2019-08-24', '[IT_DAY_MM_DD]' ],
      [ '[Sab. 24.8.]',   '2019-08-24', '[[IT_DAY_MM_DD]]' ],
    ]

    assert_dates( data, start: Date.new( 2019, 1, 1 ), lang: 'it' )
  end

end # class TestParseIt
