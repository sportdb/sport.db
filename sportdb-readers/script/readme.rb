########
## run / test sample from readme; use
#    ruby -I ./lib script/readme.rb


require_relative 'boot'


File.delete( './test.db' )   if File.exist?( './test.db' )


SportDb.connect( adapter:  'sqlite3',
                 database: './test.db' )
SportDb.create_all   ## build schema


ENGLAND_PATH = "#{OPENFOOTBALL_PATH}/england"


SportDb::MatchReader.read( "#{ENGLAND_PATH}/2015-16/1-premierleague-i.txt" )
SportDb::MatchReader.read( "#{ENGLAND_PATH}/2015-16/1-premierleague-ii.txt" )

## let's try another season
SportDb::MatchReader.read( "#{ENGLAND_PATH}/2019-20/1-premierleague.txt" )



include SportDb::Models

## turn on logging to console
ActiveRecord::Base.logger = Logger.new(STDOUT)

pl_2015_16 = Event.find_by( key: 'eng.1.2015/16' )
p pl_2015_16.teams.count
p pl_2015_16.games.count

pl_2019_20 = Event.find_by( key: 'eng.1.2019/20' )
p pl_2015_16.teams.count
p pl_2015_16.games.count

# -or-

pl = League.find_by( key: 'eng.1' )
p pl.seasons.count

puts 'bye'
