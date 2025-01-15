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
                  {
                      @tree << GroupDef.new( name:  val[0],
                                             teams: val[2] )
                  }

        team_values
              :   TEXT                       { 
                                               result = val
                                               ## e.g. val is ["Austria"] 
                                             }
              |   team_values TEXT           {
                                               result.push( val[1] )
                                             }


        #####
        # e.g.  Matchday 1  |  Fri Jun/14 - Tue Jun/18   
        round_def
             :  ROUND '|'  round_date_opts   NEWLINE
                  {
                      kwargs = { name: val[0] }.merge( val[2] )
                      @tree<< RoundDef.new( **kwargs )
                  }


        round_date_opts  :   DATE        { result = { date: val[0] } } 
                         |  DURATION     { result = { duration: val[0] } }


        date_header
              :     DATE     NEWLINE
                  {
                     @tree <<  DateHeader.new( date: val[0] )  
                  }
              | '[' DATE ']' NEWLINE      ## enclosed in []
                  {
                     @tree <<  DateHeader.new( date: val[1] )  
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
              :   match_opts  match  more_match_opts 
                    {
                       puts "match:"
                       pp val[1]
                       puts "more match opts:"
                       pp val[2]  

                       kwargs = {}.merge( val[0], val[1], val[2] )
                       @tree << MatchLine.new( **kwargs )
                    }
              |   match  more_match_opts 
                  { 
                      kwargs = {}.merge( val[0], val[1] )
                      @tree << MatchLine.new( **kwargs )
                  }

        match_opts
             :  ORD             {   result = { ord: val[0] }  }
             |  ORD date_opts   {   result = { ord: val[0] }.merge( val[1] ) }
             |  date_opts       
 
       date_opts
             : DATE            {   result = { date: val[0]}  }
             | DATE TIME       {   result = { date: val[0], time: val[1] } }
             | TIME            {   result = { time: val[0]}  }


        more_match_opts
             : geo_opts NEWLINE      { result = { geo: val[0]} }
             | NEWLINE               { result = {} }

        ## e.g.  @ Parc des Princes, Paris
        ##       @ München 
        geo_opts : '@' geo_values  { result = val[1]  }

        geo_values
               :  TEXT                    {  result = val }
               |  geo_values ',' TEXT     {  result.push( val[2] )  }      

 
        match :  TEXT  score_value  TEXT
                    {
                         result = { team1: val[0],
                                    team2: val[2]
                                  }.merge( val[1] )   
                    }

        score_value:  SCORE            {  result = { score: val[0] }  } 
                   |   VS              {  result = {} }  
                   |  '-'              {  result = {} }


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
   
       
         goal : TEXT  minutes      # PLAYER minutes    
              {  
                result = Goal.new( player:  val[0],
                                   minutes: val[1] )   
              }
            ## might start a new line
            ##  | NEWLINE TEXT minutes 


         minutes : minute              { result = val }
                 |  minutes minute     { result.push( val[1]) }
                 |  minutes ',' minute { result.push( val[2]) }
                                       ## optional comma separator
                                       

         minute :   MINUTE
                     {
                        ## todo/fix:  assume val[0] is a hash
                        result = Minute.new( minute: val[0] )
                     }
                 |  MINUTE minute_opts
                     {
                        kwargs = { minute: val[0] }.merge( val[1] )
                        result = Minute.new( **kwargs )
                     } 

         minute_opts : OG     {  result = { og: true } } 
                     | PEN    {  result = { pen: true } }



        empty_line: NEWLINE
                    { puts '  MATCH empty_line' }
            
 
end



---- inner

GroupDef   = Struct.new( :name, :teams )
RoundDef   = Struct.new( :name, :date, :duration )  
DateHeader = Struct.new( :date ) 
GroupHeader = Struct.new( :name )
RoundHeader = Struct.new( :names )

MatchLine   = Struct.new( :ord, :date, :time,
                          :team1, :team2, :score, 
                          :geo )   ## change to geos - why? why not?

GoalLine    = Struct.new( :goals1, :goals2 )
Goal        = Struct.new( :player, :minutes )
Minute      = Struct.new( :minute, :offset, :og, :pen )


