# encoding: utf-8

#################################
# Champions League 2012/13

# note: timezone for games (play_at) is *always* CET (central european time)

cl = Event.create!( league:   League.find_by_key!('cl'),
                    season:   Season.find_by_key!('2012/13'),
                    start_at: Time.cet( '2012-09-18 18:30' ),
                    team3: false )

porto         = Team.find_by_key!( 'porto' )
kiew          = Team.find_by_key!( 'kiew' )
paris         = Team.find_by_key!( 'paris' )
zagreb        = Team.find_by_key!( 'zagreb' )

arsenal       = Team.find_by_key!( 'arsenal' )
schalke       = Team.find_by_key!( 'schalke' )
olympiacos    = Team.find_by_key!( 'olympiacos' )
montpellier   = Team.find_by_key!( 'montpellier' )

milan         = Team.find_by_key!( 'milan' )
zenit         = Team.find_by_key!( 'zenit' )
anderlecht    = Team.find_by_key!( 'anderlecht' )
malaga        = Team.find_by_key!( 'malaga' )

madrid        = Team.find_by_key!( 'madrid' )
mancity       = Team.find_by_key!( 'mancity' )
ajax          = Team.find_by_key!( 'ajax' )
dortmund      = Team.find_by_key!( 'dortmund' )

chelsea       = Team.find_by_key!( 'chelsea' )
donezk        = Team.find_by_key!( 'donezk' )
juventus      = Team.find_by_key!( 'juventus' )
nordsjalland  = Team.find_by_key!( 'nordsjalland' )

bayern        = Team.find_by_key!( 'bayern' )
valencia      = Team.find_by_key!( 'valencia' )
lille         = Team.find_by_key!( 'lille' )
borissow      = Team.find_by_key!( 'borissow' )

barcelona     = Team.find_by_key!( 'barcelona' )
benfica       = Team.find_by_key!( 'benfica' )
spartak       = Team.find_by_key!( 'spartak' )
celtic        = Team.find_by_key!( 'celtic' )

manunited     = Team.find_by_key!( 'manunited' )
braga         = Team.find_by_key!( 'braga' )
galatasaray   = Team.find_by_key!( 'galatasaray' )
cluj          = Team.find_by_key!( 'cluj' )



cl.teams << porto
cl.teams << kiew
cl.teams << paris
cl.teams << zagreb

cl.teams << arsenal
cl.teams << schalke
cl.teams << olympiacos
cl.teams << montpellier

cl.teams << milan
cl.teams << zenit
cl.teams << anderlecht
cl.teams << malaga

cl.teams << madrid
cl.teams << mancity
cl.teams << ajax
cl.teams << dortmund

cl.teams << chelsea
cl.teams << donezk
cl.teams << juventus
cl.teams << nordsjalland

cl.teams << bayern
cl.teams << valencia
cl.teams << lille
cl.teams << borissow

cl.teams << barcelona
cl.teams << benfica
cl.teams << spartak
cl.teams << celtic

cl.teams << manunited
cl.teams << braga
cl.teams << galatasaray
cl.teams << cluj


cla = Group.create!( event: cl, pos: 1, title: 'Gruppe A' )
clb = Group.create!( event: cl, pos: 2, title: 'Gruppe B' )
clc = Group.create!( event: cl, pos: 3, title: 'Gruppe C' )
cld = Group.create!( event: cl, pos: 4, title: 'Gruppe D' )
cle = Group.create!( event: cl, pos: 5, title: 'Gruppe E' )
clf = Group.create!( event: cl, pos: 6, title: 'Gruppe F' )
clg = Group.create!( event: cl, pos: 7, title: 'Gruppe G' )
clh = Group.create!( event: cl, pos: 8, title: 'Gruppe H' )

#################################
# Gruppe A

cla.teams << porto
cla.teams << kiew
cla.teams << paris
cla.teams << zagreb


#################################
# Gruppe B

