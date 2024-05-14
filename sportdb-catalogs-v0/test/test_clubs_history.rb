###
#  to run use
#     ruby -I ./lib -I ./test test/test_clubs_history.rb


require 'helper'

class TestClubsHistory < MiniTest::Test

   CLUBS         = SportDb::Import.catalog.clubs
   CLUBS_HISTORY = SportDb::Import.catalog.clubs_history


  def test_at
    pp CLUBS_HISTORY.mappings

    puts CLUBS_HISTORY.find_name_by( name: 'WSG Tirol', season: '2019/20' )
    puts CLUBS_HISTORY.find_name_by( name: 'WSG Tirol', season: '2018/9' )
    puts CLUBS_HISTORY.find_name_by( name: 'WSG Tirol', season: '2017/8' )

    club = CLUBS.find( 'WSG Wattens' )
    pp club

    assert_equal 'WSG Tirol',   club.name_by_season( '2019/20' )
    assert_equal 'WSG Wattens', club.name_by_season( '2018/9' )
    assert_equal 'WSG Wattens', club.name_by_season( '2017/8' )


    club = CLUBS.find( 'Rapid Wien' )
    pp club

    assert_equal 'SK Rapid Wien', club.name_by_season( '2000/1' )
    assert_equal 'SK Rapid Wien', club.name_by_season( '1891/2' )
  end

  def test_eng
    club = CLUBS.find_by( name: 'Arsenal', country: 'ENG' )
    pp club

    assert_equal 'Arsenal FC',          club.name_by_season( '2000/1' )
    assert_equal 'Arsenal FC',          club.name_by_season( '1927/8' )
    assert_equal 'The Arsenal FC',      club.name_by_season( '1926/7' )
    assert_equal 'Woolwich Arsenal FC', club.name_by_season( '1913/4' )
    assert_equal 'Royal Arsenal FC',    club.name_by_season( '1891/2' )
  end

end # class TestClubsHistory
