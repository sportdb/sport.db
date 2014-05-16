# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_round_auto.rb
#  or better
#     rake -I ./lib test


require 'helper'

class TestRoundAuto < MiniTest::Unit::TestCase

  def setup
    WorldDb.delete!
    SportDb.delete!
    ## SportDb.read_builtin

    add_countries
  end

  def add_countries
    countries = [
      ['ar', 'Argentina',      'ARG' ],
      ['br', 'Brazil',         'BRA' ],
      ['bo', 'Bolivia',        'BOL' ],
      ['cl', 'Chile',          'CHI' ],
      ['co', 'Colombia',       'COL' ],
      ['uy', 'Uruguay',        'URU' ],
      ['pe', 'Peru',           'PER' ],
      ['py', 'Paraguay',       'PAR' ],
      ['mx', 'Mexico',         'MEX' ],
      ['us', 'United States',  'USA' ],
      ['fr', 'France',         'FRA' ],
      ['rs', 'Serbia',         'SRB' ],
      ['be', 'Belgium',        'BEL' ],
      ['ro', 'Romania',        'ROU' ],
      ['bg', 'Bulgaria',       'BUL' ],
      ['cz', 'Czech Republic', 'CZE' ],
      ['en', 'England',        'ENG' ],
      ['de', 'Germany',        'GER' ], 
      ['hu', 'Hungary',        'HUN' ],
      ['it', 'Italy',          'ITA' ],
      ['ru', 'Russia',         'RUS' ],
      ['es', 'Spain',          'ESP' ],
      ['ch', 'Switzerland',    'SUI' ]]


    countries.each do |country|
      key   = country[0]
      name  = country[1]
      code  = country[2]
      Country.create!( key: key, name: name, code: code, pop: 1, area: 1)
    end
  end


  def xxx_test_world_cup_1930
    teamreader = TeamReader.new( SportDb.test_data_path )
    teamreader.read( 'world-cup/teams_1930' )

    assert_equal  13, Team.count

    ar = Team.find_by_key!( 'arg' )
    br = Team.find_by_key!( 'bra' )
    be = Team.find_by_key!( 'bel' )

    assert_equal 'Argentina', ar.title
    assert_equal 'Brazil',    br.title
    assert_equal 'Belgium',   be.title

    assert_equal 'ARG', ar.code
    assert_equal 'BRA', br.code


    seasonreader = SeasonReader.new( SportDb.test_data_path )
    seasonreader.read( 'world-cup/seasons_1930')

    assert_equal 1, Season.count

    y = Season.find_by_key!( '1930' )
    assert_equal '1930', y.title


    leaguereader = LeagueReader.new( SportDb.test_data_path )
    leaguereader.read( 'world-cup/leagues' )

    assert_equal 1, League.count

    l = League.find_by_key!( 'world' )
    assert_equal 'World Cup', l.title


    gamereader = GameReader.new( SportDb.test_data_path )
    gamereader.read( 'world-cup/1930/cup' )

    assert_equal 1, Event.count

    w = Event.find_by_key!( 'world.1930' )

    assert_equal  13, w.teams.count
    assert_equal  18, w.games.count
    assert_equal  12, w.rounds.count

    ##
    # auto-numbered knock-out rounds
    r11 = Round.find_by_pos!( 11 )

    assert_equal 'Semi-finals', r11.title
    assert_equal 2,             r11.games.count

    r12 = Round.find_by_pos!( 12 )

    assert_equal 'Final', r12.title
    assert_equal 1,       r12.games.count

  end  # method test_world_cup_1930


  def test_world_cup_1962
    teamreader = TeamReader.new( SportDb.test_data_path )
    teamreader.read( 'world-cup/teams_1962' )

    assert_equal  16, Team.count

    ar = Team.find_by_key!( 'arg' )
    br = Team.find_by_key!( 'bra' )
    it = Team.find_by_key!( 'ita' )

    assert_equal 'Argentina', ar.title
    assert_equal 'Brazil',    br.title
    assert_equal 'Italy',     it.title

    assert_equal 'ARG', ar.code
    assert_equal 'BRA', br.code


    seasonreader = SeasonReader.new( SportDb.test_data_path )
    seasonreader.read( 'world-cup/seasons_1962')

    assert_equal 1, Season.count

    y = Season.find_by_key!( '1962' )
    assert_equal '1962', y.title


    leaguereader = LeagueReader.new( SportDb.test_data_path )
    leaguereader.read( 'world-cup/leagues' )

    assert_equal 1, League.count

    l = League.find_by_key!( 'world' )
    assert_equal 'World Cup', l.title


    gamereader = GameReader.new( SportDb.test_data_path )
    gamereader.read( 'world-cup/1962/cup' )

    assert_equal 1, Event.count

    w = Event.find_by_key!( 'world.1962' )

    assert_equal  16, w.teams.count
    # assert_equal  18, w.games.count
    # assert_equal  12, w.rounds.count


  end  # method test_world_cup_1962


end # class TestRoundAuto