clb.teams << arsenal
clb.teams << schalke
clb.teams << olympiacos
clb.teams << montpellier


#################################
# Gruppe C

clc.teams << milan
clc.teams << zenit
clc.teams << anderlecht
clc.teams << malaga

#################################
# Gruppe D

cld.teams << madrid
cld.teams << mancity
cld.teams << ajax
cld.teams << dortmund


#################################
# Gruppe E

cle.teams << chelsea
cle.teams << donezk
cle.teams << juventus
cle.teams << nordsjalland


#################################
# Gruppe F

clf.teams << bayern
clf.teams << valencia
clf.teams << lille
clf.teams << borissow


#################################
# Gruppe G

clg.teams << barcelona
clg.teams << benfica
clg.teams << spartak
clg.teams << celtic


#################################
# Gruppe H

clh.teams << manunited
clh.teams << braga
clh.teams << galatasaray
clh.teams << cluj


clr1   = Round.create!( event: cl, pos: 1, title: 'Spieltag 1', start_at: Time.cet( '2012-09-18' ), title2: 'Di./Mi., 18.+19. Sep 2012' )
clr2   = Round.create!( event: cl, pos: 2, title: 'Spieltag 2', start_at: Time.cet( '2012-10-02' ), title2: 'Di./Mi., 2.+3. Okt 2012' )
clr3   = Round.create!( event: cl, pos: 3, title: 'Spieltag 3', start_at: Time.cet( '2012-10-23' ), title2: 'Di./Mi., 23.+24. Okt 2012' )
clr4   = Round.create!( event: cl, pos: 4, title: 'Spieltag 4', start_at: Time.cet( '2012-11-06' ), title2: 'Di./Mi., 6.+7. Nov 2012' )
clr5   = Round.create!( event: cl, pos: 5, title: 'Spieltag 5', start_at: Time.cet( '2012-11-20' ), title2: 'Di./Mi., 20.+21. Nov 2012' )
clr6   = Round.create!( event: cl, pos: 6, title: 'Spieltag 6', start_at: Time.cet( '2012-12-04' ), title2: 'Di./Mi., 4.+5. Dez 2012' )

cl16   = Round.create!( event: cl, pos: 7, title: 'Achtelfinale',              start_at: Time.cet( '2013-02-12' ), title2: 'Di./Mi., 12.+13./19.+20. Feb 2013' )
cl16_2 = Round.create!( event: cl, pos: 8, title: 'Achtelfinale Rückspiele',   start_at: Time.cet( '2013-03-05' ), title2: 'Di./Mi., 5.+6./12.+13. Mär 2013' )
cl8    = Round.create!( event: cl, pos: 9, title: 'Viertelfinale',             start_at: Time.cet( '2013-04-02' ), title2: 'Di./Mi., 2.+3. Apr 2013' )
cl8_2  = Round.create!( event: cl, pos: 10, title: 'Viertelfinale Rückspiele', start_at: Time.cet( '2013-04-09' ), title2: 'Di./Mi., 9.+10. Apr 2013' )
cl4    = Round.create!( event: cl, pos: 11, title: 'Halbfinale',               start_at: Time.cet( '2013-04-23' ), title2: 'Di./Mi., 23.+24. Apr 2013' )
cl4_2  = Round.create!( event: cl, pos: 12, title: 'Halbfinale Rückspiele',    start_at: Time.cet( '2013-04-30' ), title2: 'Di./Mi., 30. Apr/1. Mai 2013' )
cl1    = Round.create!( event: cl, pos: 13, title: 'Finale',                   start_at: Time.cet( '2013-05-25' ), title2: 'Sa. 25. Mai 2013' )


