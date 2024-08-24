
## use Sports (not SportDb) for module - why? why not?



module SportDb
class Parser

## Group A-Z
## Group 1-99
## Group HEX  # used in concaf world cup quali
## Group 1A or A1, B1  - used anywhere
##
##  use "key" of group - why? why not?

GROUP_RE = %r{^
                Group [ ]
                   (?<key>[a-z0-9]+)
              $}ix
def is_group?( text )
   ## use regex for match
   GROUP_RE.match?( text )
end




ROUND_RE = %r{^(

   ## add special case for group play-off rounds!
   ##  group 2 play-off   (e.g. worldcup 1954, 1958)
     (?:   Group [ ] [a-z0-9]+ [ ]
           Play-?offs?
     )
        |
   # round  - note - requiers number e.g. round 1,2, etc.
   #   note - use 1-9 regex (cannot start with 0) - why? why not?
   #             make week 01 or round 01 or matchday 01 possible?
      (?: (?: Round |
              Matchday |
              Week
           )
           [ ] [1-9][0-9]*
      )
       |
   ##  starting with qual(ification)
   ## Qual. Round 1 / Qual. Round 2 / Qual. Round 3
     (?:  Qual \. [ ]
          Round
           [ ] [1-9][0-9]*
      )
       |
   ## 1. Round / 2. Round / 3. Round / etc.
   ##  Play-off Round
   ##  First Round
   ##  Final Round   (e.g. Worldcup 1950)
      (?:
           (?: [1-9][0-9]* \.  |
                Play-?off   |
                1st | First   |
                2nd | Second  |
                Final
           )
             [ ] Round
       )
       |
  ## starting with preliminary
  #   e.g.  Preliminary round
     (?:  Preliminary  [ ]
           (?:  Round |
                Semi-?finals |
                Final
           )
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
         |
    ## add replays
    ##  e.g. Final Replay
    ##       Quarter-finals replays
    ##       First round replays
     (?:
        (?: First [ ] Round |
            Quarter-?finals? |
            Finals?
         )
        [ ] Replays?
      )
)$}ix


def is_round?( text )
    ROUND_RE.match?( text )
end

##
## keep leg separate (from round) - why? why not?
##
LEG_RE = %r{^
  # leg1
     (?: 1st|First)[ ]leg
     |
  # leg2
     (?: 2nd|Second)[ ]leg
$}ix

### Pair matches/games if marked with leg1 n leg2
def is_leg?( text )
   LEG_RE.match?( text )
end


end  # class Parser
end  # module SportDb
