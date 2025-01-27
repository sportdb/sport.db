##
## to compile use
##    $ racc -o parser.rb calc.y
##
##  try empty production in rules
##       plus add optional sig(n) e.g. '-'



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
         : sign_opt NUMBER
              {
                 result =  val[0] == '-' ? -val[1] : val[1] 
              }
         | LPAREN expression RPAREN
             { result = val[1] }

       sign_opt
         :  /* empty  -  note - returns nil for val */
         |  MINUS        
             
end




