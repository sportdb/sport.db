# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parse_en.rb


require 'helper'

class TestParseEn < MiniTest::Test

  def test_date
    data = [
      [ 'Jun/12 2011 14:00', '2011-06-12 14:00', '[EN_MONTH_DD_YYYY_hh_mm]' ],
      [ 'Oct/12 2013 16:00', '2013-10-12 16:00', '[EN_MONTH_DD_YYYY_hh_mm]' ],

      [ 'Jan/26 2011',       '2011-01-26', '[EN_MONTH_DD_YYYY]' ],
      [ 'Jan/26',            '2013-01-26', '[EN_MONTH_DD]' ],
      [ '26 January',        '2013-01-26', '[EN_DD_MONTH]' ],

      [ 'Jun/13',            '2013-06-13', '[EN_MONTH_DD]' ],
      [ '13 June',           '2013-06-13', '[EN_DD_MONTH]' ],

      [ 'Fri Aug/9',         '2013-08-09',  '[EN_DAY_MONTH_DD]' ],
      [ '[Fri Aug/9]',       '2013-08-09',  '[[EN_DAY_MONTH_DD]]' ],
    ]

    assert_dates( data, start: Date.new( 2013, 1, 1 ), lang: 'en' )
  end
end # class TestParseEn
