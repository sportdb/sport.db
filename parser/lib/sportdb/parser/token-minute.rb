
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



    
end   # module SportDb
end   # class Lexer