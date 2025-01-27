##
## to compile use
##    $ racc -o parser.rb parser.y


##
# experimental grammar 
#   try alternate rules / production
#    to check for shift/reduce conflicts and more


#
#
# naming convention
#   use _opt or _opts only if first production is empty!!
#     and, thus, makes the rule optional by default
#           because it can return empty result ({})



class RaccMatchParser

     rule 
       document :  # allow empty documents - why? why not?
                | elements

       elements : element 
                | elements element
               
                
        
       element
          : date_header
          | group_header
          | round_header
          | group_def
          | round_def
          | match_line
          | goal_lines
      ##    | goal_lines   ## check - goal_lines MUST follow match_line - why? why not?
          | empty_line    
          | lineup_lines
          | error      ## todo/check - move error sync up to elements - why? why not?
              { puts "!! skipping invalid content (trying to recover from parse error):"
                pp val[0] 
                @errors << "parser error (recover) - skipping #{val[0].pretty_inspect}"
              }
 


        ## change PROP to LINEUP_TEAM
        ## change PROP_NAME to NAME or LINEUP_NAME
        ##
        ##  try without ending dot 
        ##   was PROP lineup '.' NEWLINE
        ##   change to/try
        ##       PROP lineup NEWLINE
       lineup_lines  : PROP lineup NEWLINE    ## fix add NEWLINE here too!!!
                        {  @tree << LineupLine.new( team:    val[0],
                                                    lineup:  val[1]
                                                  ) 
                        }


       lineup :   lineup_name       
                    { result = [[val[0]]] }
              |   lineup lineup_sep lineup_name
                    {
                       ## if lineup_sep is -  start a new sub array!!
                       if val[1] == '-'
                          result << [val[2]]
                       else
                          result[-1] << val[2]
                       end
                    }


       lineup_sep  :  ','
                     | ',' NEWLINE  { result = val[0]   }
                     | '-' 
                     | '-' NEWLINE  { result = val[0]   }


      lineup_name    :    PROP_NAME lineup_name_opts
                           {
                              kwargs = { name: val[0] }.merge( val[1] )
                              result = Lineup.new( **kwargs )
                           }

       lineup_name_opts : /* empty */   { result = {} }
                        | card 
                            {
                              result = { card: val[0] }
                            }
                        | card lineup_sub
                            {
                              result = { card: val[0], sub: val[1] }
                            }
                        | lineup_sub 
                            {
                              result = { sub: val[0] }
                            }
                
        ## todo/fix - use goal_minute and minute (w/o pen/og etc.)
       lineup_sub   :  '(' MINUTE lineup_name ')'    
                          {
                              result = Sub.new( minute: Minute.new(val[1][1]), 
                                                sub:    val[2] )
                          }



       card         :   '[' card_body ']'
                          {
                              kwargs = val[1]
                              result = Card.new( **kwargs )
                          }
       
       card_body    :     card_type
                           { result = { name: val[0] } } 
         ## todo/fix - use goal_minute and minute (w/o pen/og etc.)                          
                    |     card_type MINUTE
                           { result = { name: val[0], minute: Minute.new(val[1][1]) } }
                     

       card_type    :  YELLOW_CARD | RED_CARD 




        ######  
        # e.g   Group A  |    Germany   Scotland     Hungary   Switzerland   
        group_def
              :   GROUP_DEF '|'  team_values   NEWLINE  
                  {
                      @tree << GroupDef.new( name:  val[0],
                                             teams: val[2] )
                  }

        team_values
              :   TEAM                       { 
                                               result = val
                                               ## e.g. val is ["Austria"] 
                                             }
              |   team_values TEAM           {
                                               result.push( val[1] )
                                             }


        #####
        # e.g.  Matchday 1  |  Fri Jun/14 - Tue Jun/18   
        round_def
             :  ROUND_DEF '|'  round_date   NEWLINE
                  {
                      kwargs = { name: val[0] }.merge( val[2] )
                      @tree<< RoundDef.new( **kwargs )
                  }


        round_date       :   DATE        { result = { date: val[0][1] } } 
                         |  DURATION     { result = { duration: val[0][1] } }


        date_header
              :     DATE     NEWLINE
                  {
                     @tree <<  DateHeader.new( date: val[0][1] )  
                  }
              | '[' DATE ']' NEWLINE      ## enclosed in []
                  {
                     @tree <<  DateHeader.new( date: val[1][1] )  
                  }
 


         group_header :  GROUP  NEWLINE
                 {
                     @tree <<  GroupHeader.new( name: val[0] )  
                  }
 


