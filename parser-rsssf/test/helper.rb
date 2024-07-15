## minitest setup
require 'minitest/autorun'


$LOAD_PATH.unshift( './lib' )

## our own code
require  'rsssf/parser'   



module Minitest 
class Test


 ## easy access for regex testing
 DATE_RE     = Rsssf::Parser::DATE_RE
 TEXT_RE     = Rsssf::Parser::TEXT_RE
 SCORE_RE    = Rsssf::Parser::SCORE_RE
 RE          = Rsssf::Parser::RE


 def parser() @@parser ||= Rsssf::Parser.new; end

 def tokenize( line )
    parser.tokenize( line )
 end  

 def parse( line )
    parser.parse( line )
 end



###################
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