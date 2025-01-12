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
          | match_line
          | goal_lines   ## check - goal_lines MUST follow match_line - why? why not?
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

###
##  e.g. Quarter-finals - 1st Leg

         round_header :  round_values  NEWLINE
          
          round_values :  ROUND
                       |  round_values round_sep ROUND

          round_sep    : '-' 
                       | ','


        match_line
              :   match_opts  match  more_match_opts 
              |   match  more_match_opts 
                  { puts '  MATCH team_line' }

        match_opts
             :  ORD
             |  ORD date_opts
             |  date_opts
 
        more_match_opts
             : geo_opts NEWLINE
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
        ##
        ##    [Higuaín 2', 9' (pen.); Kane 35' Eriksen 71']
 
        #
        # todo/fix/check -  check how to allow (more) newlines
        #                      between goals
        #   for now possible only after ;
        #

        goal_lines : '['  goal_lines_body  ']' NEWLINE 
                   | goal_lines_body NEWLINE


        goal_lines_body : goals 
                        | '-' ';' goals 
                        | goals goal_sep goals
      
        goal_sep    : ';'
                    | ';' NEWLINE
                       

        # goal_opts     : '-' 
        #               | goals
        
        #  goals_break : goals
        #              | goals_break NEWLINE goals 

         goals  :  goal
                |  goals goal 
   
       
         goal : TEXT  minutes      # PLAYER minutes    
            ## might start a new line
            ##  | NEWLINE TEXT minutes 
              { puts '  MATCH goal (player w/ minutes)' }


         minutes : minute
                 |  minutes minute
                 |  minutes ',' minute    ## optional comma separator

         minute :   MINUTE
                 |  MINUTE minute_opts
         
         minute_opts : OG | PEN     


        empty_line: NEWLINE
                    { puts '  MATCH empty_line' }
            
 
end

