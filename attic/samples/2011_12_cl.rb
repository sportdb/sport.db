# encoding: utf-8

# note: timezone for games (play_at) is *always* CET (central european time)

#################################
## Champions League 2011/12

cl = Event.create!( league:   League.find_by_key!('cl'),
                    season:   Season.find_by_key!('2011/12'),
                    start_at: Time.cet( '2011-10-10 17:00' ),
                    team3: false )


inter     = Team.find_by_key!( 'inter' )
marseille = Team.find_by_key!( 'marseille' )
bayern    = Team.find_by_key!( 'bayern' )
basel     = Team.find_by_key!( 'basel' )

chelsea   = Team.find_by_key!( 'chelsea' )
napoli    = Team.find_by_key!( 'napoli' )
madrid    = Team.find_by_key!( 'madrid' )
moskva    = Team.find_by_key!( 'moskva' )

milan     = Team.find_by_key!( 'milan' )
benfica   = Team.find_by_key!( 'benfica' )
barcelona = Team.find_by_key!( 'barcelona' )
apoel     = Team.find_by_key!( 'apoel' )

cl.teams << milan
cl.teams << benfica
cl.teams << barcelona
cl.teams << apoel

cl.teams << chelsea
cl.teams << madrid
cl.teams << marseille
cl.teams << bayern


cl16   = Round.create!( event: cl, pos: 1, title: 'Achtelfinale',             start_at: Time.cet( '2012-02-21' ), title2: 'Di+Mi 21.+22. Feb 2012' )
cl16_2 = Round.create!( event: cl, pos: 2, title: 'Achtelfinale Rückspiele',  start_at: Time.cet( '2012-03-13' ), title2: 'Di+Mi 13.+14. März 2012' )
cl8    = Round.create!( event: cl, pos: 3, title: 'Viertelfinale',            start_at: Time.cet( '2012-03-27' ), title2: 'Di+Mi 27.+28. März 2012' )
cl8_2  = Round.create!( event: cl, pos: 4, title: 'Viertelfinale Rückspiele', start_at: Time.cet( '2012-04-03' ), title2: 'Di+Mi 3.+4. April 2012' )
cl4    = Round.create!( event: cl, pos: 5, title: 'Halbfinale',               start_at: Time.cet( '2012-04-17' ), title2: 'Di+Mi 17.+18. April 2012' )
cl4_2  = Round.create!( event: cl, pos: 6, title: 'Halbfinale Rückspiele',    start_at: Time.cet( '2012-04-24' ), title2: 'Di+Mi 24.+25. April 2012' )
cl1    = Round.create!( event: cl, pos: 7, title: 'Finale',                   start_at: Time.cet( '2012-05-19' ), title2: 'Sa 19. Mai 2012' )


games_cl16 = [
  [[ 1, napoli,    [3, 1],       chelsea,   Time.cet('2012-02-21 20:45') ],
   [ 3, chelsea,   [3, 1, 4, 1], napoli,    Time.cet('2012-03-14 20:45') ]],
  [[ 2, moskva,    [1, 1],       madrid,    Time.cet('2012-02-21 20:45') ],
   [ 4, madrid,    [4, 1],       moskva,    Time.cet('2012-03-14 20:45') ]],
  [[ 3, marseille, [1, 0],       inter,     Time.cet('2012-02-22 20:45') ],
   [ 1, inter,     [2, 1],       marseille, Time.cet('2012-03-13 20:45') ]],
  [[ 4, basel,     [1, 0],       bayern,    Time.cet('2012-02-22 20:45') ],
   [ 2, bayern,    [7, 0],       basel,     Time.cet('2012-03-13 20:45') ]] 
]

games_cl8 = [
  [[ 1, apoel,       [0, 3], madrid,    Time.cet('2012-03-27 20:45') ],
   [ 4, madrid,      [5, 2], apoel,     Time.cet('2012-04-04 20:45') ]],
  [[ 2, benfica,     [0, 1], chelsea,   Time.cet('2012-03-27 20:45') ],
   [ 3, chelsea,     [2, 1], benfica,   Time.cet('2012-04-04 20:45') ]],
  [[ 3, marseille,   [0, 2], bayern,    Time.cet('2012-03-28 20:45') ],
   [ 2, bayern,      [2, 0], marseille, Time.cet('2012-04-03 20:45') ]],
  [[ 4, milan,       [0, 0], barcelona, Time.cet('2012-03-28 20:45') ],
   [ 1, barcelona,   [3, 1], milan,     Time.cet('2012-04-03 20:45') ]]
]

games_cl4 = [
  [[ 1, bayern,      [2, 1],             madrid,     Time.cet('2012-04-17 20:45') ],
   [ 2, madrid,      [2, 1, 2, 1, 3, 4], bayern,     Time.cet('2012-04-25 20:45') ]],
  [[ 2, chelsea,     [1, 0],             barcelona,  Time.cet('2012-04-18 20:45') ],
   [ 1, barcelona ,  [2, 2],             chelsea,    Time.cet('2012-04-24 20:45') ]]
]

games_cl1 = [
  [ 1, bayern,      [1,1,1,1,3,4], chelsea,     Time.cet('2012-05-19 20:45') ]]


Game.create_knockout_pairs_from_ary!( games_cl16, cl16, cl16_2 )
Game.create_knockout_pairs_from_ary!( games_cl8,  cl8,  cl8_2  )
Game.create_knockout_pairs_from_ary!( games_cl4,  cl4,  cl4_2  )
Game.create_knockouts_from_ary!( games_cl1,  cl1 )

