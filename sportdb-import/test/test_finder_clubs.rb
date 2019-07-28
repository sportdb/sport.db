# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_finder_clubs.rb


require 'helper'

class TestFinderClubs < MiniTest::Test

  def test_eng_i
    ## todo/fix:
    ##    add guest1_country_id (optional) to league (e.g. wales for english premier leaguage)
    ##                                               (e.g. canada for mls)
    ##                                               (e.g. liechtenstein for swiss superleague) etc.
    ##                                               why? why not?
    league = SportDb::Importer::League.find_or_create( 'eng',
                                          name:        'English Premiere League',
                                          country:     'eng',
                                          ## club:       true
                                       )
    team_names = [
      'Manchester City',
      'Arsenal',
      'Liverpool',
      'Cardiff',
    ]
    recs = find_or_create_clubs!( team_names, league: league )
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


  def test_eng_ii
    headers = {
      date:    'Date',
      team1:   'HomeTeam',
      team2:   'AwayTeam',
      score1:  'FTHG',
      score2:  'FTAG',
      score1i: 'HTHG',
      score2i: 'HTAG'
    }

    matches = CsvMatchReader.read( "#{SportDb::Import.config.test_data_dir}/england/2017-18/E0.csv",
                                        headers: headers
                                 )

    ## pp matches[0..2]

    matchlist = SportDb::Struct::Matchlist.new( matches )
    team_names = matchlist.teams
    puts "#{team_names.size} team names:"
    pp team_names
=begin
20 team names:
["Arsenal",
 "Bournemouth",
 "Brighton",
 "Burnley",
 "Chelsea",
 "Crystal Palace",
 "Everton",
 "Huddersfield",
 "Leicester",
 "Liverpool",
 "Man City",
 "Man United",
 "Newcastle",
 "Southampton",
 "Stoke",
 "Swansea",
 "Tottenham",
 "Watford",
 "West Brom",
 "West Ham"]
=end

    league = SportDb::Importer::League.find_or_create( 'eng',
                                          name:        'English Premiere League',
                                          country:     'eng',
                                          ## club:       true
                                       )

    recs = find_or_create_clubs!( team_names, league: league )
    assert_equal 20, recs.size

    assert_equal 'Arsenal FC', recs[0].name
    ## assert_equal '?',    recs[0].city.name
    assert_equal 'England',         recs[0].country.name

    assert_equal 'AFC Bournemouth', recs[1].name
    ## assert_equal '?',     recs[1].city.name
    assert_equal 'England',    recs[1].country.name
  end


  def test_at
    headers = {
      ## season: 'Season',  ## check if season required / needed???
      date:   'Date',
      team1:  'Home',
      team2:  'Away',
      score1: 'HG',
      score2: 'AG',
    }

    matches = CsvMatchReader.read( "#{SportDb::Import.config.test_data_dir}/austria/AUT.csv",
                                        headers: headers,
                                        filters: { 'Season' => '2016/2017' }
                                  )

    ## pp matches[0..2]

    matchlist = SportDb::Struct::Matchlist.new( matches )
    team_names = matchlist.teams
    puts "#{team_names.size} team names:"
    pp team_names
=begin
10 team names:
["AC Wolfsberger",
 "Admira",
 "Altach",
 "Austria Vienna",
 "Mattersburg",
 "Rapid Vienna",
 "Ried",
 "Salzburg",
 "St. Polten",
 "Sturm Graz"]
=end

    league = SportDb::Importer::League.find_or_create( 'at',
                                          name:        'Österr. Bundesliga',
                                          country:     'at',
                                          ## club:       true
                                       )

    recs = find_or_create_clubs!( team_names, league: league )
    assert_equal 10, recs.size

    assert_equal 'Wolfsberger AC', recs[0].name
    ## assert_equal '?',    recs[0].city.name
    assert_equal 'Austria',           recs[0].country.name

    assert_equal 'FC Admira Wacker Mödling', recs[1].name
    ## assert_equal '?',     recs[1].city.name
    assert_equal 'Austria',    recs[1].country.name
  end

end # class TestFinderClubs
