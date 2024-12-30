## note: use the local version of fifa gem
$LOAD_PATH.unshift( File.expand_path( '../sport.db/sportdb-structs/lib'))
$LOAD_PATH.unshift( File.expand_path( './lib'))
require 'fifa'
require 'cocos'


recs = read_csv( './script/codes.csv' )
pp recs




include SportDb::NameHelper

recs.each do |rec|
   country = Fifa[ rec['code'] ]
   if country.nil?
     puts "** !!! ERROR !!! no record found for code >#{rec['code']}<:"
     pp rec
     exit 1
   else
     print "."

     ## also check that codes match (not only via alt code!!)
     if rec['code'] != country.code
        puts "** !!! WARN - canonicial codes do NOT match"
        pp rec
        pp country
     end

     ## check country name too
     names = country.names
     names = names.map { |name| strip_year( name ) }

     if !names.include?( rec['country'] )
       puts "** !!! ERROR !!! no matching country name for:"
       pp rec
       pp names
       pp country
       exit 1
     end
   end
end

puts "#{recs.size} OK"
