# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parse_pt.rb


require 'helper'

class TestParsePt < MiniTest::Test

  def test_date
    data = [
      [ '29/03/2003 - Sábado',       '2003-03-29', '[PT_DD_MM_YYYY_DAY]' ],
      [ '29/3/2003 Sábado',          '2003-03-29', '[PT_DD_MM_YYYY_DAY]' ],
      [ '[29/3/2003 Sábado]',        '2003-03-29', '[[PT_DD_MM_YYYY_DAY]]' ],

      [ '09/04/2003 - Quarta-feira', '2003-04-09', '[PT_DD_MM_YYYY_DAY]' ],
      [ '9/4/2003 Quarta-feira',     '2003-04-09', '[PT_DD_MM_YYYY_DAY]' ],
      [ '[9/4/2003 Quarta-feira]',   '2003-04-09', '[[PT_DD_MM_YYYY_DAY]]' ],
    ]

    assert_dates( data, start: Date.new( 2003, 1, 1 ), lang: 'pt' )
  end

end # class TestParsePt
