## note: use the local version of fifa gem
$LOAD_PATH.unshift( File.expand_path( './lib'))
require 'fifa'


## todo/fix: add country dependency info e.g. England < UK  etc.


## build a summary page
countries = Fifa.countries
countries = countries.sort_by {|country| country.name }

buf = String.new
buf << "# Countries A-Z (#{countries.size})\n\n"
buf << "| Name   | Code  |     |\n"
buf << "|--------|-------|-----|\n"
countries.each do |country|
  buf << "| #{country.name} | #{country.fifa } | #{country.tags.join( ' › ' )} |\n"
end

puts buf

File.open( './SUMMARY.md', 'w:utf-8') do |f|
  f.write( buf )
end
