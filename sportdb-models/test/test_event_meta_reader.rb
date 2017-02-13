# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_event_meta_reader.rb
#  or better
#     rake -I ./lib test


require 'helper'

class TestEventMetaReaderXX < MiniTest::Test  # note: TestEventMetaReader alreay defined, thus, add xx

  def setup
    WorldDb.delete!
    SportDb.delete!
    PersonDb.delete!

    ## setup premier league
    eng     = Country.create!( key: 'eng', name: 'England', code: 'ENG', pop: 1, area: 1)
    season  = Season.create!( key: '2015/16', title: '2015/16' )
    league  = League.create!( key: 'en', title: 'English Premier League', club: true, country_id: eng.id )
    pl      = Event.create!( season_id: season.id, league_id: league.id,
                             start_at: Date.new( 2015, 7, 1 ) )
  end

  def test_pl
    r = TestEventMetaReader.from_file( 'eng-england/2015-16/1-premierleague' )
    r.read

    pp r.event
    pp r.fixtures

    assert_equal ['1-premierleague-i','1-premierleague-ii'], r.fixtures
    assert true   ## if we get here; assume everything ok
  end

  def test_pl_v2
    r = TestEventMetaReader.from_file( 'eng-england/2015-16/1-premierleague-v2' )
    r.read

    pp r.event
    pp r.fixtures

    assert_equal ['1-premierleague-v2'], r.fixtures
    assert true   ## if we get here; assume everything ok
  end

end # class TestEventMetaReader

