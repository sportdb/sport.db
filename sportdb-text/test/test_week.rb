# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_week.rb


require 'helper'

class TestWeek < MiniTest::Test

  def test_2016_17
    assert_equal 51, Date.parse( '2016-12-25').cweek  # Sun Dec 25
    assert_equal 52, Date.parse( '2016-12-26').cweek  # Mon Dec 26
    assert_equal 52, Date.parse( '2016-12-31').cweek  # Sat Dec 31

    assert_equal 52, Date.parse( '2017-01-01').cweek  # Sun Jan 1
    assert_equal  1, Date.parse( '2017-01-02').cweek  # Mon Jan 2
    assert_equal  1, Date.parse( '2017-01-03').cweek  # Tue Jan 3
    assert_equal  1, Date.parse( '2017-01-08').cweek  # Sun Jan 8
    assert_equal  2, Date.parse( '2017-01-09').cweek  # Mon Jan 9
  end

  def test_2017_18
    assert_equal 51, Date.parse( '2017-12-24').cweek  # Sun Dec 24
    assert_equal 52, Date.parse( '2017-12-25').cweek  # Mon Dec 25
    assert_equal 52, Date.parse( '2017-12-31').cweek  # Sun Dec 31

    assert_equal  1, Date.parse( '2018-01-01').cweek  # Mon Jan 1
    assert_equal  1, Date.parse( '2018-01-02').cweek  # Tue Jan 2
    assert_equal  1, Date.parse( '2018-01-07').cweek  # Sun Jan 7
    assert_equal  2, Date.parse( '2018-01-09').cweek  # Mon Jan 8
  end

  def test_2018_19
    assert_equal 52, Date.parse( '2018-12-29').cweek  # Sat Dec 29
    assert_equal 52, Date.parse( '2018-12-30').cweek  # Sun Dec 30
    assert_equal  1, Date.parse( '2018-12-31').cweek  # Mon Dec 31

    assert_equal  1, Date.parse( '2019-01-01').cweek  # Tue Jan 1
    assert_equal  1, Date.parse( '2019-01-02').cweek  # Wed Jan 2
    assert_equal  1, Date.parse( '2019-01-06').cweek  # Sun Jan 6
    assert_equal  2, Date.parse( '2019-01-07').cweek  # Mon Jan 7
  end

  def test_2019_20
    assert_equal 52, Date.parse( '2019-12-29').cweek
    assert_equal  1, Date.parse( '2019-12-30').cweek

    assert_equal  1, Date.parse( '2020-01-01').cweek
    assert_equal  1, Date.parse( '2020-01-05').cweek
    assert_equal  2, Date.parse( '2020-01-06').cweek
  end

  def test_2020_21    ## note: 2020 has 53 (!) weeks
    assert_equal 52, Date.parse( '2020-12-27').cweek
    assert_equal 53, Date.parse( '2020-12-28').cweek  # 1/7-Mon
    assert_equal 53, Date.parse( '2020-12-29').cweek  # 2/7-Tue
    assert_equal 53, Date.parse( '2020-12-30').cweek  # 3/7-Wed
    assert_equal 53, Date.parse( '2020-12-31').cweek  # 4/7-Thu

    assert_equal 53, Date.parse( '2021-01-01').cweek  # 5/7-Fri
    assert_equal 53, Date.parse( '2021-01-02').cweek  # 6/7-Sat
    assert_equal 53, Date.parse( '2021-01-03').cweek  # 7/7-Sun
    assert_equal  1, Date.parse( '2021-01-04').cweek
    assert_equal  1, Date.parse( '2021-01-10').cweek
    assert_equal  2, Date.parse( '2021-01-11').cweek
  end


  def test_more_weeks
    assert_equal 53, Date.parse('2004-12-31').cweek ## note: 2004 has 53(!) weeks
    assert_equal 53, Date.parse('2005-01-01').cweek
    assert_equal 53, Date.parse('2005-01-02').cweek
    assert_equal  1, Date.parse('2005-01-03').cweek

    assert_equal 52, Date.parse('2005-12-31').cweek
    assert_equal 52, Date.parse('2006-01-01').cweek
    assert_equal  1, Date.parse('2006-01-02').cweek

    assert_equal 52, Date.parse('2006-12-31').cweek
    assert_equal  1, Date.parse('2007-01-01').cweek

    assert_equal 52, Date.parse('2007-12-30').cweek
    assert_equal  1, Date.parse('2007-12-31').cweek
    assert_equal  1, Date.parse('2008-01-01').cweek

    assert_equal 52, Date.parse('2008-12-28').cweek
    assert_equal  1, Date.parse('2008-12-29').cweek
    assert_equal  1, Date.parse('2008-12-30').cweek
    assert_equal  1, Date.parse('2008-12-31').cweek
    assert_equal  1, Date.parse('2009-01-01').cweek

    assert_equal 53, Date.parse('2009-12-31').cweek  ## note: 2009 has 53(!) weeks
    assert_equal 53, Date.parse('2010-01-01').cweek
    assert_equal 53, Date.parse('2010-01-02').cweek
    assert_equal 53, Date.parse('2010-01-03').cweek
    assert_equal  1, Date.parse('2010-01-04').cweek



    assert_equal 52, Date.parse('2012-01-01').cweek
    assert_equal  1, Date.parse('2012-12-31').cweek
    assert_equal  1, Date.parse('2014-12-29').cweek
    assert_equal 53, Date.parse('2015-12-31').cweek ## note: 2015 has 53(!) weeks
  end


  def test_today
    assert_equal 31, Date.parse('2018-07-30').cweek  # Mon Jul 30
    assert_equal 31, Date.parse('2018-08-01').cweek
    assert_equal 31, Date.parse('2018-08-05').cweek  # Sun Aug 5
  end
end # class TestWeek
