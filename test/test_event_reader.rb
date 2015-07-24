# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_event_reader.rb
#  or better
#     rake -I ./lib test


require 'helper'

class TestEventReaderXX < MiniTest::Test  # note: TestEventReader alreay defined, thus, add xx

  def setup
    WorldDb.delete!
    SportDb.delete!
    PersonDb.delete!
  end

  def test_bl
    at     = Country.create!( key: 'at', name: 'Austria', code: 'AUT', pop: 1, area: 1)
    season = Season.create!( key: '2015/16', title: '2015/16' )
    bl     = League.create!( key: 'at', title: 'Bundesliga', club: true, country_id: at.id )

    r = TestEventReader.from_file( 'at-austria/2015_16/1-bundesliga' )
    r.read
 
    assert true   ## if we get here; assume everything ok
  end

  def test_cup
    at     = Country.create!( key: 'at', name: 'Austria', code: 'AUT', pop: 1, area: 1)
    season = Season.create!( key: '2015/16', title: '2015/16' )
    cup     = League.create!( key: 'at.cup', title: 'Cup', club: true, country_id: at.id )

    r = TestEventReader.from_file( 'at-austria/2015_16/cup' )
    r.read
 
    assert true   ## if we get here; assume everything ok
  end

end # class TestEventReader


