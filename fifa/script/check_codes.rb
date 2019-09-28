## note: use the local version of fifa gem
$LOAD_PATH.unshift( File.expand_path( './lib'))
require 'fifa'


recs = read_csv( './script/codes.csv' )
pp recs


def strip_lang( name )  SportDb::Import::Country.strip_lang( name ); end
def normalize( name )   SportDb::Import::Country.normalize( name ); end


recs.each do |rec|
   country = Fifa[ rec[:code] ]
   if country.nil?
     puts "** !!! ERROR !!! no code found for:"
     pp rec
     exit 1
   else
     print "."

     ## check country name too
     names = [country.name]+country.alt_names

     names = names.map do |name|   ## normalize
       name = strip_lang( name )
       name = normalize( name )
       name
     end

     if names.include?( normalize( rec[:country] )) == false
       puts "** !!! ERROR !!! no matching country name for:"
       pp rec
       pp country
       pp names
       pp normalize( rec[:country] )
       exit 1
     end
   end
end

puts "#{recs.size} OK"
