# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_season.rb


require 'helper'

class TestSeason < MiniTest::Test

  Season = SportDb::Import::Season

  def test_path
    assert_equal '2010-11',       Season.new( '2010-11' ).path
    assert_equal '2010-11',       Season.new( '2010-2011' ).path
    assert_equal '2010-11',       Season.new( '2010/11' ).path
    assert_equal '2010-11',       Season.new( '2010/1' ).path
    assert_equal '2010-11',       Season.new( '2010/2011' ).path
    assert_equal '2010',          Season.new( '2010' ).path

    assert_equal '2010s/2010-11', Season.new( '2010-11' ).path( format: 'long' )
    assert_equal '2010s/2010-11', Season.new( '2010-2011' ).path( format: 'long' )
    assert_equal '2010s/2010',    Season.new( '2010' ).path( format: 'long' )

    assert_equal '1999-00',       Season.new( '1999-00' ).path
    assert_equal '1999-00',       Season.new( '1999-2000' ).path
    assert_equal '1990s/1999-00', Season.new( '1999-00' ).path( format: 'long' )
    assert_equal '1990s/1999-00', Season.new( '1999-2000' ).path( format: 'long' )
  end  # method test_path

  def test_key
    assert_equal '2010/11',       Season.new( '2010-11' ).key
    assert_equal '2010/11',       Season.new( '2010-2011' ).key
    assert_equal '2010/11',       Season.new( '2010/11' ).key
    assert_equal '2010/11',       Season.new( '2010/1' ).key
    assert_equal '2010/11',       Season.new( '2010/2011' ).key
    assert_equal '2010',          Season.new( '2010' ).key

    assert_equal '1999/00',       Season.new( '1999-00' ).key
    assert_equal '1999/00',       Season.new( '1999-2000' ).key
  end  # method test_key

  def test_years
    season = Season.new( '1999-00' )
    assert_equal 1999, season.start_year
    assert_equal 2000, season.end_year

    season = Season.new( '2010/1' )
    assert_equal 2010, season.start_year
    assert_equal 2011, season.end_year
  end

  def test_prev
    assert_equal '2009/10',       Season.new( '2010-11' ).prev.key
    assert_equal '2009/10',       Season.new( '2010-2011' ).prev.key
    assert_equal '2009',          Season.new( '2010' ).prev.key

    assert_equal '1998/99',       Season.new( '1999-00' ).prev.key
    assert_equal '1998/99',       Season.new( '1999-2000' ).prev.key
  end
end # class TestSeason
