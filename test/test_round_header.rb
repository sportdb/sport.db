# encoding: utf-8


require 'helper'

class TestRoundHeader < MiniTest::Unit::TestCase


  def test_round_en
    SportDb.lang.lang = 'en'

    data = [
      [ "2. Round / Group B",
         { pos:2,
           title: '2. Round',
           group_pos: 2,
           group_title: 'Group B',
           ko: false } ],
  
      [ "(1) Matchday P.1  /  1st Leg  //   January 22-24",
         { pos:1,
           title: 'Matchday P.1  /  1st Leg',
           title2: 'January 22-24',
           ko: false } ],

      [ "(4) Matchday 2 / Group 1  //  February 19-21",
         { pos:4,
           title: 'Matchday 2',
           title2: 'February 19-21',
           group_pos: 1,
           group_title: 'Group 1',
           ko: false } ], 

      [ "(13) Round of 16 / 1st Leg   //  April 25, May 1-3",
        { pos:13,
          title:  'Round of 16 / 1st Leg',
          title2: 'April 25, May 1-3',
          ko: false } ],  # NB: 1st Leg is NOT k.o. (only 2nd Leg)

      [ "(14) Round of 16 / 2nd Leg   //  May 8-10",
        { pos:14,
          title:  'Round of 16 / 2nd Leg',
          title2: 'May 8-10',
          ko: true }],

      [ "(4) Match for fifth place",
       { pos:4,
         title: 'Match for fifth place',
         ko: true }],

      [ "(5) Match for third place",
       { pos:5,
         title: 'Match for third place',
         ko: true }],

      [ "(1) Play-off for quarter-finals",
        { pos:1,
          title: 'Play-off for quarter-finals',
          ko: true }],

      [ "(1) Play-off 1st Leg // 11–15 October",
         { pos:1,
           title: 'Play-off 1st Leg',
           title2: '11–15 October',
           ko: false } ],

      [ "(2) Play-off 2nd Leg // 15-19 November",
         { pos:2,
           title: 'Play-off 2nd Leg',
           title2: '15-19 November',
           ko: true } ],
      ]

    assert_rounds( data )
  end


  def test_finals_en
    SportDb.lang.lang = 'en'

    data = [
      [ '(4) Quarter-finals',
        { pos: 4,
          title: 'Quarter-finals',
          ko: true } ],
      
      [ '(5) Semi-finals',
        { pos: 5,
          title: 'Semi-finals',
          ko: true } ],

      [ '(6) Final',
        { pos: 6,
          title: 'Final',
          ko: true } ] ]

    assert_rounds( data )
  end


  def test_round_es
    SportDb.lang.lang = 'es'

    data = [
      [ 'Jornada 2  // 27, 28 y 29 de julio',
        { pos:2,
          title: 'Jornada 2',
          title2: '27, 28 y 29 de julio',
          ko: false } ],

      [ '(18) Cuartos de Final / Ida  // 14/15 de noviembre',
        { pos:18,
          title: 'Cuartos de Final / Ida',
          title2: '14/15 de noviembre',
          ko: false } ],
      
      [ '(19) Cuartos de Final / Vuelta // 17/18 de noviembre',
        { pos:19,
          title: 'Cuartos de Final / Vuelta',
          title2: '17/18 de noviembre',
          ko: true } ]]

    assert_rounds( data )
  end


  def test_round_de
    SportDb.lang.lang = 'de'

    data = [
      [ 'Spieltag 5 / Gruppe A  // Di./Mi., 20.+21. Nov 2012',
        { pos: 5,
          title: 'Spieltag 5',
          title2: 'Di./Mi., 20.+21. Nov 2012',
          group_pos: 1,
          group_title: 'Gruppe A',
          ko: false } ],

      [ '(8)  Achtelfinale Rückspiele  // Di./Mi., 5.+6./12.+13. Mär 2013',
        { pos: 8,
          title: 'Achtelfinale Rückspiele',
          title2: 'Di./Mi., 5.+6./12.+13. Mär 2013',
          ko: true } ]]

    assert_rounds( data )
  end


private
  class Reader
    include LogUtils::Logging      # add logger
    include SportDb::FixtureHelpers
  end

  def assert_rounds( data )
    data.each do |rec|
      line = rec[0]
      hash = rec[1]

      pos, title, title2, group_pos, group_title, ko = parse_round_header( line )

      assert_equal hash[:pos], pos, "pos expected #{hash[:pos]} is #{pos} in line >#{line}<"
      assert_equal hash[:title], title
      assert_equal hash[:title2], title2
      assert_equal hash[:ko], ko
      assert_equal( hash[:group_pos], group_pos, "group_pos expected #{hash[:group_pos]} is #{group_pos} in line >#{line}<" )  if hash[:group_pos]
      assert_equal( hash[:group_title], group_title)  if hash[:group_title]
    end
  end

  def parse_round_header( line )
     reader = Reader.new

     title2 = reader.find_round_header_title2!( line )
     group_title, group_pos = reader.find_group_title_and_pos!( line )
     pos = reader.find_round_pos!( line )
     title = reader.find_round_header_title!( line )
     knockout = reader.is_knockout_round?( title )  # NB: use title as input NOT line

     [pos, title, title2, group_pos, group_title, knockout]
  end

end # class TestRoundHeader