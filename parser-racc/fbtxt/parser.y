##
## to compile use
##    $ racc -o parser.rb parser.y


class MatchParser


     rule 
       statements 
          : statement
          | statements statement
        
        statement
          : date_header 
          | group_header
          | round_header
          | group_def
          | round_def
          | match_line  goal_lines  ## check - goal_lines MUST follow match_line - why? why not?
          | empty_line    
          

        ######  
        # e.g   Group A  |    Germany   Scotland     Hungary   Switzerland   
        group_def
              :   GROUP '|'  team_values   NEWLINE

        team_values
              :   TEXT
              |   team_values TEXT

        #####
        # e.g.  Matchday 1  |  Fri Jun/14 - Tue Jun/18   
        round_def
             :  ROUND '|'  round_date_opts   NEWLINE
    
        round_date_opts  :   DATE | DURATION


        date_header
              :     DATE     NEWLINE
              | '[' DATE ']' NEWLINE      ## enclosed in []
              { puts '  MATCH date line' }
 

         group_header :  GROUP  NEWLINE

         round_header :  ROUND  NEWLINE


        match_line
              :   match_opts  match  more_match_opts 
              |   match  more_match_opts 
                  { puts '  MATCH team_line' }

        match_opts
             :  ORD
             |  ORD date_opts
             |  date_opts
 
        more_match_opts
             : geo_opts
             | NEWLINE

        ## e.g.  @ Parc des Princes, Paris
        ##       @ München 
        geo_opts : '@' geo_values

        geo_values
               :  TEXT
               |   geo_values ',' TEXT        

        date_opts
             : DATE
             | DATE TIME
             | TIME

        match :  TEXT  score_value  TEXT

        score_value:  SCORE | VS  | '-'


        #######
        ## e.g. Wirtz 10' Musiala 19' Havertz 45+1' (pen.)  Füllkrug 68' Can 90+3';  
        ##      Rüdiger 87' (o.g.)

        goal_lines : goals  NEWLINE
                   | goal_opts goal_sep goals NEWLINE
                  
        goal_sep    :  ';' 
                    |  ';'  NEWLINE   ## allow optional newline after ;

        goal_opts     : '-' 
                      | goals

         goals  :  goal
                |  goals NEWLINE goal  ## allow optional newline between goals
                |  goals goal 
   

         goal :   PLAYER minutes       # TEXT minutes
            


         minutes : minute
                 |  minutes minute

         minute :   MINUTE
                 |  MINUTE minute_opts
         
         minute_opts : OG | PEN     


        empty_line: NEWLINE
                    { puts '  MATCH empty_line' }
            
 
end

