# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_finder_clubs.rb


require 'helper'

class TestFinderClubs < MiniTest::Test

  def test_eng
    league = SportDb::Importer::League.find_or_create( 'eng',
                                          name:        'England League 1',
                                          country_id:  SportDb::Importer::Country.find_or_create_builtin!( 'eng' ).id,
                                          ## club:       true
                                       )
    season = SportDb::Importer::Season.find_or_create_builtin( '2017-18' )

    team_names = [
      'Manchester City',
      'Arsenal',
      'Liverpool',
      'Cardiff',
    ]
    recs = find_or_create_clubs!( team_names, league: league, season: season )
    assert_equal 4, recs.size

    assert_equal 'Manchester City FC', recs[0].name
    ## assert_equal 'Manchester',    recs[0].city.name
    assert_equal 'England',           recs[0].country.name

    assert_equal 'Arsenal FC', recs[1].name
    ## assert_equal 'London',     recs[1].city.name
    assert_equal 'England',    recs[1].country.name

    assert_equal 'Cardiff City FC', recs[3].name
    ## assert_equal 'Cardiff',    recs[3].city.name
    assert_equal 'Wales',           recs[3].country.name
  end

end # class TestFinderClubs
