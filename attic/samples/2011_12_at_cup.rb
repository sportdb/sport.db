# encoding: utf-8

# note: timezone for games (play_at) is *always* CET (central european time)


##################################
### ÖFB Cup 2011/12

ofb = Event.create!( league:   League.find_by_key!('at.cup'),
                     season:   Season.find_by_key!('2011/12'),
                     start_at: Time.cet( '2011-10-10 17:00' ),
                     team3: false )  # no game for 3rd/4th place


sturm       = Team.find_by_key!( 'sturm' )
ried        = Team.find_by_key!( 'ried' )
salzburg    = Team.find_by_key!( 'salzburg' )
austria     = Team.find_by_key!( 'austria' )
rapid       = Team.find_by_key!( 'rapid' )
innsbruck   = Team.find_by_key!( 'innsbruck' )
wrneustadt  = Team.find_by_key!( 'wrneustadt')
ksv         = Team.find_by_key!( 'ksv' )
mattersburg = Team.find_by_key!( 'mattersburg' )
admira      = Team.find_by_key!( 'admira' )


hartberg    = Team.find_by_key!( 'hartberg' )
groedig     = Team.find_by_key!( 'groedig' )
juniors     = Team.find_by_key!( 'juniors' )
austrial    = Team.find_by_key!( 'austrial' )

ofb.teams << sturm
ofb.teams << hartberg
ofb.teams << groedig
ofb.teams << ried
ofb.teams << salzburg
ofb.teams << juniors
ofb.teams << austrial
ofb.teams << austria

ofb8    = Round.create!( event: ofb, pos: 1, title: 'Viertelfinale', start_at: Time.cet( '2012-04-10' ), title2: 'Di+Mi 10.+11. April 2012' )
ofb4    = Round.create!( event: ofb, pos: 2, title: 'Halbfinale',    start_at: Time.cet( '2012-05-01' ), title2: 'Di+Mi 1.+2. Mai 2012' )
ofb1    = Round.create!( event: ofb, pos: 3, title: 'Finale',        start_at: Time.cet( '2012-05-20' ), title2: 'So 20. Mai 2012' )

games_ofb8 = [
  [ groedig,   [2, 3],       ried,     Time.cet('2012-04-10 18:00') ],
  [ austrial,  [1, 2],       austria,  Time.cet('2012-04-11 18:00') ],
  [ sturm,     [2, 2, 2, 4], hartberg, Time.cet('2012-04-11 19:00') ],
  [ salzburg,  [4, 1],       juniors,  Time.cet('2012-04-11 19:00') ]
]

games_ofb4 = [
  [ hartberg,  [0, 1], salzburg, Time.cet('2012-05-01 18:00') ],
  [ ried,      [2, 0], austria,  Time.cet('2012-05-02 20:30') ]
]

games_ofb1 = [
  [ salzburg, [3,0], ried, Time.cet('2012-05-20 16:00') ]
]

Game.create_knockouts_from_ary!( games_ofb8, ofb8 )
Game.create_knockouts_from_ary!( games_ofb4, ofb4 )
Game.create_knockouts_from_ary!( games_ofb1, ofb1 )
