$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))


require 'sportdb/formats'
require 'sportdb/catalogs'


path = '../../../openfootball/leagues'
pack = SportDb::Package.new( path )   ## lets us use direcotry or zip archive

recs = []
pack.each_seasons do |entry|
    recs += SportDb::Import::EventInfoReader.parse( entry.read )
end

pp recs



puts "bye"