##########
# to run use:
#   $ ruby sandbox/read_leagues.rb

require 'cocos'
require 'season-formats'


require_relative '../lib/sportdb/writers/league_config'



leagues = SportDb::LeagueConfig.new
leagues.add( read_csv( './config/leagues_europe.csv' ))
pp leagues


seasons = [Season( '2024/25' ), Season( '1991/92' )]
keys = ['eng.1', 'de.1',
        :'eng.1', :'de.1']

seasons.each do |season|
  keys.each do |key|
   league  = leagues[key]
   pp league

   name     = league['name']
   basename = league['basename']
   pp name
   pp basename

   name     = league[:name]
   basename = league[:basename]
   pp name
   pp basename

   name     = name.call( season )     if name.is_a?( Proc )
   basename = basename.call( season)  if basename.is_a?( Proc)
   pp name
   pp basename
  end
end

puts "bye"