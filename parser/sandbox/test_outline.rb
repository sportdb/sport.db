####
#  to run use:
#    $ ruby sandbox/test_outline.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'

path = '/sports/openfootball/euro/2024--germany/euro.txt'
outline = SportDb::QuickMatchOutline.read( path )

outline.each_para do |lines|
  puts "para - #{lines.size} line(s):"
  pp lines
end

puts "bye"

