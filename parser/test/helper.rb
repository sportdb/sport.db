## minitest setup
require 'minitest/autorun'


$LOAD_PATH.unshift( './lib' )

## our own code
require  'sportdb/parser'



module Minitest
class Test


 ## easy access for regex testing
 TIMEZONE_RE = SportDb::Parser::TIMEZONE_RE
 DURATION_RE = SportDb::Parser::DURATION_RE
 DATE_RE     = SportDb::Parser::DATE_RE
 TEXT_RE     = SportDb::Parser::TEXT_RE
 SCORE_RE    = SportDb::Parser::SCORE_RE
 RE          = SportDb::Parser::RE


 def parser() @@parser ||= SportDb::Parser.new; end

 def tokenize( line )
    parser.tokenize( line )
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