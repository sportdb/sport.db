####
#  to run use:
#    $ ruby sandbox/test_re.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'


PROP_NUM_RE  = SportDb::Lexer::PROP_NUM_RE


texts = [## try some
            '1',
            '01',
          'attn:  44_444',
          '44_444',
          '44__44',
          '44_',
          '123',
         ]

texts.each do |text|
  puts "==> #{text}"
  m=PROP_NUM_RE.match( text )

  if m
    pp m
  else
    puts "!! num NOT matching"
  end
end



puts "bye"