# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_round_def.rb
#  or better
#     rake -I ./lib test


require 'helper'

class TestRoundDef < MiniTest::Unit::TestCase


  def test_round_en
    SportDb.lang.lang = 'en'

    data = [
      [ 'Matchday 1  |  Thu Jun/12',
        { pos:1,
          title: 'Matchday 1',
          ko: false,
          start_at: Date.new( 2014, 6, 12 ) }],
      [ 'Matchday 13 |  Tue Jun/24',
        { pos: 13,
          title: 'Matchday 13',
          ko: false,
          start_at: Date.new( 2014, 6, 24 ) }],
      [ '(16) Round of 16  |  Sat Jun/28 - Tue Jul/1',
        { pos: 16,
          title: 'Round of 16',
          ko: true,
          start_at: Date.new( 2014, 6, 28 ),
          end_at:   Date.new( 2014, 7, 1  ) }],
      [ '(18) Semi-finals  |  Tue Jul/8 - Wed Jul/9',
        { pos: 18,
          title: 'Semi-finals',
          ko: true,
          start_at: Date.new( 2014, 7, 8 ),
          end_at:   Date.new( 2014, 7, 9 ) }],
      [ '(19) Match for third place  |  Sat Jul/12',
        { pos: 19,
          title: 'Match for third place',
          ko: true,
          start_at: Date.new( 2014, 7, 12 ) }],
      [ '(20) Final  |  Sun Jul/13',
        { pos: 20,
          title: 'Final',
          ko: true,
          start_at: Date.new( 2014, 7, 13 ) }] ]

    assert_rounds( data, Date.new( 2014, 6, 12 ))  ## starts Jun/12 2014
  end


private
  class Reader
    include LogUtils::Logging      # add logger
    include SportDb::FixtureHelpers
  end

  def assert_rounds( data, event_start_at )
    data.each do |rec|
      line = rec[0]
      hash = rec[1]

      start_at, end_at, pos, title, ko = parse_round_def( line, event_start_at )

      assert_equal hash[:pos],   pos, "pos expected #{hash[:pos]} is #{pos} in line >#{line}<"
      assert_equal hash[:title], title
      assert_equal hash[:ko],    ko
      
      if hash[:start_at]
        assert_equal hash[:start_at].year,  start_at.year
        assert_equal hash[:start_at].month, start_at.month
        assert_equal hash[:start_at].day,   start_at.day
      end

      if hash[:end_at]
        assert_equal hash[:end_at].year,  end_at.year
        assert_equal hash[:end_at].month, end_at.month
        assert_equal hash[:end_at].day,   end_at.day
      end      
    end
  end

  def parse_round_def( line, event_start_at )
     reader = Reader.new

     start_at = reader.find_date!( line, start_at: event_start_at )
     end_at   = reader.find_date!( line, start_at: event_start_at )
     pos      = reader.find_round_pos!( line )
     title    = reader.find_round_def_title!( line )
     knockout = reader.is_knockout_round?( title )  # NB: use title as input NOT line

     [start_at, end_at, pos, title, knockout]
  end

end # class TestRoundDef
