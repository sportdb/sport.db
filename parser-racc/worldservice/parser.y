##
## to compile use
##    $ racc -o parser.rb parser.y


class MatchParser


## use indent  for start of line instead of newline - why? why not?


     rule 
       statements 
          : statement
          | statements statement
          ;

        statement
          : date_line 
          | team_line 
          | empty_line    
          ;
   
        date_line: 'Oct'  NUMBER NEWLINE
                   { puts '  MATCH date line' }
            ;
 
        team_line: TEXT  NUMBER  NEWLINE 
                  { puts '  MATCH team_line' }
            ;

        empty_line: NEWLINE
                    { puts '  MATCH empty_line' }
            ;
 


#    rule text
#        [a-zA-Z]+
#    end

 #   rule num
 #        # [\p{Nd}]+
 #        [0-9]+
 #   end

#    rule space
#          [ \t]+
#    end

#    rule newline
#          [\n\r]+
#   end

end

