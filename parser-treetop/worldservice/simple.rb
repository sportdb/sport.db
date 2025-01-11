require 'treetop'

Treetop.load_from_string <<-END
  grammar Match
    rule stmts
      stmt+ 
    end

    rule stmt
       space? (date_line / team_line) space? newline  
    end

    rule date_line
       'Oct' space num
    end

    rule team_line
       text  space  num 
    end

    rule text
        [a-zA-Z]+
    end

    rule num
         #  unicode character classes working? 
         # [\p{Nd}]+
         [0-9]+
    end


    rule space
          [ \t]+
    end

    rule newline
          [\n\r]+
    end
  end
END



pp MatchParser


parser = MatchParser.new
pp parser


txt = <<-TXT
Oct 7 
Austria 1
Rapid 2

Oct 11
Sturm  0
LASK  3

TXT

result = parser.parse( txt )
puts result

puts "---"

pp result

puts "bye"