###
##  e.g. Quarter-finals - 1st Leg

         round_header :  round_values  NEWLINE
                 {
                     @tree <<  RoundHeader.new( names: val[0] )  
                  }
          
          round_values :  ROUND    {  result = val }
                       |  round_values round_sep ROUND  {   result.push( val[2] ) }

          round_sep    : '-' 
                       | ','


         

        match_line
              :   match_opts  match  more_match_opts NEWLINE
                    {     
                       kwargs = {}.merge( val[0], val[1], val[2] )
                       @tree << MatchLine.new( **kwargs )
                    }
              ##   "compact" formats for more match in one line
              ##     (but NO geo, NO status)
              |  match_opts  match ',' more_matches  NEWLINE 
                    {
                      kwargs = {}.merge( val[0], val[1] )
                      @tree << MatchLine.new( **kwargs )
                     
                      ## add more match fixtures
                      val[3].each do |kwargs|
                         @tree << MatchLine.new( **kwargs)
                      end
                    }
     

   

         more_matches :   match
                                  {
                                    trace( "REDUCE => more_matches : match" ) 
                                    result = val
                                  }
                     |   more_matches ',' match
                                  {
                                     trace( "REDUCE => more_matches : more_matches ',' match" ) 
                                     result.push( val[2] )
                                  }


        match_opts
             :  /* empty */
             |  ord
             |  ord date   { result = {}.merge( val[0], val[1] ) }
             |  date
                
        ord : ORD          {  result = { ord: val[0][1][:value] } }

       date: : DATE            {   result = { date: val[0][1]}  }
             | DATE TIME       {   result = { date: val[0][1], time: val[1][1] } }
             | TIME            {   result = { time: val[0][1]}  }


        more_match_opts
             : /* empty */   {}
             | STATUS      ## note - for now status must be BEFORE geo_opts!!
                 {
                      ## todo - add possible status_notes too!!! 
                      result = { status: val[0][1][:status] }
                 }
             | STATUS geo      
                 { 
                     result = { status: val[0][1][:status] }.merge( val[1] ) 
                 }
             | geo    { result = {}.merge( val[0] ) }
   

        ## e.g.  @ Parc des Princes, Paris
        ##       @ München 
        ##       @ Luzhniki Stadium, Moscow (UTC+3)
        geo      : '@' geo_values           { result = { geo: val[1] } }
                 | '@' geo_values TIMEZONE  { result = { geo: val[1], timezone: val[2] } }

        geo_values
               :  TEXT                    {  result = val }
               |  geo_values ',' TEXT     {  result.push( val[2] )  }      


         match  :   match_result
                |   match_fixture 
                    
         match_fixture :  TEAM match_sep TEAM
                           {
                               trace( "RECUDE match_fixture" )
                               result = { team1: val[0],
                                          team2: val[2] }   
                           }

         match_sep :  '-' | VS
            ## note - does NOT include SCORE; use SCORE terminal "in-place" if needed
  

        match_result :  TEAM  SCORE  TEAM
                         {
                           trace( "REDUCE => match_result : TEXT  SCORE  TEXT" )
                           result = { team1: val[0],
                                      team2: val[2],
                                      score: val[1][1]
                                    }   
                        }
                     |  match_fixture SCORE
                        {
                          trace( "REDUCE  => match_result : match_fixture SCORE" )
                          result = { score: val[1][1] }.merge( val[0] )  
                        }
                                        
   
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
                     {
                       kwargs = val[1]
                       @tree << GoalLine.new( **kwargs )
                     }
                   | goal_lines_body NEWLINE
                      {
                         kwargs = val[0]
                         @tree << GoalLine.new( **kwargs )
                      }


        goal_lines_body : goals                 {  result = { goals1: val[0],
                                                              goals2: [] } 
                                                }
                        | '-' ';' goals         {  result = { goals1: [],
                                                              goals2: val[2] } 
                                                }
                        | goals goal_sep goals  {  result = { goals1: val[0],
                                                              goals2: val[2] }
                                                }
      
        goal_sep    : ';'
                    | ';' NEWLINE
                       

        # goal_opts     : '-' 
        #               | goals
        
        #  goals_break : goals
        #              | goals_break NEWLINE goals 

         goals  :  goal               { result = val }
                |  goals goal         { result.push( val[1])  }
                ## allow optional comma separator too - why? why not?
                ##   results in shift/reduce conflict 
                ##      retry/rework later 
                ##    for now added (optinal tamgling comma to goal)
                ## |  goals ',' goal     { result.push( val[2])  }
         
         ## check if changes with PLAXER (instead of TEXT!!!!
         ## goals  :  TEXT minutes   
         ##       |  goals TEXT minutes
         ##       |  goals TEXT minutes ','
         ##  note - if NOT working out fix in match schedule!!
         ##                  and remove commas between goals!!!

         goal : PLAYER  goal_minutes          
                {  
                  result = Goal.new( player:  val[0],
                                     minutes: val[1] )   
                }
#              | PLAYER goal_minutes  ','    
#                {  
#                  result = Goal.new( player:  val[0],
#                                     minutes: val[1] )   
#                }
            ## might start a new line
            ##  | NEWLINE PLAYER minutes 


         goal_minutes : goal_minute                  { result = val }
                      | goal_minutes goal_minute     { result.push( val[1]) }
                      | goal_minutes ',' goal_minute { result.push( val[2]) }
                                       ## optional comma separator
                                       

         goal_minute :  MINUTE goal_minute_opts
                     {
                        kwargs = { }.merge( val[0][1] ).merge( val[1] )
                        result = Minute.new( **kwargs )
                     }

         goal_minute_opts :  /* empty */   { result = { } }
                          | OG     {  result = { og: true } } 
                          | PEN    {  result = { pen: true } }



        empty_line: NEWLINE
                    { trace( "REDUCE empty_line" ) }
            
 
end

