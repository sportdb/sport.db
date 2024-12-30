## note: use the local version of gems
$LOAD_PATH.unshift( File.expand_path( '../sport.db/sportdb-structs/lib'))
$LOAD_PATH.unshift( File.expand_path( './lib'))

require 'fifa'
require 'cocos'

## todo/fix: add country dependency info e.g. England < UK  etc.


## build a summary page
countries = Fifa.world.countries
countries = countries.sort_by {|country| country.name }

buf = String.new
buf << "# Countries A-Z (#{countries.size})\n\n"
buf << "| Name   | Codes | Tags | Alt. Names |\n"
buf << "|--------|-------|------|------------|\n"
countries.each do |country|
  buf << "| #{country.name}"
  buf << " | #{country.codes.join( ' · ' ) }"
  buf << " | #{country.tags.join( ' › ' )}"

  names = country.alt_names
  ## filter alt codes - all lowercase (unicode letter possible)
  names = names.reject { |name| name =~ /^[\p{Ll}]+$/ }

  buf << " | #{names.join( ' · ' )}"
  buf << " |\n"
end

puts buf

write_text( './SUMMARY_AZ.md', buf )

puts "bye"

