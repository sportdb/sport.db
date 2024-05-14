$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))

require 'sportdb/catalogs'


puts 'version: ' + SportDb::Module::Catalogs.version
puts 'banner:  ' + SportDb::Module::Catalogs.banner
puts 'root:    ' + SportDb::Module::Catalogs.root



puts "bye"