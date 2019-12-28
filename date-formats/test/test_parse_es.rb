# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parse_es.rb


require 'helper'

class TestParseEs < MiniTest::Test

  def test_date
    data = [
      [ '12 Ene',             '2019-01-12', '[ES_DD_MONTH]' ],
      [ '[12 Ene]',           '2019-01-12', '[[ES_DD_MONTH]]' ],

      [ 'Sáb. 17.8.',         '2019-08-17', '[ES_DAY_DD_MM]' ],
      [ 'Sáb. 17.08.',        '2019-08-17', '[ES_DAY_DD_MM]' ],
      [ 'Sáb 17.8.',          '2019-08-17', '[ES_DAY_DD_MM]' ],
      [ '[Sáb 17.8.]',        '2019-08-17', '[[ES_DAY_DD_MM]]' ],

      [ 'Sáb 5 Ene',          '2019-01-05', '[ES_DAY_DD_MONTH]'],
      [ 'Sáb. 05 Ene',        '2019-01-05', '[ES_DAY_DD_MONTH]'],
      [ '[Sáb 5 Ene]',        '2019-01-05', '[[ES_DAY_DD_MONTH]]'],

      [ 'Sáb 5 Ene 19:30',    '2019-01-05 19:30', '[ES_DAY_DD_MONTH_hh_mm]'],
      [ 'Sáb. 05 Ene 19:30',  '2019-01-05 19:30', '[ES_DAY_DD_MONTH_hh_mm]'],
      [ 'Sáb. 5 Ene 19h30',   '2019-01-05 19:30', '[ES_DAY_DD_MONTH_hh_mm]'],
    ]

    assert_dates( data, start: Date.new( 2019, 1, 1 ), lang: 'es' )
  end

end # class TestParseEs
