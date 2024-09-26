##
#  use
#   $ ruby script/read_at.rb


require_relative 'boot'

File.delete( './at.db' )   if File.exist?( './at.db' )


SportDb.open( './at.db' )


## turn on logging to console
## ActiveRecord::Base.logger = Logger.new(STDOUT)


path = "#{OPENFOOTBALL_PATH}/austria"

pack = SportDb::Package.new( path )
pack.read_match

## pack.read
## pack.read( season: '2012/13' )


puts "table stats:"
SportDb.tables


puts 'bye'

__END__

## fix - duplicate match canceled and results e.g.

!! ERROR - match updates not yet supported (only inserts); sorry
#<Sports::Match:0x0000023c1d51b548
 @date="2014-03-25",
 @ground=nil,
 @group=nil,
 @num=nil,
 @round="Matchday 3",
 @score1=2,
 @score1agg=nil,
 @score1et=nil,
 @score1i=0,
 @score1p=nil,
 @score2=0,
 @score2agg=nil,
 @score2et=nil,
 @score2i=0,
 @score2p=nil,
 @status=nil,
 @team1=<Club: SV Stegersbach (AUT)>,
 @team2=<Club: FC Admira Wacker Mödling II (AUT)>,
 @time="19:00",
 @winner=1>
---
found match record:
#<SportDb::Model::Match:0x0000023c1dd6b7c0
 id: 2369,
 key: nil,
 event_id: 15,
 pos: 20,
 num: nil,
 team1_id: 72,
 team2_id: 95,
 round_id: 399,
 group_id: nil,
 stage_id: nil,
 team1_key: nil,
 team2_key: nil,
 event_key: nil,
 round_key: nil,
 round_num: nil,
 group_key: nil,
 stage_key: nil,
 date: Fri, 16 Aug 2013,
 time: "19:30",
 postponed: false,
 status: "cancelled",
 ground_id: nil,
 city_id: nil,
 home: true,
 knockout: false,
 score1: nil,
 score2: nil,
 score1et: nil,
 score2et: nil,
 score1p: nil,
 score2p: nil,
 score1i: nil,
 score2i: nil,
 score1ii: nil,
 score2ii: nil,
 next_match_id: nil,
 prev_match_id: nil,
 winner: nil,
 winner90: nil,
 comments: nil,
 created_at: 2024-09-26 13:05:41.073034 UTC,
 updated_at: 2024-09-26 13:05:41.073034 UTC>

