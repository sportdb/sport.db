###
#  build a summary (cheatsheet) page


## our own code
require 'sportdb/langs'

lang = SportDb::Lang.new

puts "sportdb-lang/#{SportDb::Langs::VERSION}"

## pp lang.words
en = lang.words['en']
pp en

buf = String.new
buf << "# Language\n\n"

en.keys.each do |key|
  buf << "**#{en[key].gsub('|', ' • ')}** (`#{key}`)\n"
  lang.words.each do |k,v|
    next if k == 'en'   ## skip english
    if v.has_key?( key )
       buf << "- `#{k}`: #{v[key].gsub('|', ' • ')}\n"
    end
  end
  buf << "\n\n"
end

puts buf

File.open( 'SUMMARY.md', 'w:utf-8' ) do |f|
  f.write buf
end
