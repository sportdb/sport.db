###
#  to run use
#     ruby -I ./lib -I ./test test/test_season.rb


require 'helper'

class TestSeason < MiniTest::Test


  def test_to_path
    assert_equal '2010-11',       Season( '2010-11' ).to_path
    assert_equal '2010-11',       Season( '2010-2011' ).to_path
    assert_equal '2010-11',       Season( '2010/11' ).to_path
    assert_equal '2010-11',       Season( '2010/1' ).to_path
    assert_equal '2010-11',       Season( '2010/2011' ).to_path
    assert_equal '2010',          Season( '2010' ).to_path

    assert_equal '2010-11',       Season( 2010, 2011 ).to_path
    assert_equal '2010-11',       Season( 2010_2011 ).to_path
    assert_equal '2010-11',       Season( 20102011 ).to_path
    assert_equal '2010-11',       Season( 201011 ).to_path
    assert_equal '2010-11',       Season( 20101 ).to_path
    assert_equal '2010',          Season( 2010 ).to_path

    assert_equal '2010s/2010-11', Season( '2010-11' ).to_path( :decade )
    assert_equal '2010s/2010-11', Season( '2010-2011' ).to_path( :decade )
    assert_equal '2010s/2010',    Season( '2010' ).to_path( :decade )

    assert_equal '1999-00',       Season( '1999-00' ).to_path
    assert_equal '1999-00',       Season( '1999-2000' ).to_path
    assert_equal '1990s/1999-00', Season( '1999-00' ).to_path( :decade )
    assert_equal '1990s/1999-00', Season( '1999-2000' ).to_path( :decade )

    assert_equal '2000s/2010-11', Season( '2010-11' ).to_path( :century )
    assert_equal '2000s/2010-11', Season( '2010-2011' ).to_path( :century )
    assert_equal '2000s/2010',    Season( '2010' ).to_path( :century )

    assert_equal '1900s/1999-00', Season( '1999-00' ).to_path( :century )
    assert_equal '1900s/1999-00', Season( '1999-2000' ).to_path( :century )
  end  # method test_to_path


  def test_key
    assert_equal '2010/11',       Season( '2010-11' ).key
    assert_equal '2010/11',       Season( '2010-2011' ).key
    assert_equal '2010/11',       Season( '2010/11' ).key
    assert_equal '2010/11',       Season( '2010/1' ).key
    assert_equal '2010/11',       Season( '2010/2011' ).key
    assert_equal '2010',          Season( '2010' ).key

    assert_equal '1999/00',       Season( '1999-00' ).key
    assert_equal '1999/00',       Season( '1999-2000' ).key
  end  # method test_key


  def test_years
    [Season( '1999-00' ),
     Season( '1999/00' ),
     Season( '1999/2000' ),
     Season( 1999, 2000 ),
     Season( 1999_00 ),   ## allow "hacky" shortcuts - why? why not?
     Season( 1999_2000 ),
    ].each do |season|
      assert_equal 1999, season.start_year
      assert_equal 2000, season.end_year
    end

    [Season( '2010/1' ),
     Season( '2010/11' ),
     Season( 201011 ),    ## allow "hacky" shortcuts - why? why not?
     Season( 20102011 ),
    ].each do |season|
      assert_equal 2010, season.start_year
      assert_equal 2011, season.end_year
    end

    [Season( '1999' ),
     Season( 1999 ),
    ].each do |season|
      assert_equal 1999, season.start_year
      assert_equal 1999, season.end_year
    end

    [Season( '2010' ),
     Season( 2010 ),
    ].each do |season|
      assert_equal 2010, season.start_year
      assert_equal 2010, season.end_year
    end
  end


  def test_prev
    assert_equal '2009/10',       Season( '2010-11' ).prev.key
    assert_equal '2009/10',       Season( '2010-2011' ).prev.key
    assert_equal '2009',          Season( '2010' ).prev.key

    assert_equal '1998/99',       Season( '1999-00' ).prev.key
    assert_equal '1998/99',       Season( '1999-2000' ).prev.key
  end

  def test_next
    assert_equal '2009/10',       Season( '2008-09' ).next.key
    assert_equal '2009/10',       Season( '2008-2009' ).next.key
    assert_equal '2009',          Season( '2008' ).next.key

    assert_equal '1998/99',       Season( '1997-98' ).next.key
    assert_equal '1998/99',       Season( '1997-1998' ).next.key
  end


  def test_range
    s2010 = Season( '2010' )..Season( '2019' )
    pp s2010.to_a
# => [2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019]

    s2010 = Season( '2010-11')..Season( '2019-20')
    pp s2010.to_a
# => [2010/11, 2011/12, 2012/13, 2013/14, 2014/15,
#     2015/16, 2016/17, 2017/18, 2018/19, 2019/20]

    puts s2010 === Season( '2015-16' )  # true
    puts s2010 === Season( '2015' )     # !!!! false  - why? if using >= <=
    puts s2010 === Season( '1999-00' )  # false
    puts s2010 === Season( '2020-21' )  # false

    puts
    puts s2010.include? Season( '2015-16' )  # true
    puts s2010.include? Season( '2015' )     # !!! false
    puts s2010.include? Season( '1999-00' )  # false

    assert_equal true,  Season( '2010-11' ) < Season( '2015' )
    assert_equal true,  Season( '2015' )    < Season( '2019-20' )

    assert_equal false, Season( '2015' ) == Season( '2015-16' )
    assert_equal true,  Season( '2015' ) <  Season( '2015-16' )
    assert_equal true,  Season( '2015' ) == Season( '2015' )
  end

end # class TestSeason