games_cla = [
  [[ 1, zagreb, [0,2], porto,  Time.cet('2012-09-18 20:45'), clr1 ],
   [ 2, porto,  [3,0], zagreb, Time.cet('2012-11-21 20:45'), clr5 ]],
  [[ 2, paris,  [4,1], kiew,   Time.cet('2012-09-18 20:45'), clr1 ],
   [ 1, kiew,   [0,2], paris,  Time.cet('2012-11-21 20:45'), clr5 ]],
  [[ 1, kiew,   [2,0], zagreb, Time.cet('2012-10-03 20:45'), clr2 ],
   [ 2, zagreb, [1,1], kiew,   Time.cet('2012-12-04 20:45'), clr6 ]],
  [[ 2, porto,  [1,0], paris,  Time.cet('2012-10-03 20:45'), clr2 ],
   [ 1, paris,  [2,1], porto,  Time.cet('2012-12-04 20:45'), clr6 ]],
  [[ 1, porto,  [3,2], kiew,   Time.cet('2012-10-24 20:45'), clr3 ],
   [ 1, kiew,   [0,0], porto,  Time.cet('2012-11-06 20:45'), clr4 ]],
  [[ 2, zagreb, [0,2], paris,  Time.cet('2012-10-24 20:45'), clr3 ],
   [ 2, paris,  [4,0], zagreb, Time.cet('2012-11-06 20:45'), clr4 ]]
]

games_clb = [
  [[ 3, montpellier, [1,2], arsenal,     Time.cet('2012-09-18 20:45'), clr1 ],
   [ 4, arsenal,     [2,0], montpellier, Time.cet('2012-11-21 20:45'), clr5 ]],
  [[ 4, olympiacos,  [1,2], schalke,     Time.cet('2012-09-18 20:45'), clr1 ],
   [ 3, schalke,     [1,0], olympiacos,  Time.cet('2012-11-21 20:45'), clr5 ]],
  [[ 3, arsenal,     [3,1], olympiacos,  Time.cet('2012-10-03 20:45'), clr2 ],
   [ 3, olympiacos,  [2,1], arsenal,     Time.cet('2012-12-04 20:45'), clr6 ]],
  [[ 4, schalke,     [2,2], montpellier, Time.cet('2012-10-03 20:45'), clr2 ],
   [ 4, montpellier, [1,1], schalke,     Time.cet('2012-12-04 20:45'), clr6 ]],
  [[ 3, arsenal,     [0,2], schalke,     Time.cet('2012-10-24 20:45'), clr3 ],
   [ 3, schalke,     [2,2], arsenal,     Time.cet('2012-11-06 20:45'), clr4 ]],
  [[ 4, montpellier, [1,2], olympiacos,  Time.cet('2012-10-24 20:45'), clr3 ],
   [ 4, olympiacos,  [3,1], montpellier, Time.cet('2012-11-06 20:45'), clr4 ]]
]

games_clc = [
  [[ 5, malaga,     [3,0], zenit,      Time.cet('2012-09-18 20:45'), clr1 ],
   [ 5, zenit,      [2,2], malaga,     Time.cet('2012-11-21 18:00'), clr5 ]],
  [[ 6, milan,      [0,0], anderlecht, Time.cet('2012-09-18 20:45'), clr1 ],
   [ 6, anderlecht, [1,3], milan,      Time.cet('2012-11-21 20:45'), clr5 ]],
  [[ 5, zenit,      [2,3], milan,      Time.cet('2012-10-03 18:00'), clr2 ],
   [ 5, milan,      [0,1], zenit,      Time.cet('2012-12-04 20:45'), clr6 ]],
  [[ 6, anderlecht, [0,3], malaga,     Time.cet('2012-10-03 20:45'), clr2 ],
   [ 6, malaga,     [2,2], anderlecht, Time.cet('2012-12-04 20:45'), clr6 ]],
  [[ 5, zenit,      [1,0], anderlecht, Time.cet('2012-10-24 18:00'), clr3 ],
   [ 5, anderlecht, [1,0], zenit,      Time.cet('2012-11-06 20:45'), clr4 ]],
  [[ 6, malaga,     [1,0], milan,      Time.cet('2012-10-24 20:45'), clr3 ],
   [ 6, milan,      [1,1], malaga,     Time.cet('2012-11-06 20:45'), clr4 ]]
]

