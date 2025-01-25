####
#  to run use:
#    $ ruby sandbox/test_props.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'


PROP_KEY_RE  = SportDb::Lexer::PROP_KEY_RE
PROP_NAME_RE = SportDb::Lexer::PROP_NAME_RE


texts = [## try teams
         "Achilles'29 II:  ",
         "  UDI'19/Beter Bed :  ",
         "UDI '19/Beter Bed",
         "One/Two: ",
         "111: ",
         "1: ",
         "1. FC Köln: ",
         "1 FC Köln : ",
         "A: ",
         "b: ",
         "  c : ",
         "A1: ",
         "1B: ", 
         ]

texts.each do |text|
  puts "==> #{text}"
  m=PROP_KEY_RE.match( text )

  if m
    pp m
  else
    puts "!! prop key NOT matching"
  end
end



texts = [## try teams
         "Achilles'29 II  xxxx",
         "  UDI/Beter Bed  ",
         "  UDI / Beter Bed  ",
         "  UDI/ Beter Bed  ",
         "  UDI /Beter Bed  ",
         "UDI'Beter Bed",
         "UDI' Beter Bed",
         "UDI 'Beter Bed",
         "UDI ' Beter Bed",
         "One/Two ",
         "One-Two ",
         "One - Two ",
         "111 ",
         "FC Köln: ",
         "Stop. ",
         "Frank V. 24'.",
         "Frank V. 24'. ",
         "Frank V.",
         "J.Doe",
         "J. Doe",
         ]


puts
puts "--- prop names:"

texts.each do |text|
  puts "==> #{text}"
  m=PROP_NAME_RE.match( text )

  if m
    pp m
  else
    puts "!! prop name NOT matching"
  end
end


puts "bye"