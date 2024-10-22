########
## run / test sample for debugging; use
#    ruby script/read_wfb.rb


require_relative 'boot'


File.delete( './wfb.db' )   if File.exist?( './wfb.db' )


SportDb.open( './wfb.db' )


WFB_PATH   = "../../../cache.wfb.txt"


## add for debugging
# SportDb::MatchReader.read( "#{WFB_PATH}/archive/1870s/1871-72/eng.cup.txt" )
# SportDb::MatchReader.read( "#{WFB_PATH}/archive/1880s/1888-89/eng.1.txt" )

# SportDb::MatchReader.read( "#{WFB_PATH}/2023/concacaf.cl.txt" )
# SportDb::MatchReader.read( "#{WFB_PATH}/2023/copa.l.txt" )
# SportDb::MatchReader.read( "#{WFB_PATH}/2023/uy.1.txt" )
# SportDb::MatchReader.read( "#{WFB_PATH}/2023/sco.1.txt" )

# SportDb::MatchReader.read( "#{WFB_PATH}/2023-24/mx.1.txt" )
# SportDb::MatchReader.read( "#{WFB_PATH}/2023-24/mx.2.expansion.txt" )
# SportDb::MatchReader.read( "#{WFB_PATH}/2023-24/mx.3.a.txt" )
# SportDb::MatchReader.read( "#{WFB_PATH}/2023-24/mx.3.b.txt" )


# path = WFB_PATH
# pack = SportDb::Package.new( path )
# pack.read_match

paths = SportDb::Parser::Opts.find( WFB_PATH )
pp paths

paths.each_with_index do |path, i|
  puts "==> #{i+1}/#{paths.size} #{path}..."
  SportDb::MatchReader.read( path )
end


puts "table stats:"
SportDb.tables

puts 'bye'
