
     lineup_sub_opts       : /* empty */   { result = {} }
                             | lineup_sub    { result = { sub: val[0] } }
                        
        ##  allow nested subs e.g. 
        ##     Clément Lenglet 
        ##          (Kingsley Coman 46' 
        ##             (Marcus Thuram 111'))
        ## todo/fix - use goal_minute and minute (w/o pen/og etc.)
       lineup_sub   :  '(' lineup_name MINUTE ')'    
                          {
                              puts "[debug] REDUCE lineup_sub sub - #{val[1].class.name}: #{val[1].pretty_inspect}"
                              result = Sub.new( sub:    val[1],
                                                minute: Minute.new(val[2][1]) 
                                              )
                          }
                    |  '(' lineup_name ')'    ## allow subs without minutes too
                          {
                              result = Sub.new( sub:    val[1] )
                          }      
                   ## allow both styles? minute first or last? keep - why? why not?
                    |   '(' MINUTE lineup_name ')'    
                          {
                              result = Sub.new( sub:    val[2],
                                                minute: Minute.new(val[1][1]) 
                                              )
                          }
