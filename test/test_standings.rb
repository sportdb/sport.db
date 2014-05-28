# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_standings.rb
#  or better
#     rake -I ./lib test


require 'helper'



class TestStandings < MiniTest::Unit::TestCase

  def setup
    WorldDb.delete!
    SportDb.delete!
    ## SportDb.read_builtin

    add_countries
    add_world_cup_1974
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


  def add_world_cup_1974
    teamreader = TeamReader.new( SportDb.test_data_path )
    teamreader.read( 'world-cup/teams_1974' )
    
    seasonreader = SeasonReader.new( SportDb.test_data_path )
    seasonreader.read( 'world-cup/seasons_1974')

    leaguereader = LeagueReader.new( SportDb.test_data_path )
    leaguereader.read( 'world-cup/leagues' )

    gamereader = GameReader.new( SportDb.test_data_path )
    gamereader.read( 'world-cup/1974/cup' )

    ev = Event.find_by_key!( 'world.1974' )

    assert_equal  16, ev.teams.count
    assert_equal  38, ev.games.count
    assert_equal  12, ev.rounds.count
  end # method add_world_cup_1974


  def test_alltime_standings
    st = AlltimeStanding.create!( key: 'worldcup', title: 'All Time World Cup' )

    assert_equal 1, AlltimeStanding.count
    assert_equal 0, st.entries.count

    ## add some team entries

    arg = Team.find_by_key!( 'arg' )
    bra = Team.find_by_key!( 'bra' )
    ita = Team.find_by_key!( 'ita' )
    
    AlltimeStandingEntry.create!( standing_id: st.id, team_id: arg.id )
    AlltimeStandingEntry.create!( standing_id: st.id, team_id: bra.id )
    AlltimeStandingEntry.create!( standing_id: st.id, team_id: ita.id )

    assert_equal 3, st.entries.count
    assert_equal 3, AlltimeStandingEntry.count
    
    st2 = AlltimeStandingEntry.first.standing    # check back/parent ref w/ standing belongs_to assoc
    assert_equal 'worldcup',            st2.key 
    assert_equal 'All Time World Cup',  st2.title
  end # test_alltime_standings


  def test_event_standings_recalc
    ev = Event.find_by_key!( 'world.1974' )
    
    assert_equal 16, ev.teams.count

    st = EventStanding.create!( event_id: ev.id )

    assert_equal 1, EventStanding.count
    assert_equal 0, st.entries.count

    st.recalc!
    assert_equal 16, st.entries.count

    st.recalc!  ## try again (check update)
    assert_equal 16, st.entries.count

    ## try global recalc
    EventStandingEntry.delete_all
    assert_equal 1, EventStanding.count
    assert_equal 0, EventStandingEntry.count

    EventStanding.recalc!
    assert_equal 1, EventStanding.count
    assert_equal 16, EventStandingEntry.count

  end # test_event_standings_recalc
  

  def test_group_standings_recalc
    g2 = Group.find_by_pos!( 2 )   ##  Group 2  |  Yugoslavia     Brazil          Scotland      Zaire

    assert_equal 4, g2.teams.count

    st2 = GroupStanding.create!( group_id: g2.id )

    assert_equal 1, GroupStanding.count
    assert_equal 0, st2.entries.count

    st2.recalc!
    assert_equal 4, st2.entries.count

    st2.recalc!  ## try again (check update)
    assert_equal 4, st2.entries.count

    ## try global recalc
    GroupStandingEntry.delete_all
    assert_equal 1, GroupStanding.count
    assert_equal 0, GroupStandingEntry.count

    GroupStanding.recalc!
    assert_equal 1, GroupStanding.count
    assert_equal 4, GroupStandingEntry.count

  end # test_group_standings_recalc


  def test_group_standings
    ## Group 1  |  East Germany   West Germany    Chile         Australia
    ## Group 2  |  Yugoslavia     Brazil          Scotland      Zaire
    ## Group 3  |  Netherlands    Sweden          Bulgaria      Uruguay
    ## Group 4  |  Poland         Argentina       Italy         Haiti
    
    g2 = Group.find_by_pos!( 2 )
    g4 = Group.find_by_pos!( 4 )

    assert_equal 4, g2.teams.count
    assert_equal 4, g4.teams.count

    st2 = GroupStanding.create!( group_id: g2.id )
    st4 = GroupStanding.create!( group_id: g4.id )
    
    assert_equal 2, GroupStanding.count
    assert_equal 0, st2.entries.count
    assert_equal 0, st4.entries.count

    ## add some team entries
    bra = Team.find_by_key!( 'bra' )
    arg = Team.find_by_key!( 'arg' )
    ita = Team.find_by_key!( 'ita' )
    
    GroupStandingEntry.create!( standing_id: st2.id, team_id: bra.id )
    GroupStandingEntry.create!( standing_id: st4.id, team_id: arg.id )
    GroupStandingEntry.create!( standing_id: st4.id, team_id: ita.id )

    assert_equal 1, st2.entries.count
    assert_equal 2, st4.entries.count
    assert_equal 3, GroupStandingEntry.count
    
    st2ii = st2.entries.first.standing    # check back/parent ref w/ standing belongs_to assoc
    assert_equal g2.title, st2ii.group.title


    ## Group I  |  Netherlands     Brazil     East Germany     Argentina
    ## Group J  |  West Germany    Poland     Sweden           Yugoslavia

    gi = Group.find_by_pos!( 9 )   # note: I maps to 9
    gj = Group.find_by_pos!( 10 )  # note: J maps to 10

    assert_equal 4, gi.teams.count
    assert_equal 4, gj.teams.count
    
    sti = GroupStanding.create!( group_id: gi.id )
    stj = GroupStanding.create!( group_id: gj.id )

    assert_equal 4, GroupStanding.count
    assert_equal 0, sti.entries.count
    assert_equal 0, stj.entries.count

  end # test_group_standings


end # class TestStandings
