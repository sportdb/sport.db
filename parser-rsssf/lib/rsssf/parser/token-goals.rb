module Rsssf
class Parser


## cannot start with number
## cannot have number inside
## cannot end with number!!!
##
##  check if can end in dot - why? why not?
##    e.g.  jr. or such?

##
##   allow  45+/90+  too
##     or   90+pen or
##          90+ pen/90+p/90+ og

MINUTE_RE = %r{
     (?<minute>
         \b
            \d{1,3}   
            '?   ## optional minute quote (')
            (?:       
               # optional offset/extra e.g. 45+ / 90+ or 45+10 / 90+5
                (?: \+
                  (?: 
                     (?! [0-9])   ## negative look ahead (not a number) required
                     |    
                    (?:
                      \d{1,3} 
                      '?   ## optional minute quote (')
                      (?= (og|pen|p)? ([ ;,\]]|$))
                    )
                  )
                )
                |
                (?= (og|pen|p)? ([ ;,\]]|$))  # note - break can be og|pen|p too
         )
      )}ix
### note - word boundary (\b) will NOT work for quoet (')  
##             because quote is NOT alphanum (like dot etc.)



##   goal types
GOAL_PEN_RE = %r{
   (?<pen> 
        (?<=\d|\+|[ ]|')	## must follow a number or plus (e.g. 45p / 45+p / 45 p / 45'p) or space
            (?: pen|p )
            \b 
    )
}ix


GOAL_OG_RE = %r{
   (?<og> 
        (?<=\d|\+|[ ]|')	## must follow a number or plus (e.g. 45og / 45+og / 45 og) or space
          og
          \b
   )
}ix




end # class Parser
end # module Rsssf
        