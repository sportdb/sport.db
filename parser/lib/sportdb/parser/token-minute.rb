
module SportDb
class Lexer

#
#  todo/check - move goal type regexes to goal or somewhere else?
#

##   goal types
# (pen.) or (pen) or (p.) or (p)
## (o.g.) or (og)
##   todo/check - keep case-insensitive 
##                   or allow OG or P or PEN or
##                   only lower case - why? why not?
GOAL_PEN_RE = %r{
   (?<pen> \(
           (?:pen|p)\.?
           \)
    )
}ix
GOAL_OG_RE = %r{
   (?<og> \(
          (?:og|o\.g\.)
          \)
   )
}ix


## minute variant for  N/A not/available
##     todo/check - find a better syntax - why? why not?
##
##   note  "??".to_i(10) returns 0 or
##         "__".to_i(10) returns 0
##   quick hack - assume 0 for n/a for now 

MINUTE_NA_RE = %r{
   (?<minute>
      (?<=[ (])	 # positive lookbehind for space or opening 
        (?<value> \?{2} | _{2} )
        '   ## must have minute marker!!!!
    )
}ix

MINUTE_RE = %r{
     (?<minute>
       (?<=[ (])	 # positive lookbehind for space or opening ( e.g. (61') required
                     #    todo - add more lookbehinds e.g.  ,) etc. - why? why not?
             (?<value>\d{1,3})      ## constrain numbers to 0 to 999!!!
                   (?: \+
                     (?<value2>\d{1,3})   
                   )?           
        '     ## must have minute marker!!!!
     )
}ix


#####
#  player with minute (top-level) regex 
#   - starts new player/goal mode (until end of line)!!!
#   - note: allow one or more spaces between name and minute
#
#  note - aaa  bbb 40'
#      make sure anchor (^) - beginning of line - present!!!
#       note - will NOT work with ^ anchor!!
#       use special \G - Matches first matching position !!!!
#          otherwise you get matches such as >bbb 40'< skipping >aaa< etc.!!!
#
#   regex question - check if in an regex union - space regex gets matches
#                          or others with first matching position 
#                          or if chars get eaten-up? 
#                        let us know if \G is required here or not
#
##  note - use \A (instead of ^) - \A strictly matches the start of the string.


PLAYER_WITH_MINUTE_RE = %r{
           \A    ### note - MUST start line; leading spaces optional (eat-up)
           [ ]*
             (?:      # optional open bracket ([) -- remove later
                (?<open_bracket> \[ )
                [ ]*
             )?
             (?:     # optional none a.k.a. -;   - what todo here?
               (?<none>  - [ ]* ; [ ]* )
             )?
   (?<player_with_minute>
                   (?<name>
                      \p{L}+       
                        \.?    ## optional dot
       
                          (?:
                              ## rule for space; only one single space allowed inline!!!
                              (?:
                                (?<![ ])  ## use negative lookbehind                             
                                  [ ] 
                                (?=\p{L}|')      ## use lookahead        
                              )
                                  |
                              (?:
                                (?<=\p{L})   ## use lookbehind
                                 ['-]   ## must be surrounded by letters
                                       ## e.g. One/Two NOT
                                       ##      One/ Two or One / Two or One /Two etc.
                                (?=\p{L})      ## use lookahead        
                              )
                                 |   
                              (?:
                                (?<=[ ])   ## use lookbehind  -- add letter (plus dot) or such - why? why not?
                                 [']   ## must be surrounded by leading space and
                                       ## traling letters  (e.g. UDI 'Beter Bed)
                                (?=\p{L})      ## use lookahead        
                              )   
                                 |
                              (?:
                                (?<=\p{L})   ## use lookbehind
                                 [']   ## must be surrounded by leading letter and
                                       ## trailing space PLUS letter  (e.g. UDI' Beter Bed)
                                (?=[ ]\p{L})      ## use lookahead (space WITH letter         
                              )   
                                 |   ## standard case with letter(s) and optinal dot
                              (?: \p{L}+
                                    \.?  ## optional dot
                              )
                          )*
                   )
#### spaces
     (?: [ ]+)
#### minute (see above)
#####   use MINUTE_RE.source or such - for inline (reference) use? do not copy
     (?<minute>
       (?<=[ (])	 # positive lookbehind for space or opening ( e.g. (61') required
                     #    todo - add more lookbehinds e.g.  ,) etc. - why? why not?
           (?: 
              (?<value>\d{1,3})      ## constrain numbers to 0 to 999!!!
                   (?: \+
                     (?<value2>\d{1,3})   
                   )?
               |
              (?<value> \?{2} | _{2} )  ## add support for n/a (not/available)
           )           
        '     ## must have minute marker!!!!
     )
 
   )   
}ix



##  note - use \A (instead of ^) - \A strictly matches the start of the string.

PLAYER_WITH_SCORE_RE = %r{
           \A    ### note - MUST start line; leading spaces optional (eat-up)
           [ ]*
   (?<player_with_score>
                   (?<score>
                     (?<ft1>\d{1,2}) - (?<ft2>\d{1,2})
                   )
                      [ ]+
                   (?<name>
                      \p{L}+       
                        \.?    ## optional dot
       
                          (?:
                              ## rule for space; only one single space allowed inline!!!
                              (?:
                                (?<![ ])  ## use negative lookbehind                             
                                  [ ] 
                                (?=\p{L}|')      ## use lookahead        
                              )
                                  |
                              (?:
                                (?<=\p{L})   ## use lookbehind
                                 ['-]   ## must be surrounded by letters
                                       ## e.g. One/Two NOT
                                       ##      One/ Two or One / Two or One /Two etc.
                                (?=\p{L})      ## use lookahead        
                              )
                                 |   
                              (?:
                                (?<=[ ])   ## use lookbehind  -- add letter (plus dot) or such - why? why not?
                                 [']   ## must be surrounded by leading space and
                                       ## traling letters  (e.g. UDI 'Beter Bed)
                                (?=\p{L})      ## use lookahead        
                              )   
                                 |
                              (?:
                                (?<=\p{L})   ## use lookbehind
                                 [']   ## must be surrounded by leading letter and
                                       ## trailing space PLUS letter  (e.g. UDI' Beter Bed)
                                (?=[ ]\p{L})      ## use lookahead (space WITH letter         
                              )   
                                 |   ## standard case with letter(s) and optinal dot
                              (?: \p{L}+
                                    \.?  ## optional dot
                              )
                          )*
                   )   ## name
            ### check/todo - add lookahead  (e.g. must be space or ,$) why? why not?               
    )  ## player_with_score 
}ix


    
end   # module SportDb
end   # class Lexer