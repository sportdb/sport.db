# encoding: utf-8

chelsea   = Team.find_by_key!( 'chelsea' )
barcelona = Team.find_by_key!( 'barcelona' )
inter     = Team.find_by_key!( 'inter' )
manunited = Team.find_by_key!( 'manunited' )

atletico  = Team.find_by_key!( 'atletico' )
porto     = Team.find_by_key!( 'porto' )
donezk    = Team.find_by_key!( 'donezk' )
zenit     = Team.find_by_key!( 'zenit' )


Badge.create!( team: chelsea,
               title: 'Winner',  # use Champion??
               league: League.find_by_key!('cl'),
               season: Season.find_by_key!('2011/12') )

Badge.create!( team: barcelona,
               title: 'Winner',
               league: League.find_by_key!('cl'),
               season: Season.find_by_key!('2010/11') )

Badge.create!( team: inter,
               title: 'Winner',
               league: League.find_by_key!('cl'),
               season: Season.find_by_key!('2009/10') )

Badge.create!( team: barcelona,
               title: 'Winner',
               league: League.find_by_key!('cl'),
               season: Season.find_by_key!('2008/09') )

Badge.create!( team: manunited,
               title: 'Winner',
               league: League.find_by_key!('cl'),
               season: Season.find_by_key!('2007/08') )


Badge.create!( team: atletico,
               title: 'Winner',
               league: League.find_by_key!('el'),
               season: Season.find_by_key!('2011/12') )

Badge.create!( team: porto,
               title: 'Winner',
               league: League.find_by_key!('el'),
               season: Season.find_by_key!('2010/11') )

Badge.create!( team: atletico,
               title: 'Winner',
               league: League.find_by_key!('el'),
               season: Season.find_by_key!('2009/10') )

Badge.create!( team: donezk,
               title: 'Winner',
               league: League.find_by_key!('el'),
               season: Season.find_by_key!('2008/09') )

Badge.create!( team: zenit,
               title: 'Winner',
               league: League.find_by_key!('el'),
               season: Season.find_by_key!('2007/08') )