games_cld = [
  [[ 7, madrid,   [3,2], mancity,  Time.cet('2012-09-18 20:45'), clr1 ],
   [ 7, mancity,  [1,1], madrid,   Time.cet('2012-11-21 20:45'), clr5 ]],
  [[ 8, dortmund, [1,0], ajax,     Time.cet('2012-09-18 20:45'), clr1 ],
   [ 8, ajax,     [1,4], dortmund, Time.cet('2012-11-21 20:45'), clr5 ]],
  [[ 7, ajax,     [1,4], madrid,   Time.cet('2012-10-03 20:45'), clr2 ],
   [ 8, madrid,   [4,1], ajax,     Time.cet('2012-12-04 20:45'), clr6 ]],
  [[ 8, mancity,  [1,1], dortmund, Time.cet('2012-10-03 20:45'), clr2 ],
   [ 7, dortmund, [1,0], mancity,  Time.cet('2012-12-04 20:45'), clr6 ]],
  [[ 7, dortmund, [2,1], madrid,   Time.cet('2012-10-24 20:45'), clr3 ],
   [ 8, madrid,   [2,2], dortmund, Time.cet('2012-11-06 20:45'), clr4 ]],
  [[ 8, ajax,     [3,1], mancity,  Time.cet('2012-10-24 20:45'), clr3 ],
   [ 7, mancity,  [2,2], ajax,     Time.cet('2012-11-06 20:45'), clr4 ]]
]


games_cle = [
  [[ 9,  chelsea,      [2,2], juventus,     Time.cet('2012-09-19 20:45'), clr1 ],
   [ 9,  juventus,     [3,0], chelsea,      Time.cet('2012-11-20 20:45'), clr5 ]],
  [[ 10, donezk,       [2,0], nordsjalland, Time.cet('2012-09-19 20:45'), clr1 ],
   [ 10, nordsjalland, [2,5], donezk,       Time.cet('2012-11-20 20:45'), clr5 ]],
  [[ 9,  nordsjalland, [0,4], chelsea,      Time.cet('2012-10-02 20:45'), clr2 ],
   [ 9,  chelsea,      [6,1], nordsjalland, Time.cet('2012-12-05 20:45'), clr6 ]],
  [[ 10, juventus,     [1,1], donezk,       Time.cet('2012-10-02 20:45'), clr2 ],
   [ 10, donezk,       [0,1], juventus,     Time.cet('2012-12-05 20:45'), clr6 ]],
  [[ 9,  donezk,       [2,1], chelsea,      Time.cet('2012-10-23 20:45'), clr3 ],
   [ 9,  chelsea,      [3,2], donezk,       Time.cet('2012-11-07 20:45'), clr4 ]],
  [[ 10, nordsjalland, [1,1], juventus,     Time.cet('2012-10-23 20:45'), clr3 ],
   [ 10, juventus,     [4,0], nordsjalland, Time.cet('2012-11-07 20:45'), clr4 ]]
]

games_clf = [
  [[ 11, bayern,   [2,1], valencia, Time.cet('2012-09-19 20:45'), clr1 ],
   [ 11, valencia, [1,1], bayern,   Time.cet('2012-11-20 20:45'), clr5 ]],
  [[ 12, lille,    [1,3], borissow, Time.cet('2012-09-19 20:45'), clr1 ],
   [ 12, borissow, [0,2], lille,    Time.cet('2012-11-20 20:45'), clr5 ]],
  [[ 11, borissow, [3,1], bayern,   Time.cet('2012-10-02 20:45'), clr2 ],
   [ 12, bayern,   [4,1], borissow, Time.cet('2012-12-05 20:45'), clr6 ]],
  [[ 12, valencia, [2,0], lille,    Time.cet('2012-10-02 20:45'), clr2 ],
   [ 11, lille,    [0,1], valencia, Time.cet('2012-12-05 20:45'), clr6 ]],
  [[ 11, lille,    [0,1], bayern,   Time.cet('2012-10-23 20:45'), clr3 ],
   [ 11, bayern,   [6,1], lille,    Time.cet('2012-11-07 20:45'), clr4 ]],
  [[ 12, borissow, [0,3], valencia, Time.cet('2012-10-23 20:45'), clr3 ],
   [ 12, valencia, [4,2], borissow, Time.cet('2012-11-07 20:45'), clr4 ]]
]

