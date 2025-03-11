module SportDb
class Lexer



## todo - use ANY_RE  to token_commons or such - for shared by many?

## general catch-all  (RECOMMENDED (ALWAYS) use as last entry in union)
##   to avoid advance of pos match!!!
ANY_RE = %r{
               (?<any> .)
          }ix



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

## note:
##  make sure these do NOT match!!!
## TEXT  =>  "Matchday 1 / Group A"
## TEXT  =>  "Matchday 2 / Group A"
## TEXT  =>  "Matchday 3 / Group A"



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
                      [ ]?   ## make space optional too  - why? why not?
                             ##  yes - eg. 1st, 2nd, 5th etc.
                       \p{L}+
                  |
                ## opt 3 - add weirdo case
                ##   e.g.  1/8 Finals  1/4 1/2 ...
                    1/ \d{1,2} [ ] \p{L}+
                  |
                ## opt 4 - add another weirdo case
                ##   e.g.   's Gravenwezel-Schilde
                    '[s]
                  |
                ## opt 5 - add another weirdo case
                ##   e.g. 5.-8. Platz Playoffs  - keep - why? why not?
                    \d+\.-\d+\.  [ ]? \p{L}+                 
               )

              (?:(?:  (?:[ ]   # only single spaces allowed inline!!! 
                        (?! (?-i: vs?[ ])
                          )    ## note - exclude (v[ ]/vs[ ])
                               ##    AND switch to case-sensitive (via -i!!!)
                      )
                      |     
                     [/-]   ## must NOT be surrounded by spaces 
                  )?
                (?:
                  \p{L} 
                     |
                  [.&'°]
                     |
                 (?:
                   \d+
                   (?!
                     [0-9h'+] |    ## protected break on 12h / 12' / 1-1
                                    ##  check usege for 3+4 - possible? where ? why?     
                     (?:[.:-]\d)     ## protected/exclude/break on 12.03 / 12:03 / 12-12
                                     ##  BUT allow Park21-Arena for example e.g. 21-A :-)
                    )
                   ## negative lookahead for numbers
                   ##   note - include digits itself!!!
                   ##   note - remove / (slash) e.g. allows UDI'19/Beter Bed
                 )
               )
              )*  ## must NOT end with space or dash(-)
              ##  todo/fix - possible in regex here
              ##     only end in alphanum a-z0-9 (not dot or & ???)


            ## allow optional at the end
            ##  tag or year
            ##   make it and in the future - why? why not?
            ##
            ## change - fix
            ##   do NOT use (A) for amateur
            ##   use A or A. with NO ()!!!
            ## (A) -    allow with predined  alpha only for now
            ##          e.g. (A) - amateur a team or b?
            ###  same for U21 or U9 etc
            ##        use with NO ()!!! - why? why not?
            ##      or U21 U9 etc.   - why? why not?
            ##       or etc.
            ## (1879-1893) or allow years e.g. (1879-1893)
            ###
            ##    add allow country code three to five letters for now
            ##       change to generic 1 to 5 - why? why not?
            ##     e.g. (A), (I),
            ##          (AUT)
            ##          (TRNC)   five? for UEFA code for northern cyprus
            ##     change to 1 to 4 - why? why not?
            ##   check - fix possible for upper case only here
            ##                     inline for this group only?
            (?:
               [ ]
               \(
                  \d{4}-\d{4}
               \)
            )?
             (?:
               [ ]+   ## allow more than once space - why? why not?
                  \( (?:
                       [A-Z]{1,5}
                     )
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


end # class Lexer
end # module SportDb
