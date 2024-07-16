module Rsssf
class Parser
  

    ######
    ## e.g. 2-1 
    SCORE_RE = %r{      
            (?<score>
                (?<=[ ])	# Positive lookbehind for space
                   (?<score1>\d{1,2}) - (?<score2>\d{1,2})
                (?=[ ])   # positive lookahead for space 
            )
          }ix  

##  [aet]
##  [aet, 3-2 pen]
##  [aet; 3-2 pen]
##  [3-2 pen]
##  [3-2 pen.]
##  [aet, 9-8 pen]
##  [aet, 5-3 pen]
##  [aet, 6-5 pen]
##  [aet]
##
## - add dot (.) too ??
##     [aet. 3-2 pen]


SCORE_EXT_RE =  %r{ \[
                      (?<score_ext>
                          (?:       ## aet only e.g.  aet
                             aet
                             (?:   ##  optional pen
                               [,;][ ]*
                               \d{1,2}-\d{1,2} [ ]? pen\.? 
                             )?
                          )
                          |
                          (?:   ##  penalty only e.g. 3-2 pen
                            \d{1,2}-\d{1,2} [ ]? pen\.?
                          )
                      )
                    \]
                  }ix

### awd  - awarded
SCORE_AWD_RE  = %r{  ## must be space before and after!!!
                    (?<score_awd>
                      (?<=[ ])	# Positive lookbehind for space
                        awd
                       (?=[ ])   # positive lookahead for space 
                    )
                }ix

### abd  -  abandoned
SCORE_ABD_RE  = %r{  ## must be space before and after!!!
                    (?<score_abd>
                      (?<=[ ])	# Positive lookbehind for space
                        abd
                       (?=[ ])   # positive lookahead for space 
                    )
                }ix


### n/p   - not played
SCORE_NP_RE    = %r{  ## must be space before and after!!!
                    (?<score_np>
                      (?<=[ ])	# Positive lookbehind for space
                         n/p
                       (?=[ ])   # positive lookahead for space 
                    )
                }ix
                
end  #  class Parser
end  # module Rsssf 
  