games_clg = [
  [[ 13, celtic,    [0,0], benfica,   Time.cet('2012-09-19 20:45'), clr1 ],
   [ 14, benfica,   [2,1], celtic,    Time.cet('2012-11-20 20:45'), clr5 ]],
  [[ 14, barcelona, [3,2], spartak,   Time.cet('2012-09-19 20:45'), clr1 ],
   [ 13, spartak,   [0,3], barcelona, Time.cet('2012-11-20 18:00'), clr5 ]],
  [[ 13, spartak,   [2,3], celtic,    Time.cet('2012-10-02 18:00'), clr2 ],
   [ 14, celtic,    [2,1], spartak,   Time.cet('2012-12-05 20:45'), clr6 ]],
  [[ 14, benfica,   [0,2], barcelona, Time.cet('2012-10-02 20:45'), clr2 ],
   [ 13, barcelona, [0,0], benfica,   Time.cet('2012-12-05 20:45'), clr6 ]],
  [[ 13, spartak,   [2,1], benfica,   Time.cet('2012-10-23 18:00'), clr3 ],
   [ 14, benfica,   [2,0], spartak,   Time.cet('2012-11-07 20:45'), clr4 ]],
  [[ 14, barcelona, [2,1], celtic,    Time.cet('2012-10-23 20:45'), clr3 ],
   [ 13, celtic,    [2,1], barcelona, Time.cet('2012-11-07 20:45'), clr4 ]]
]

games_clh = [
  [[ 15, manunited,   [1,0], galatasaray, Time.cet('2012-09-19 20:45'), clr1 ],
   [ 15, galatasaray, [1,0], manunited,   Time.cet('2012-11-20 20:45'), clr5 ]],
  [[ 16, braga,       [0,2], cluj,        Time.cet('2012-09-19 20:45'), clr1 ],
   [ 16, cluj,        [3,1], braga,       Time.cet('2012-11-20 20:45'), clr5 ]],
  [[ 15, cluj,        [1,2], manunited,   Time.cet('2012-10-02 20:45'), clr2 ],
   [ 16, manunited,   [0,1], cluj,        Time.cet('2012-12-05 20:45'), clr6 ]],
  [[ 16, galatasaray, [0,2], braga,       Time.cet('2012-10-02 20:45'), clr2 ],
   [ 15, braga,       [1,2], galatasaray, Time.cet('2012-12-05 20:45'), clr6 ]],
  [[ 15, manunited,   [3,2], braga,       Time.cet('2012-10-23 20:45'), clr3 ],
   [ 15, braga,       [1,3], manunited,   Time.cet('2012-11-07 20:45'), clr4 ]],
  [[ 16, galatasaray, [1,1], cluj,        Time.cet('2012-10-23 20:45'), clr3 ],
   [ 16, cluj,        [1,3], galatasaray, Time.cet('2012-11-07 20:45'), clr4 ]]
]

Game.create_pairs_from_ary_for_group!( games_cla, cla )
Game.create_pairs_from_ary_for_group!( games_clb, clb )
Game.create_pairs_from_ary_for_group!( games_clc, clc )
Game.create_pairs_from_ary_for_group!( games_cld, cld )
Game.create_pairs_from_ary_for_group!( games_cle, cle )
Game.create_pairs_from_ary_for_group!( games_clf, clf )
Game.create_pairs_from_ary_for_group!( games_clg, clg )
Game.create_pairs_from_ary_for_group!( games_clh, clh )

