##
#
#  read ro.clubs.txt

### note: make sure to load latest sportdb/structs !!!  (allow key with numbers!)
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))

## our own code
require 'sportdb/indexers'


## path = '../../../openfootball/clubs/europe/romania/ro.clubs.txt'
## path = '../../../openfootball/clubs/europe/croatia/hr.clubs.txt'
## path = '../../../openfootball/clubs/europe/faroe-islands/fo.clubs.txt'
path = '../../../openfootball/clubs/europe/finland/fi.clubs.txt'


datasets = Dir.glob( '../../../openfootball/clubs/**/*.clubs.txt' )
puts "  #{datasets.size} dataset(s)"



include SportDb::NameHelper
## incl. strip_year( name )
##       has_year?( name)
##       strip_lang( name )
##       normalize( name )

ERRORS = []

def check_clubs( path )

  basename = File.basename( path )
  puts "==> #{basename}..."
  recs = SportDb::Import::ClubReader.read(path)
  ## pp recs

recs.each do |rec|


      ## step 2) add all names (canonical name + alt names + alt names (auto))
      names = [rec.name] + rec.alt_names
      ## check "hand-typed" names for year (auto-add)
      ## check for year(s) e.g. (1887-1911), (-2013),
      ##                        (1946-2001,2013-) etc.
      more_names = []
      names.each do |name|
        if has_year?( name )
          more_names <<  strip_year( name )
        end
      end

      names += more_names


    ## check for uniq
    count      = names.size
    ## note - unaccent before uniq here!!!
    count_uniq = names.map {|name| unaccent(name) }.uniq.size
    if count != count_uniq
        puts

        buf = String.new
        buf << rec.inspect
        buf << "\n"
        buf <<  "** !!! ERROR !!! - #{count-count_uniq} duplicate name(s):"
        buf << "\n"
        names.each do |name|
          buf << '%-20s ' % name
          buf << '  '
          buf << '%-20s ' % unaccent(name)
          buf << "\n"
        end

        ERRORS << buf

        puts buf
    end
end
end


datasets.each do |path|
    check_clubs( path )
end


puts
pp ERRORS
puts "  #{ERRORS.size } error(s)"

puts "bye"
