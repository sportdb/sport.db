

module Rsssf
class Parser

## Group A-Z
## Group 1-99
## Group HEX  # used in concaf world cup quali
## Group 1A or A1, B1  - used anywhere
##
##  use "key" of group - why? why not?

GROUP_RE = %r{(?<group>
                 \b
                Group [ ]
                   [a-z0-9]+
            \b)}ix


ROUND_RE = %r{(?<round>
                  \b
   (?:
   # round  - note - requiers number e.g. round 1,2, etc.
      (?:  (?: Round |
              Matchday |
              Week
           )
           [ ] [0-9]+
      )
      |
   # more (kockout) rounds
   # playoffs  - playoff, play-off, play-offs
        (?: Play-?offs? 
           (?: [ ]for[ ]quarter-?finals )?
        )
        |    
   # round32
        (?: Round[ ]of[ ]32 | 
            Last[ ]32 )
          |
   # round16   
        (?: Round[ ]of[ ]16 |
            Last[ ]16 | 
            8th[ ]finals )
           |
   # fifthplace
         (?:
             (?: (Fifth|5th)[ -]place 
                  (?: [ ] (?: match|play-?off|final ))?
              ) |
             (?: Match[ ]for[ ](?: fifth|5th )[ -]place )
         )
          |
   # thirdplace
          (?: 
              (?: (Third|3rd)[ -]place 
                     (?: [ ] (?: match|play-?off|final ))? 
               ) |
              (?: Match[ ]for[ ](?: third|3rd )[ -]place ) 
           )
           |
   # quarterfinals
         (?:
              Quarter-?finals? |
              Quarters |
              Last[ ]8
          )
          |     
   # semifinals
        (?:   
             Semi-?finals? |
             Semis |
             Last[ ]4
        )
        |
   # final
         Finals? 
       )
      \b)}ix

##
## keep leg separate (from round) - why? why not?
##
LEG_RE = %r{ (?<leg>
                  \b
  (?:
   # leg1
     (?: 1st|First)[ ]legs? 
     |
  # leg2 
     (?: 2nd|Second)[ ]legs?
  )
    \b)}ix


end  # class Parser
end  # module Rsssf
