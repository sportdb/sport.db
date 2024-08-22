########
## run / test sample from readme; use
#    ruby -I ./lib script/readme.rb


require_relative 'boot'


File.delete( './test.db' )   if File.exist?( './test.db' )


SportDb.open( './test.db' )

# SportDb.connect( adapter:  'sqlite3',
#                  database: './test.db' )
# SportDb.create_all   ## build schema


ENGLAND_PATH = "#{OPENFOOTBALL_PATH}/england"


SportDb::MatchReader.read( "#{ENGLAND_PATH}/2015-16/1-premierleague.txt" )

## let's try another season
SportDb::MatchReader.read( "#{ENGLAND_PATH}/2019-20/1-premierleague.txt" )



## add for debugging
SportDb::MatchReader.read( "#{ENGLAND_PATH}/2015-16/2-championship.txt" )



include SportDb::Models

## turn on logging to console
ActiveRecord::Base.logger = Logger.new(STDOUT)


## pp League.all
##
epl_key = 'eng_premierleague'



# pl_2015_16 = Event.find_by( key: 'eng.1.2015/16' )
pl_2015_16 = Event.find_by( key: "#{epl_key}.2015/16" )
p pl_2015_16.teams.count
p pl_2015_16.matches.count

# pl_2019_20 = Event.find_by( key: 'eng.1.2019/20' )
pl_2019_20 = Event.find_by( key: "#{epl_key}.2019/20" )
p pl_2015_16.teams.count
p pl_2015_16.matches.count

# -or-

pl = League.find_by( key: epl_key )
p pl.seasons.count

puts 'bye'
