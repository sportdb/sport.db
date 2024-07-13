## minitest setup
require 'minitest/autorun'


$LOAD_PATH.unshift( './lib' )

## our own code
require  'sportdb/parser'   




module Minitest 
class Test

## add assert_lines helper
def assert_lines( lines )
    lines.each do |line,exp|
        puts "==> >#{line}<"
        tokens = tokenize( line )
        pp tokens
        assert_equal exp, tokens
    end
end

end  # class Test
end  # module Minitest