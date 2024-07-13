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


TEXT_RE = %r{
    ## must start with alpha (allow unicode letters!!)      
    (?<text>    
           ## positive lookbehind 
           ##  (MUST be fixed number of chars - no quantifier e.g. +? etc.)
            (?<=[ ,;@|\[\]]
                 |^
            )
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
                   [ ]   ## make space optional too - why? why not?
                   \p{L}+                
               )
        
              (?:(?:  (?:[ ]
                     (?!vs?\.?[ ])    ## note - exclude (v[ ]/vs[ ]/v.[ ]/vs.[ ])
                       )  
                      |     # only single spaces allowed inline!!!
                     [-]                                              
                  )?
                (?:
                  \p{L} |
                  [&/'] 
                    |
                 (?:
                   \d+ 
                   (?![0-9.:h'/+-])   
                   ## negative lookahead for numbers
                   ##   note - include digits itself!!!
                 )|  
                 \.   
               )  
              )*  ## must NOT end with space or dash(-)
              ##  todo/fix - possible in regex here
              ##     only end in alphanum a-z0-9 (not dot or & ???)

  
            ## allow optional at the end
            ##  tag or year
            ##   make it and in the future - why? why not?  
            ##   
            ## (A) -    allow with predined  alpha only for now
            ##          e.g. (A) - amateur a team or b?
            ##      or U21 U9 etc.   - why? why not?
            ##       or etc.
            ## (1879-1893) or allow years e.g. (1879-1893)
            ###     
            (?:
               [ ]  
                  \( (?: 
                       A|B|
                       U\d{1,2} 
                     )
                  \) 
            )? 
            (?:
               [ ] 
               \(
                  \d{4}-\d{4}
               \)
            )?                    

            ## add lookahead/lookbehind
           ##    must be space!!! 
           ##   (or comma or  start/end of string)
           ##   kind of \b !!!
            ## positive lookahead
            (?=[ ,;@|\[\]]
                 |$
            )
   )   
}ix


