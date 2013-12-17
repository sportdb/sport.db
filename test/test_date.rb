# encoding: utf-8

require 'helper'

class TestDate < MiniTest::Unit::TestCase

  def test_date
    assert_datetime DateTime.new( 2013, 1, 19, 22 ),     parse_date( '19.01.2013 22.00' )
    assert_datetime DateTime.new( 2013, 1, 21, 21, 30 ), parse_date( '21.01.2013 21.30' )

    assert_date     DateTime.new( 2013, 1, 26 ),         parse_date( '26.01.2013' )
  end

  def test_date_en
    start_at = DateTime.new( 2013, 1, 25 )

    assert_date     DateTime.new( 2013, 1, 26 ),         parse_date( 'Jan/26', start_at: start_at )
    assert_datetime DateTime.new( 2013, 1, 26, 12, 00 ), parse_date( 'Jan/26', start_at: start_at )

    assert_date     DateTime.new( 2013, 6, 13 ),         parse_date( 'Jun/13', start_at: start_at )
    assert_datetime DateTime.new( 2013, 6, 13, 12, 00 ), parse_date( 'Jun/13', start_at: start_at )
  end


private

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

  class Reader
    include LogUtils::Logging      # add logger
    include SportDb::FixtureHelpers
  end

  def parse_date( line, opts={} )
     # e.g. lets you pass in opts[:start_at] ???
     reader = Reader.new
     reader.find_date!( line, opts )
  end

end # class TestScores