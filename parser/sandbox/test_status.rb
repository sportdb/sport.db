####
#  to run use:
#    $ ruby sandbox/test_status.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'

STATUS_RE  = SportDb::Lexer::STATUS_RE


texts = [## try status
          "   awarded   ",
          "   [awarded]  ",
          "[awarded]",
         ]

texts.each do |text|
  puts "==> #{text}"
  m=STATUS_RE.match( text )

  if m
    pp m
  else
    puts "!! status NOT matching"
  end
end


puts "bye"