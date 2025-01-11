##
## to compile use
##    $ racc -o parser.rb calc.y


class CalculatorParser


  rule expressions
         : expression
         
       expression
         : term
         | expression PLUS term
             { result = val[0] + val[2] }
         | expression MINUS term
             { result = val[0] - val[2] }
         
       term
         : factor
         | term MULTIPLY factor
             { result = val[0] * val[2] }
         | term DIVIDE factor
             { result = val[0] / val[2] }
         
       factor
         : NUMBER
         | LPAREN expression RPAREN
             { result = val[1] }
             
end




