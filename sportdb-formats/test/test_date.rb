# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_date.rb

require 'helper'

class TestDate < MiniTest::Test

  def test_date
    data = [
      [ '19.01.2013 22.00', '2013-01-19 22:00' ],
      [ '21.01.2013 21.30', '2013-01-21 21:30' ],
      [ '26.01.2013',       '2013-01-26' ],
      [ '[26.01.2013]',     '2013-01-26' ],
      [ '[21.1.]',          '2013-01-21 12:00' ]
    ]

    assert_dates( data, start_at: Date.new( 2013, 1, 1 ) )
  end

  def test_date_fr
    data = [
      [ '[Ven 08. Août]', '2014-08-08' ],
      [ 'Ven 08. Août',   '2014-08-08' ],
      [ 'Ven 8. Août',    '2014-08-08' ],
      [ '[Sam 9. Août]', '2014-08-09' ],
      [ '[Dim 10. Août]', '2014-08-10' ],
      [ '[Sam 31. Janv]', '2015-01-31' ],
      [ '[Sam 7. Févr]', '2015-02-07' ],
      [ '[Sam 31. Jan]', '2015-01-31' ],
      [ '[Sam 7. Fév]', '2015-02-07' ],
    ]

    assert_dates( data, start_at: Date.new( 2014, 8, 1 ) )
  end

  def test_date_en
    data = [
      [ 'Jun/12 2011 14:00', '2011-06-12 14:00' ],
      [ 'Oct/12 2013 16:00', '2013-10-12 16:00' ],

      [ 'Jan/26 2011',       '2011-01-26' ],
      [ 'Jan/26 2011',       '2011-01-26 12:00' ],

      [ 'Jan/26',            '2013-01-26' ],
      [ 'Jan/26',            '2013-01-26 12:00' ],
      [ '26 January',        '2013-01-26' ],
      [ '26 January',        '2013-01-26 12:00' ],

      [ 'Jun/13',            '2013-06-13' ],
      [ 'Jun/13',            '2013-06-13 12:00' ],
      [ '13 June',           '2013-06-13' ],
      [ '13 June',           '2013-06-13 12:00' ]
    ]

    assert_dates( data, start_at: Date.new( 2013, 1, 1 ) )
  end


private

  def assert_dates( data, opts )
    data.each do |rec|
      line = rec[0]
      str  = rec[1]
      if str.index( ':' )
        assert_datetime( DateTime.strptime( str, '%Y-%m-%d %H:%M' ), parse_date( line, opts ))
      else
        assert_date( DateTime.strptime( str, '%Y-%m-%d' ), parse_date( line, opts ))
      end
    end
  end

  ## todo: check if assert_datetime or assert_date exist already? what is the best practice to check dates ???
  def assert_date( exp, act )
    assert_equal exp.year,  act.year
    assert_equal exp.month, act.month
    assert_equal exp.day,   act.day
  end

  def assert_time( exp, act )
    assert_equal exp.hour, act.hour
    assert_equal exp.min,  act.min
  end

  def assert_datetime( exp, act )
    assert_date( exp, act )
    assert_time( exp, act )
  end


  def parse_date( line, opts={} )
     # e.g. lets you pass in opts[:start_at] ???
     finder = SportDb::DateFinder.new
     finder.find!( line, opts )
  end

end # class TestDate
