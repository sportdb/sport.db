# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_date.rb


require 'helper'

class TestDate < MiniTest::Test

  def test_date
    data = [
      [ '19.01.2013 22.00', '2013-01-19 22:00', '[DD_MM_YYYY_hh_mm]' ],
      [ '21.01.2013 21.30', '2013-01-21 21:30', '[DD_MM_YYYY_hh_mm]' ],
      [ '26.01.2013',       '2013-01-26',       '[DD_MM_YYYY]'       ],
      [ '[26.01.2013]',     '2013-01-26',       '[[DD_MM_YYYY]]'     ],
      [ '[21.1.]',          '2013-01-21',       '[[DD_MM]]'          ]
    ]

    assert_dates( data, start: Date.new( 2013, 1, 1 ) )
  end

  def test_date_fr
    data = [
      [ '[Ven 08. Août]', '2014-08-08', '[[FR_DAY_DD_MONTH]]' ],
      [ 'Ven 08. Août',   '2014-08-08', '[FR_DAY_DD_MONTH]' ],
      [ 'Ven 8. Août',    '2014-08-08', '[FR_DAY_DD_MONTH]' ],
      [ '[Sam 9. Août]',  '2014-08-09', '[[FR_DAY_DD_MONTH]]' ],
      [ '[Dim 10. Août]', '2014-08-10', '[[FR_DAY_DD_MONTH]]' ],
      [ '[Sam 31. Janv]', '2015-01-31', '[[FR_DAY_DD_MONTH]]' ],
      [ '[Sam 7. Févr]',  '2015-02-07', '[[FR_DAY_DD_MONTH]]' ],
      [ '[Sam 31. Jan]',  '2015-01-31', '[[FR_DAY_DD_MONTH]]' ],
      [ '[Sam 7. Fév]',   '2015-02-07', '[[FR_DAY_DD_MONTH]]' ],
    ]

    assert_dates( data, start: Date.new( 2014, 8, 1 ), lang: 'fr' )
  end

  def test_date_en
    data = [
      [ 'Jun/12 2011 14:00', '2011-06-12 14:00', '[EN_MONTH_DD_YYYY_hh_mm]' ],
      [ 'Oct/12 2013 16:00', '2013-10-12 16:00', '[EN_MONTH_DD_YYYY_hh_mm]' ],

      [ 'Jan/26 2011',       '2011-01-26', '[EN_MONTH_DD_YYYY]' ],
      [ 'Jan/26 2011',       '2011-01-26', '[EN_MONTH_DD_YYYY]' ],

      [ 'Jan/26',            '2013-01-26', '[EN_MONTH_DD]' ],
      [ 'Jan/26',            '2013-01-26', '[EN_MONTH_DD]' ],
      [ '26 January',        '2013-01-26', '[EN_DD_MONTH]' ],
      [ '26 January',        '2013-01-26', '[EN_DD_MONTH]' ],

      [ 'Jun/13',            '2013-06-13', '[EN_MONTH_DD]' ],
      [ 'Jun/13',            '2013-06-13', '[EN_MONTH_DD]' ],
      [ '13 June',           '2013-06-13', '[EN_DD_MONTH]' ],
      [ '13 June',           '2013-06-13', '[EN_DD_MONTH]' ]
    ]

    assert_dates( data, start: Date.new( 2013, 1, 1 ), lang: 'en' )
  end



private
  def assert_dates( data, start:, lang: 'en' )
    data.each do |rec|
      line         = rec[0]
      str          = rec[1]

      ## note: test / use parse and find!  -- parse MUST go first
      values = []
      values << DateFormats.parse( line, start: start, lang: lang )
      values << DateFormats.find!( line, start: start, lang: lang )

      tagged_line  = rec[2]  ## optinal tagged line
      if tagged_line      ## note: line gets tagged inplace!!! (no new string)
        assert_equal line, tagged_line
        puts "#{line} == #{tagged_line}"
      end

      values.each do |value|
        if str.index( ':' )
          assert_datetime( DateTime.strptime( str, '%Y-%m-%d %H:%M' ), value )
        else
          assert_date( Date.strptime( str, '%Y-%m-%d' ), value )
        end
      end
    end
  end


  ## todo: check if assert_datetime or assert_date exist already? what is the best practice to check dates ???
  def assert_date( exp, value )
    assert_equal exp.year,  value.year
    assert_equal exp.month, value.month
    assert_equal exp.day,   value.day
  end

  def assert_time( exp, value )
    assert_equal exp.hour, value.hour
    assert_equal exp.min,  value.min
  end

  def assert_datetime( exp, value )
    assert_date( exp, value )
    assert_time( exp, value )
  end
end # class TestDate
