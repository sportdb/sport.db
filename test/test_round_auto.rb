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
      ['cd', 'Congo DR',       'COD' ],
      ['kr', 'South Korea',    'KOR' ],
      ['au', 'Australia',      'AUS' ],

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
      ['ht', 'Haiti',          'HAI' ],

      ['at', 'Austria',        'AUT' ],
      ['be', 'Belgium',        'BEL' ],
      ['fr', 'France',         'FRA' ],
      ['rs', 'Serbia',         'SRB' ],
      ['ro', 'Romania',        'ROU' ],
      ['bg', 'Bulgaria',       'BUL' ],
      ['cz', 'Czech Republic', 'CZE' ],
      ['en', 'England',        'ENG' ],
      ['de', 'Germany',        'GER' ], 
      ['hu', 'Hungary',        'HUN' ],
      ['it', 'Italy',          'ITA' ],
      ['ru', 'Russia',         'RUS' ],
      ['es', 'Spain',          'ESP' ],
      ['ch', 'Switzerland',    'SUI' ],
      ['sc', 'Scotland',       'SCO' ],
      ['tr', 'Turkey',         'TUR' ],
      ['nl', 'Netherlands',    'NED' ],
      ['pl', 'Poland',         'POL' ],
      ['se', 'Sweden',         'SWE' ],
    ]

    countries.each do |country|
      key   = country[0]
      name  = country[1]
      code  = country[2]
      Country.create!( key: key, name: name, code: code, pop: 1, area: 1)
    end
  end


  def test_world_cup_1974
    teamreader = TeamReader.new( SportDb.test_data_path )
    teamreader.read( 'world-cup/teams_1974' )

    assert_equal  16, Team.count

    seasonreader = SeasonReader.new( SportDb.test_data_path )
    seasonreader.read( 'world-cup/seasons_1974')

    assert_equal 1, Season.count

    y = Season.find_by_key!( '1974' )
    assert_equal '1974', y.title

    leaguereader = LeagueReader.new( SportDb.test_data_path )
    leaguereader.read( 'world-cup/leagues' )

    assert_equal 1, League.count

    l = League.find_by_key!( 'world' )
    assert_equal 'World Cup', l.title

    gamereader = GameReader.new( SportDb.test_data_path )
    gamereader.read( 'world-cup/1974/cup' )

    assert_equal 1, Event.count

    w = Event.find_by_key!( 'world.1974' )

    assert_equal  16, w.teams.count
    assert_equal  38, w.games.count
    assert_equal  12, w.rounds.count

    rounds_exp = [
      [1,   'Matchday 1',            '1974-06-13', 1], # first group stage
      [2,   'Matchday 2',            '1974-06-14', 3],
      [3,   'Matchday 3',            '1974-06-15', 4],
      [4,   'Matchday 4',            '1974-06-18', 4],
      [5,   'Matchday 5',            '1974-06-19', 4],
      [6,   'Matchday 6',            '1974-06-22', 4],
      [7,   'Matchday 7',            '1974-06-23', 4],
      [8,   'Matchday 8',            '1974-06-26', 4], # second group stage
      [9,   'Matchday 9',            '1974-06-30', 4],
      [10,  'Matchday 10',           '1974-07-03', 4],
      [11,  'Match for third place', '1974-07-06', 1], # finals
      [12,  'Final',                 '1974-07-07', 1],
    ]

    assert_rounds( rounds_exp )

    #########################
    ## 2nd run
    ### try update (e.g. read again - should NOT create new rounds/games/teams)
    #
    #  note: update only works if rounds get not deleted or added
    #  - (adding for updates works only at the end/tail - not at the beginning or inbetween, for example)

    gamereader = GameReader.new( SportDb.test_data_path )
    gamereader.read( 'world-cup/1974/cup' )

    assert_equal 1, Event.count

    w = Event.find_by_key!( 'world.1974' )

    assert_equal  16, w.teams.count
    assert_equal  38, w.games.count
    assert_equal  12, w.rounds.count

    assert_rounds( rounds_exp )

  end # method test_world_cup_1974


  def test_world_cup_1954
    teamreader = TeamReader.new( SportDb.test_data_path )
    teamreader.read( 'world-cup/teams_1954' )

    assert_equal  16, Team.count

    assert_teams( [
      [ 'bra', 'Brazil',  'BRA' ],
      [ 'uru', 'Uruguay', 'URU' ],
      [ 'bel', 'Belgium', 'BEL' ] ] )

    seasonreader = SeasonReader.new( SportDb.test_data_path )
    seasonreader.read( 'world-cup/seasons_1954')

    assert_equal 1, Season.count

    y = Season.find_by_key!( '1954' )
    assert_equal '1954', y.title


    leaguereader = LeagueReader.new( SportDb.test_data_path )
    leaguereader.read( 'world-cup/leagues' )

    assert_equal 1, League.count

    l = League.find_by_key!( 'world' )
    assert_equal 'World Cup', l.title


    gamereader = GameReader.new( SportDb.test_data_path )
    gamereader.read( 'world-cup/1954/cup' )

    assert_equal 1, Event.count

    w = Event.find_by_key!( 'world.1954' )

    assert_equal  16, w.teams.count
    assert_equal  26, w.games.count
    assert_equal  10, w.rounds.count

    rounds_exp = [
      [1,  'Matchday 1',        '1954-06-16', 4],
      [2,  'Matchday 2',        '1954-06-17', 4],
      [3,  'Matchday 3',        '1954-06-19', 4],
      [4,  'Matchday 4',        '1954-06-20', 4],
      [5,  'Group-2 Play-off',  '1954-06-23', 1],
      [6,  'Group-4 Play-off',  '1954-06-23', 1],
      [7,  'Quarter-finals',    '1954-06-26', 4],
      [8,  'Semi-finals',       '1954-06-30', 2],
      [9,  'Third place match', '1954-07-03', 1],
      [10, 'Final',             '1954-07-04', 1],
    ]

    assert_rounds( rounds_exp )

  end # test_world_cup_1954


  def test_world_cup_1930
    teamreader = TeamReader.new( SportDb.test_data_path )
    teamreader.read( 'world-cup/teams_1930' )

    assert_equal  13, Team.count

    assert_teams( [
      [ 'arg', 'Argentina', 'ARG' ],
      [ 'bra', 'Brazil',    'BRA' ],
      [ 'bel', 'Belgium',   'BEL' ] ] )

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

    rounds_exp = [
      [1,  'Matchday 1',        '1930-07-13', 2],
      [2,  'Matchday 2',        '1930-07-14', 2],
      [3,  'Matchday 3',        '1930-07-15', 1],
      [4,  'Matchday 4',        '1930-07-16', 1],
      [5,  'Matchday 5',        '1930-07-17', 2],
      [6,  'Matchday 6',        '1930-07-18', 1],
      [7,  'Matchday 7',        '1930-07-19', 2],
      [8,  'Matchday 8',        '1930-07-20', 2],
      [9,  'Matchday 9',        '1930-07-21', 1],
      [10, 'Matchday 10',       '1930-07-22', 1],
      [11, 'Semi-finals',       '1930-07-26', 2],
      [12, 'Final' ,            '1930-07-30', 1],
    ]

    assert_rounds( rounds_exp )
  end  # method test_world_cup_1930


  def test_world_cup_1962
    teamreader = TeamReader.new( SportDb.test_data_path )
    teamreader.read( 'world-cup/teams_1962' )

    assert_equal  16, Team.count

    assert_teams( [
      [ 'arg', 'Argentina', 'ARG' ],
      [ 'bra', 'Brazil',    'BRA' ],
      [ 'ita', 'Italy',     'ITA' ] ] )

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

    assert_equal  16,  w.teams.count
    assert_equal  32,  w.games.count
    assert_equal  10,  w.rounds.count

    rounds_exp = [
      [1,  'Matchday 1',        '1962-05-30', 4],
      [2,  'Matchday 2',        '1962-05-31', 4],
      [3,  'Matchday 3',        '1962-06-02', 4],
      [4,  'Matchday 4',        '1962-06-03', 4],
      [5,  'Matchday 5',        '1962-06-06', 4],
      [6,  'Matchday 6',        '1962-06-07', 4],
      [7,  'Quarter-finals',    '1962-06-10', 4],
      [8,  'Semi-finals',       '1962-06-13', 2],
      [9,  'Third place match', '1962-06-16', 1],
      [10, 'Final' ,            '1962-06-17', 1],
    ]

    assert_rounds( rounds_exp )
    
    #########################
    ## 2nd run
    ### try update (e.g. read again - should NOT create new rounds/games/teams)
    #
    #  note: update only works if rounds get not deleted or added
    #  - (adding for updates works only at the end/tail - not at the beginning or inbetween, for example)

    gamereader = GameReader.new( SportDb.test_data_path )
    gamereader.read( 'world-cup/1962/cup' )

    assert_equal 1, Event.count

    w = Event.find_by_key!( 'world.1962' )

    assert_equal  16,  w.teams.count
    assert_equal  32,  w.games.count
    assert_equal  10,  w.rounds.count

    assert_rounds( rounds_exp )

  end  # method test_world_cup_1962

####
# helpers

  def assert_rounds( rounds_exp )
    rounds_exp.each do |round_exp|
       round = Round.find_by_pos!( round_exp[0] )
  
      assert_equal round_exp[1], round.title

      if round_exp[2]
        start_at = Date.parse( round_exp[2] )
        ## puts "round.start_at.class.name: #{round.start_at.class.name}"
        assert_equal start_at, round.start_at    ## check works for date?
      end

      if round_exp[3]
        count = round_exp[3]
        assert_equal( count, round.games.count, "round.games.count #{count} != #{round.games.count} - #{round.title}")
      end
    end
  end # method assert_rounds

  def assert_teams( teams_exp )
    teams_exp.each do |team_exp|
       team = Team.find_by_key!( team_exp[0] )
    
       assert_equal team_exp[1], team.title
       assert_equal team_exp[2], team.code
    end
  end # method assert_teams


end # class TestRoundAuto
