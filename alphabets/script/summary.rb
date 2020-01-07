$:.unshift( File.expand_path( './lib' ) )   # note: use local version (path load path)
require 'alphabets'

require 'unicode/name'

pp Alphabet::UNACCENT

pp Alphabet::DOWNCASE


buf = String.new
buf << "# Alphabets\n\n"
buf << "## Unaccent Mappings (#{Alphabet::UNACCENT.size})\n\n"

Alphabet::UNACCENT.each do |ch,_|
  buf << "#{ch}"
end
buf << "\n\n"

Alphabet::UNACCENT.each do |ch,alt|
  buf << "- **#{ch}** #{'U+%04X' % ch.ord} (#{ch.ord}) - #{Unicode::Name.of(ch)} ⇒ #{alt}\n"
end


buf << "\n\n"
buf << "## Downcase Mappings (#{Alphabet::DOWNCASE.size})\n\n"

Alphabet::DOWNCASE.each do |up,down|
  buf << "#{up}#{down} "
end
buf << "\n\n"

Alphabet::DOWNCASE.each do |up,down|
  buf << "- **#{up}** #{'U+%04X' % up.ord} (#{up.ord}) - #{Unicode::Name.of(up)}"
  buf << ' ⇒ '
  buf << "**#{down}** #{'U+%04X' % down.ord} (#{down.ord}) - #{Unicode::Name.of(down)}"
  buf << "\n"
end


puts buf

File.open( 'SUMMARY.md', 'w:utf-8' ) do |f|
  f.write buf
end
