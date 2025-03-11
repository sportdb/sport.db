####
#  to run use:
#    $ ruby sandbox/test_quick.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'


TEXT_RE = SportDb::Lexer::QUICK_PLAYER_WITH_MINUTE_RE


texts = [## try minutes
           "29'",
           "45+2'",
           "??'",
           "__'",
           "45",
           "bbb??'",
           "bbb29'",
         ]


texts.each do |text|
  puts "==> #{text}"
  m=TEXT_RE.match( text )
  print "  "
  pp m

  if m.nil? || text != m[0]
     puts "!! text NOT matching"
  end
end


puts "bye"