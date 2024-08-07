module Rsssf
class Parser
   
   
##  note - do NOT allow single alpha text for now
##   add later??      A - B    C - D  - why?        
## opt 1) one alpha
## (?<text_i> [a-z])    # only allow single letter text (not numbers!!)  
    
## opt 2) more than one alphanum


### allow special case - starting text with number e.g.
##    number must be follow by space or dot ()
# 1 FC   ##    allow 1-FC or 1FC   - why? why not?
# 1. FC
# 1.FC   - XXXX  - not allowed for now, parse error
# 1FC    - XXXX  - now allowed for now, parse error
# 1890 Munich
#


##
#  allow Cote'd Ivoir or such
##   e.g. add '


## note - use a more strict text re(gex)
##         if inside brackets !!!!

###
## "simple" strict text regex
###  no numbers  (or & or such inside)
##    allows  dash/hyphen (-)
##      and   dot (.) and apostroph (') for now


## simple (double) quoted text
##   only supports a-z (unicode) PLUS (single) inline space
##    add more chars - why? why not?
TEXT_QUOTED =   '(?:  "    ' +
                 '  \p{L}+  ' + 
                 '     (?: [ ]  ' +
                 '        \p{L}+ )*   '  + 
                 '    "  )  '


### might start with "" !!!
##    e.g. 
##      "Tiago" Cardoso Mendes 80
##     "Cristiano Ronaldo" dos Santos Aveiro 74
##     "Zé Castro" José Eduardo Rosa Vale Castro 60og


TEXT_STRICT_RE = %r{
   (?<text>
         (?: \b |  #{TEXT_QUOTED} [ ]   ## note - leading quoted text must be followed by space!!
          )
          \p{L}+    ## all unicode letters (e.g. [a-z])
           
             (?:
               (?:[ ]
                    |     # only single spaces allowed inline!!!
                   [-]                                              
               )?
               (?:
                  \p{L}+ |
                   ['.] |
                   (?:
                      (?<= [ ])
                      #{TEXT_QUOTED}
                      (?= [ ]|$)   ### must be followed by space
                                  ##  todo/fix - add all end of text lookaheads to (see below)
                   )
               )  
              )*  
               ## must NOT end with space or dash(-)
              ##  todo/fix - possible in regex here
              ##     only end in alphanum a-z0-9 (not dot or & ???)
   
        ## positive lookahead
        ##   cannot use \b  if text ends in dot (.) or other non-alphnum 
        ##        than \b will not work
        ##   not    - add () too for now - why? why not? 
            (?=[ ,;@|\[\]\(\)]  
                 |$
            )  
    )
}ix



TEXT_RE = %r{
    ## must start with alpha (allow unicode letters!!)      
    (?<text>    
             \b   ## use/require word boundary
            (?:  
                # opt 1 - start with alpha
                 \p{L}+    ## all unicode letters (e.g. [a-z])
                   |

                # opt 2 - start with num!! - allow special case (e.g. 1. FC) 
                     \d+  # check for num lookahead (MUST be space or dot)
                      ## MUST be followed by (optional dot) and
                      ##                      required space !!!
                      ## MUST be follow by a to z!!!!
                      \.?     ## optional dot
                      [ ]?   ## make space optional too  - why? why not?
                             ##  yes - eg. 1st, 2nd, 5th etc.
                       \p{L}+               
               )
        
              (?:(?:  (?:[ ]
                     (?! (awd|abd|ppd|n/p|w/o)[ ])    ## note - exclude (awd[ ]/abd[ ]/n/p[ ])
                       )  
                      |     # only single spaces allowed inline!!!
                     [-]                                              
                  )?
                (?:
                  \p{L}+ | [&/'.] 
                    |
                 (?:
                   \d+ 
                   (?![0-9.:'/+-])   
                   ## negative lookahead for numbers
                   ##   note - include digits itself!!!
                 )  
               )  
              )*  ## must NOT end with space or dash(-)
              ##  todo/fix - possible in regex here
              ##     only end in alphanum a-z0-9 (not dot or & ???)

              ## support (Hamburg) or such at the end (ony)
              ##   note - no numbers allowed inside () for now!!
             (?:
                  [ ]\(\p{L}+
                      (?:
                         (?: [ ] |
                             [-]
                          )? 
                          \p{L}+ | [&/'.]
                        )*
                      \)
             )?


            ## add lookahead/lookbehind
           ##    must be space!!! 
           ##   (or comma or  start/end of string)
           ##   kind of \b !!!
            ## positive lookahead
            ##  note - added : too - why? why not?
            (?=[ ,;@|:\[\]]
                 |$
            )
   )   
}ix



end # class Parser
end # module Rsssf
   