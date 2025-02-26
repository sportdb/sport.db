####
#  to run use:
#    $ ruby sandbox/test_player_with_minute.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'


PLAYER_WITH_MINUTE_RE = SportDb::Lexer::PLAYER_WITH_MINUTE_RE


texts = [## try samples
          "Rapid v Austria",
          "aaa 40'",
          "aaa  40'",
          "aaa 45+3'",
          "aaa  ??'",
          "aaa4 40'",
          "aaa 4 40'",
          "aaa bbb 40'",
          "aaa  bbb 40'",
          "aaa' bb-cc/dd 41'",
          "f.c. 43+1'",
          " f.c. 43+1'",
          "  f.c. 43+1'",
]

texts.each do |text|
  puts "==> #{text}"
  m=PLAYER_WITH_MINUTE_RE.match( text )
  pp m

  if m.nil? 
     puts "!! text NOT matching"
  else
     puts "   name=>#{m['name']}<, value=>#{m['value']}<, value2=>#{m['value2']}<"
  end
end


m=PLAYER_WITH_MINUTE_RE.match( " f.c. 43+1'", 1 )
pp m
m=PLAYER_WITH_MINUTE_RE.match( "  f.c. 43+1'", 1 )
pp m
m=PLAYER_WITH_MINUTE_RE.match( "  f.c. 43+1'", 2 )
pp m


puts "bye"