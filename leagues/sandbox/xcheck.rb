###
##  to run use:
##    $ ruby sandbox/xcheck.rb


require 'cocos'


recs = read_csv( './config/leagues.csv' )
puts "   #{recs.size} record(s)"

leagues = {}
recs.each do |rec|
  key    = rec['code']
  season = "#{rec['start_season']}-#{rec['end_season']}"

  keyplus =  season != '-' ? "#{key}+#{season}" : key
  leagues[ keyplus ] = rec
end
pp leagues





names = ['leagues_america',
         'leagues_europe',
         'leagues_world']

recs = []

names.each do |name|
  path = "./config_v0/#{name}.csv"
  recs += read_csv( path )
end
puts "   #{recs.size} record(s)"
#=>  130 record(s)


## try to cross check
recs.each do |rec|
  key    = rec['key']
  season = "#{rec['start_season']}-#{rec['end_season']}"

  keyplus =  season != '-' ? "#{key}+#{season}" : key


  newrec = leagues[keyplus]
  if newrec.nil?
    puts "!! ERROR - no record found for #{keyplus}"
    exit 1
  end

  if newrec['basename'] != rec['basename']
     puts "!! #{keyplus}  - basename differ"
     puts "  old #{rec['basename']}"
     puts "  new #{newrec['basename']}"
  end
end


puts
puts "---"
recs.each do |rec|
  key    = rec['key']
  season = "#{rec['start_season']}-#{rec['end_season']}"

  keyplus =  season != '-' ? "#{key}+#{season}" : key


  newrec = leagues[keyplus]
  puts  "#{newrec['name']}    --   #{keyplus}"
end


puts "bye"