####
#  to run use:
#    $ ruby sandbox/test_rounds.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'


##
# quick check
#   make sure rounds are unique



names = []
langs = ['de', 'es', 'pt', 'en', 'misc' ]
## sort names by length??
langs.each do |lang|
  path = "#{SportDb::Module::Parser.root}/config/rounds_#{lang}.txt"
  more_names = SportDb::Parser.read_names( path )

  if more_names.size != more_names.uniq.size
    pp more_names
    puts "!! names not unique - remove #{more_names.size-more_names.uniq.size} duplicate(s)"
    exit 1
  end
  names += more_names
end
names

pp names
puts "  #{names.size} round name(s)"

## check if match regex machinery (english only for now)
ROUND_RE = SportDb::Parser::ROUND_RE
names.each do |name|
  m = ROUND_RE.match( name )
  if m
    puts "!! BINGO - match >#{name}<"
  end
end


puts "bye"

