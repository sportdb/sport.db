# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_lang.rb
#  or better
#     rake -I ./lib test

require 'helper'

class TestRound < MiniTest::Unit::TestCase


  def test_round_en
    SportDb.lang.lang = 'en'

    line = "2. Round / Group B"

    pos, title, title2, group_pos, group_title, ko = parse_round( line )

    assert_equal 2, pos
    assert_equal '2. Round', title
    assert_equal nil, title2
    assert_equal false, ko

    line = "(1) Matchday P.1  /  1st Leg  //   January 22-24"

    pos, title, title2, group_pos, group_title, ko = parse_round( line )

    assert_equal 1, pos
    assert_equal 'Matchday P.1  /  1st Leg', title
    assert_equal 'January 22-24', title2
    assert_equal false, ko

    line = "(4) Matchday 2 / Group 1  //  February 19-21"

    pos, title, title2, group_pos, group_title, ko = parse_round( line )

    assert_equal 4, pos
    assert_equal 'Matchday 2', title 
    assert_equal 'February 19-21', title2
    assert_equal false, ko


    line = "(13) Round of 16 / 1st Leg   //  April 25, May 1-3"

    pos, title, title2, group_pos, group_title, ko = parse_round( line )

    assert( pos == 13 )
    assert( title == "Round of 16 / 1st Leg" )
    assert( title2 == "April 25, May 1-3" )
    assert( ko == false )  # NB: 1st Leg is NOT k.o. (only 2nd Leg)

    line = "(14) Round of 16 / 2nd Leg   //  May 8-10"
    
    pos, title, title2, group_pos, group_title, ko = parse_round( line )

    assert( pos == 14 )
    assert( title == "Round of 16 / 2nd Leg" )
    assert( title2 == "May 8-10" )
    assert( ko == true )
  end



  def test_finals_en
    SportDb.lang.lang = 'en'

    line = "(4) Quarter-finals"
    
    pos, title, title2, group_pos, group_title, ko = parse_round( line )

    assert( pos == 4 )
    assert( title == "Quarter-finals" )
    assert( title2 == nil )
    assert( ko == true )

    line = "(5) Semi-finals"
    
    pos, title, title2, group_pos, group_title, ko = parse_round( line )

    assert( pos == 5 )
    assert( title == "Semi-finals" )
    assert( title2 == nil )
    assert( ko == true )

    line = "(6) Final"

    pos, title, title2, group_pos, group_title, ko = parse_round( line )

    assert( pos == 6 )
    assert( title == "Final" )
    assert( title2 == nil )
    assert( ko == true )
  end


  def test_round_es
    SportDb.lang.lang = 'es'

    line = "Jornada 2   // 27, 28 y 29 de julio"

    pos, title, title2, group_pos, group_title, ko = parse_round( line )

    assert( pos == 2 )
    assert( title == 'Jornada 2' )
    assert( title2 == '27, 28 y 29 de julio' )
    assert( ko == false )

    line = "(18) Cuartos de Final / Ida      // 14/15 de noviembre"

    pos, title, title2, group_pos, group_title, ko = parse_round( line )

    assert( pos == 18 )
    assert( title == 'Cuartos de Final / Ida' )
    assert( title2 == '14/15 de noviembre' )
    assert( ko == false )

    line = "(19) Cuartos de Final / Vuelta // 17/18 de noviembre"

    pos, title, title2, group_pos, group_title, ko = parse_round( line )

    assert( pos == 19 )
    assert( title == 'Cuartos de Final / Vuelta' )
    assert( title2 == '17/18 de noviembre' )
    assert( ko == true )
  end


  def test_round_de
    SportDb.lang.lang = 'de'

    line = "Spieltag 5 / Gruppe A  // Di./Mi., 20.+21. Nov 2012"
    
    pos, title, title2, group_pos, group_title, ko = parse_round( line )

    assert( pos == 5 )
    assert( title == 'Spieltag 5' )
    assert( title2 == 'Di./Mi., 20.+21. Nov 2012' )
    assert( ko == false )
    
    line = "(8)  Achtelfinale Rückspiele  // Di./Mi., 5.+6./12.+13. Mär 2013"

    pos, title, title2, group_pos, group_title, ko = parse_round( line )

    assert( pos == 8 )
    assert( title == 'Achtelfinale Rückspiele' )
    assert( title2 == 'Di./Mi., 5.+6./12.+13. Mär 2013' )
    assert( ko == true )
  end


private
  class Reader
    include LogUtils::Logging      # add logger
    include SportDb::FixtureHelpers
  end

  def parse_round( line )
     reader = Reader.new

     title2 = reader.find_round_title2!( line )
     group_title, group_pos = reader.find_group_title_and_pos!( line )
     pos = reader.find_round_pos!( line )
     title = reader.find_round_title!( line )
     knockout = reader.is_knockout_round?( title )  # NB: use title as input NOT line

     [pos, title, title2, group_pos, group_title, knockout]
  end

end # class TestRound