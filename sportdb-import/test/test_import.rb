# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_import.rb


require 'helper'

class TestImport < MiniTest::Test

  def test_eng
    headers = {
      date:    'Date',
      team1:   'HomeTeam',
      team2:   'AwayTeam',
      score1:  'FTHG',
      score2:  'FTAG',
      score1i: 'HTHG',
      score2i: 'HTAG'
    }

    matches = CsvMatchReader.read( "#{SportDb::Import.test_data_dir}/england/2017-18/E0.csv",
                                        headers: headers
                                 )

    league = SportDb::Importer::League.find_or_create( 'eng',
                                          name:        'English Premiere League',
                                          country_id:  SportDb::Importer::Country.find_or_create_builtin!( 'eng' ).id,
                                          ## club:       true
                                       )
    season = SportDb::Importer::Season.find_or_create_builtin( '2017-18' )

    update_matches_txt( matches, league: league, season: season )


    event = SportDb::Model::Event.find_by( league_id: league.id,
                                           season_id: season.id  )

    assert_equal 20,   event.teams.count
    assert_equal 380,  event.games.count

    game0 = event.games.first
    assert_equal 'Arsenal FC',          game0.team1.name
    assert_equal 'Leicester City FC',   game0.team2.name
    assert_equal 4,   game0.score1
    assert_equal 3,   game0.score2
    assert_equal 2,   game0.score1i
    assert_equal 2,   game0.score2i
  end

end # class TestImport
