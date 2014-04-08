# encoding: utf-8


require 'helper'

class TestRoundDef < MiniTest::Unit::TestCase


  def test_round_en
    SportDb.lang.lang = 'en'

    line = "Matchday 1  |  Thu Jun/12"

    start_at, end_at, pos, title, ko = parse_round_def( line, Date.new( 2014, 6, 1) )

    ## check date month n day
    assert_equal nil, end_at

    assert_equal 1, pos
    assert_equal 'Matchday 1', title
    assert_equal false, ko
  end


private
  class Reader
    include LogUtils::Logging      # add logger
    include SportDb::FixtureHelpers
  end

  def parse_round_def( line, event_start_at )
     reader = Reader.new

     start_at = find_date!( line, start_at: event_start_at )
     end_at   = find_date!( line, start_at: event_start_at )
     pos      = reader.find_round_pos!( line )
     title    = reader.find_round_def_title!( line )
     knockout = reader.is_knockout_round?( title )  # NB: use title as input NOT line

     [start_at, end_at, pos, title, knockout]
  end

end # class TestRoundDef
