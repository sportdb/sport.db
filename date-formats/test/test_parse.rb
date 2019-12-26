# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parse.rb


require 'helper'

class TestParse < MiniTest::Test

  def test_date
    data = [
      [ '19.01.2013 22.00', '2013-01-19 22:00', '[DD_MM_YYYY_hh_mm]' ],
      [ '19.01.2013 22h00', '2013-01-19 22:00', '[DD_MM_YYYY_hh_mm]' ],
      [ '19.01.2013 22:00', '2013-01-19 22:00', '[DD_MM_YYYY_hh_mm]' ],
      [ '21.01.2013 21.30', '2013-01-21 21:30', '[DD_MM_YYYY_hh_mm]' ],
      [ '21.01.2013 21:30', '2013-01-21 21:30', '[DD_MM_YYYY_hh_mm]' ],
      [ '21.01.2013 21H30', '2013-01-21 21:30', '[DD_MM_YYYY_hh_mm]' ],

      [ '26.01.2013',       '2013-01-26',       '[DD_MM_YYYY]'       ],
      [ '[26.01.2013]',     '2013-01-26',       '[[DD_MM_YYYY]]'     ],
      [ '[21.1.]',          '2013-01-21',       '[[DD_MM]]'          ]
    ]

    assert_dates( data, start: Date.new( 2013, 1, 1 ) )
  end
end # class TestParse
