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

### ppd  - postponed
SCORE_PPD_RE  = %r{  ## must be space before and after!!!
                    (?<score_ppd>
                      (?<=[ ])	# Positive lookbehind for space
                        ppd
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
                
## A walkover, also W.O. or w/o (originally two words: "walk over"), 
##  is awarded to the opposing team/player etc, 
## if there are no other players available, 
## or they have been disqualified, 
## because the other contestants have forfeited or 
# the other contestants have withdrawn from the contest.
##
##  w/o  - walk over
SCORE_WO_RE    = %r{  ## must be space before and after!!!
                    (?<score_wo>
                      (?<=[ ])	# Positive lookbehind for space
                         w/o
                       (?=[ ])   # positive lookahead for space 
                    )
                }ix



end  #  class Parser
end  # module Rsssf 
  