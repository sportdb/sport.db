##
## to compile use
##    $ racc -o parser.rb parser.y
##      racc -o ../lib/sportdb/parser/parser.rb parser.y



#
#
# todo/try/check:
#    use/add empty production to 
#     match_pre and match_post options to simplify production if possible?



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
          | goal_lines_alt   ## allow differnt style/variant 
          | BLANK        ##  was empty_line
             { trace( "REDUCE BLANK" ) } 
          | teams_list
          | lineup_lines
          | error      ## todo/check - move error sync up to elements - why? why not?
              { puts "!! skipping invalid content (trying to recover from parse error):"
                pp val[0] 
                @errors << "parser error (recover) - skipping #{val[0].pretty_inspect}"
              }
         ### use   error NEWLINE - why? why not?
         ##           will (re)sync on NEWLINE?

        teams_list :   TEAMS NEWLINE  list   BLANK

        list   :   list_item
               |   list  list_item

        ### todo/fix - make    list_item_body more flexible (not just single TEXT)!!!
        ###   todo/check - maybe start with level two e.g. --/---/etc.
        ##                                      and not single -/--/---  - why? why not?
        list_item :   '---'  TEXT  NEWLINE   {  puts "level 3" }
                  |   '--'   TEXT  NEWLINE   {  puts "level 2 #{val[1]}" } 
                  |   '-'    TEXT  NEWLINE   {  puts "level 1 #{val[1]}" }
                  |   TEXT NEWLINE


        ## change PROP to LINEUP_TEAM
        ## change PROP_NAME to NAME or LINEUP_NAME
       lineup_lines  : PROP lineup PROP_END NEWLINE     ## fix add NEWLINE here too!!!
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
       lineup_sub   :  '(' lineup_name MINUTE ')'    
                          {
                              result = Sub.new( sub:    val[1],
                                                minute: Minute.new(val[2][1]) 
                                              )
                          }
                   ## allow both styles? minute first or last? keep - why? why not?
                    |   '(' MINUTE lineup_name ')'    
                          {
                              result = Sub.new( sub:    val[2],
                                                minute: Minute.new(val[1][1]) 
                                              )
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
                           { result = { name: val[0],
                                        minute: Minute.new(val[1][1]) } 
                           }
                     

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
             :  ROUND_DEF '|'  round_date_opts   NEWLINE
                  {
                      kwargs = { name: val[0] }.merge( val[2] )
                      @tree<< RoundDef.new( **kwargs )
                  }


        round_date_opts  :   DATE        { result = { date: val[0][1] } } 
                         |  DURATION     { result = { duration: val[0][1] } }


        date_header
              :     date_header_body   NEWLINE
                  {
                     kwargs = {}.merge( val[0] )
                     @tree <<  DateHeader.new( **kwargs )  
                  }
              | '[' date_header_body ']' NEWLINE       ## note - enclosed in []
                  {
                     kwargs = {}.merge( val[1] )
                     @tree <<  DateHeader.new( **kwargs )  
                  }

         date_header_body  
               : date_header_date            
               | date_header_date geo_opts   {  result = {}.merge( val[0], val[1] ) }

        date_header_date     ## note - only two option allowed (no TIME, or WDAY etc.)
               : DATE            {   result = { date: val[0][1]}  }
               | DATETIME        {   result = {}.merge( val[0][1] ) }




         group_header :  GROUP  NEWLINE
                 {
                     @tree <<  GroupHeader.new( name: val[0] )  
                  }
 


###
##  e.g. Quarter-finals - 1st Leg

         round_header 
               :  round_values  NEWLINE
                   {
                     @tree <<  RoundHeader.new( names: val[0] )  
                   }
               |  round_values group_sep GROUP  NEWLINE    ## allow round with trailing group
                   {
                    @tree <<  RoundHeader.new( names: val[0], group: val[2] )  
                   }    

          group_sep    : '/'  | ','  ## note - do NOT allow dash (-) for now - why? why not?                        

          round_values :  ROUND    {  result = val }
                       |  round_values round_sep ROUND  {   result.push( val[2] ) }

          round_sep    : '-' | ','   ## todo/check - allow mixing?
                                     ##   or only one style at a time - why? why not?



        match_line
              :   match_opts  match  more_match_opts
                    {     
                       kwargs = {}.merge( val[0], val[1], val[2] )
                       @tree << MatchLine.new( **kwargs )
                    }
              |   match  more_match_opts 
                  { 
                      kwargs = {}.merge( val[0], val[1] )
                      @tree << MatchLine.new( **kwargs )
                  }
              ##   "compact" formats for match fixtures ONLY (no scores, no geo, no status)
              ##      try to change  match_opts to date_opts only!!!
              ##        for now result in shift/reduce conflict!!
              |  match_opts  match ',' more_matches  NEWLINE 
                    {
                      kwargs = {}.merge( val[0], val[1] )
                      @tree << MatchLine.new( **kwargs )
                     
                      ## add more match fixtures
                      val[3].each do |kwargs|
                         @tree << MatchLine.new( **kwargs)
                      end
                    }
              |  match ',' more_matches NEWLINE
                    {
                      kwargs = val[0]
                      @tree << MatchLine.new( **kwargs )
 
                      ## add more match fixtures
                      val[2].each do |kwargs|
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
             :  ORD             {   result = { ord: val[0][1][:value] }  }
             |  ORD date_opts   {   result = { ord: val[0][1][:value] }.merge( val[1] ) }
             |  date_opts       
 
       date_opts
             : DATE            {   result = { date: val[0][1]}  }
             | DATETIME        {   result = {}.merge( val[0][1] )  }
             | TIME            {   result = { time: val[0][1]}  }
             | WDAY            {   result = { wday: val[0][1]} }
             | WDAY TIME       {   result = { wday: val[0][1], time: val[1][1] } }


        more_match_opts
             : STATUS NEWLINE      ## note - for now status must be BEFORE geo_opts!!
                 {
                      ## todo - add possible status_notes too!!! 
                      result = { status: val[0][1][:status] }
                 }
             | STATUS geo_opts NEWLINE      
                 { 
                     result = { status: val[0][1][:status] }.merge( val[1] ) 
                 }
             | geo_opts NEWLINE             { result = {}.merge( val[0] ) }
             | NEWLINE                      { result = {} }


        ## e.g.  @ Parc des Princes, Paris
        ##       @ München 
        ##       @ Luzhniki Stadium, Moscow (UTC+3)
        geo_opts : '@' geo_values           { result = { geo: val[1] } }
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
  

         score:    SCORE | SCORE_MORE     ## support basic e.g 1-1
                                          ##   and "more" format  1-1 (0-1) or 2-1 a.e.t. etc.

        match_result :  TEAM  score  TEAM
                         {
                           trace( "REDUCE => match_result : TEAM score TEAM" )
                           result = { team1: val[0],
                                      team2: val[2],
                                      score: val[1][1]
                                    }   
                        }
                     |  match_fixture  score
                        {
                          trace( "REDUCE  => match_result : match_fixture score" )
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


        ###
        #  todo - add tree nodes for goal_lines_alt!!!!

        goal_lines_alt : goals_alt NEWLINE

        goals_alt   :  goal_alt
                    |  goals_alt goal_alt

        goal_alt    :  SCORE PLAYER minute



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

         goal : PLAYER  minutes          
                {  
                  result = Goal.new( player:  val[0],
                                     minutes: val[1] )   
                }
#              | PLAYER  minutes  ','    
#                {  
#                  result = Goal.new( player:  val[0],
#                                     minutes: val[1] )   
#                }
            ## might start a new line
            ##  | NEWLINE PLAYER minutes 


         minutes : minute              { result = val }
                 |  minutes minute     { result.push( val[1]) }
                 |  minutes ',' minute { result.push( val[2]) }
                                       ## optional comma separator
                                       

         minute :   MINUTE
                     {
                        kwargs = {}.merge( val[0][1] )
                        result = Minute.new( **kwargs )
                     }
                 |  MINUTE minute_opts
                     {
                        kwargs = { }.merge( val[0][1] ).merge( val[1] )
                        result = Minute.new( **kwargs )
                     } 

         minute_opts : OG     {  result = { og: true } } 
                     | PEN    {  result = { pen: true } }
                                
 
end

