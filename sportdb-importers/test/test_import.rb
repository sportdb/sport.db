# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_import.rb


require 'helper'

class TestImport < MiniTest::Test

  def setup
    SportDb.connect( adapter:  'sqlite3',
                     database: ':memory:' )
    SportDb.create_all   ## build schema

    ## turn on logging to console
    ## ActiveRecord::Base.logger = Logger.new(STDOUT)
  end


  def test_eng
    ## fix/todo:
    ##  use Event.read_csv   - why? why not?
    ##      Event.parse_csv  - why? why not?

    headers = {
      date:    'Date',
      team1:   'HomeTeam',
      team2:   'AwayTeam',
      score1:  'FTHG',
      score2:  'FTAG',
      score1i: 'HTHG',
      score2i: 'HTAG'
    }

    event_rec = CsvEventImporter.read( "#{SportDb::Test.data_dir}/england/2017-18/E0.csv",
                                        headers: headers,
                                        league: 'ENG',  ## fetch English Premiere League
                                        season: '2017/18'
                                     )

    assert_equal 20,   event_rec.teams.count
    assert_equal 380,  event_rec.games.count

    rec = event_rec.games.first
    assert_equal 'Arsenal FC',          rec.team1.name
    assert_equal 'Leicester City FC',   rec.team2.name
    assert_equal 4,   rec.score1
    assert_equal 3,   rec.score2
    assert_equal 2,   rec.score1i
    assert_equal 2,   rec.score2i
  end

end # class TestImport
