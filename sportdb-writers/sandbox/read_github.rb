##########
# to run use:
#   $ ruby sandbox/read_github.rb

require 'cocos'


require_relative '../lib/sportdb/writers/github_config'



repos = SportDb::GitHubConfig.new
repos.add( read_csv( './config/openfootball.csv' ))
pp repos


pp repos['at.1']
pp repos['at.3.o']
pp repos['at.cup']

pp repos['eng.3']
pp repos['eng.5']

puts "bye"