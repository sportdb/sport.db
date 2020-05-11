# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_event_table_reader.rb


require 'helper'

class TestEventTableReaderXX < MiniTest::Test  # note: TestEventTableReader alreay defined, thus, add xx

  def setup
    WorldDb.delete!
    SportDb.delete!
    PersonDb.delete!

    ## setup österr. bundesliga
    at     = Country.create!( key: 'at', name: 'Austria', code: 'AUT', pop: 1, area: 1)
    season = Season.create!( key: '2015/16', title: '2015/16' )
    bl     = League.create!( key: 'at', title: 'Österr. Bundesliga', club: true, country_id: at.id )

    ## read teams (required for db key lookup)
    teamreader = TestTeamReader.from_file( 'at-austria/teams', country_id: at.id )
    teamreader.read
    teamreader = TestTeamReader.from_file( 'at-austria/teams_2', country_id: at.id )
    teamreader.read
  end

  def test_bl
    r = TestEventTableReader.from_file( 'at-austria/2015_16/1-bundesliga.conf' )
    r.read

    assert true   ## if we get here; assume everything ok
  end

  def test_bl_v2
    r = TestEventTableReader.from_file( 'at-austria/2015_16/1-bundesliga-v2.conf' )
    r.read

    assert true   ## if we get here; assume everything ok
  end


  ### fix/todo:
  ##   to be done - add support for Wiener Sportklub (RL Ost) => Wiener Sportklub lookups
  def xxxx_test_cup
    at     = Country.create!( key: 'at', name: 'Austria', code: 'AUT', pop: 1, area: 1)
    season = Season.create!( key: '2015/16', title: '2015/16' )
    cup     = League.create!( key: 'at.cup', title: 'Cup', club: true, country_id: at.id )

    r = TestEventReader.from_file( 'at-austria/2015_16/cup' )
    r.read

    assert true   ## if we get here; assume everything ok
  end

end # class TestEventReader
