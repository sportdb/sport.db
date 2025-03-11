

module SportDb
class Lexer


##
#  keep 18h30 - why? why not?
#    add support for 6:30pm 8:20am etc. - why? why not?
#
#    check - only support h e.g. 18h30  or 18H30 too - why? why not?
# e.g. 18.30 (or 18:30 or 18h30)
TIME_RE = %r{
    (?<time>  \b
        (?:   (?<hour>\d{1,2})
                 (?: :|\.|h )
              (?<minute>\d{2})) 
              \b
    )
}ix



## add wday / stand-alone week day - as separate regex or 
##          use TEXT with is_wday? check or such with
##                requirement of beginning of line (anchored to line) only??
##       - why? why not?

WDAY_RE = %r{
(?<wday>
  \b     # note - alternation (|) is lowest precedence (such 
         #    parathenes required around \b()\b !!!
         ## note - NOT case sensitive!!!    
       (?<day_name>
        (?-i:
          Mon|Mo|
          Tue|Tu|
          Wed|We|
          Thu|Th|
          Fri|Fr|
          Sat|Sa|
          Sun|Su
       ))
       (?=[ ]{2})   # positive lookahead for two space  
       ## todo/check - must be followed by two spaces or space + [( etc.
         ##   to allow words starting with weekday abbrevations - why? why not?
         ##     check if any names (teams, rounds, etc) come up in practice 
         ##   or maybe remove three letter abbrevations Mon/Tue
         ##    and keep only Mo/Tu/We etc. - why? why not?
)}x    




BASICS_RE = %r{
    ## e.g. (51) or (1) etc.  - limit digits of number???
    ##  todo/fix - change num  to ord (for ordinal number)!!!!!
    (?<num> \(  (?<value>\d+) \) )
       |
    (?<vs>
       (?<=[ ])	# positive lookbehind for space
       (?-i: 
         vs|v 
       )        # note - only match case sensitive (downcased letters)!!!
                # note -  bigger match first e.g. vs than v etc.
       (?=[ ])   # positive lookahead for space
    )
       |
    (?<spaces> [ ]{2,}) |
    (?<space>  [ ])
        |
    (?<sym>  (?<=^|[ ])  ## positive lookahead 
                  (?: ----|
                      ---|
                      --
                  )
             (?=[ ])   ## positive lookahead
    )
        |
    (?<sym> [;,/@|\[\]-] )
}ix



RE = Regexp.union(
                    STATUS_RE,
                    SCORE_NOTE_RE,
                    NOTE_RE,
                    DURATION_RE,  # note - duration MUST match before date
                    DATE_RE,  ## note - date must go before time (e.g. 12.12. vs 12.12)
                     TIME_RE,
                    SCORE_MORE_RE, 
                    SCORE_RE,   ## note basic score e.g. 1-1 must go after SCORE_MORE_RE!!!
                    BASICS_RE, 
                    WDAY_RE,  # allow standalone weekday name (e.g. Mo/Tu/etc.) - why? why not?
                              #    note - wday MUST be after text e.g. Sun Ke 68' is Sun Ke (NOT Sun) etc.
                   TEXT_RE,
                   ANY_RE,
                      )



######################################################
## goal mode (switched to by PLAYER_WITH_MINUTE_RE)   

GOAL_BASICS_RE = %r{
    (?<spaces> [ ]{2,}) |
    (?<space>  [ ])
        |
    (?<sym>  
        [;,\[\]]   ## add (-) dash too - why? why not?   
    )   
}ix


GOAL_RE = Regexp.union(
    GOAL_BASICS_RE,
    MINUTE_RE,
    MINUTE_NA_RE,   ## note - add/allow not/available (n/a,na) minutes hack for now
    GOAL_OG_RE, GOAL_PEN_RE,
    SCORE_RE,
    PROP_NAME_RE,    ## note - (re)use prop name for now for (player) name
)

## note - leave out n/a minute in goals - make minutes optional!!!
PROP_GOAL_RE =  Regexp.union(
    GOAL_BASICS_RE,
    MINUTE_RE,
   ## MINUTE_NA_RE,   ## note - add/allow not/available (n/a,na) minutes hack for now
    GOAL_OG_RE, GOAL_PEN_RE,
    SCORE_RE,
    PROP_NAME_RE,    ## note - (re)use prop name for now for (player) name
)


####
# 
##  note - use \A (instead of ^) - \A strictly matches the start of the string.
ROUND_OUTLINE_RE = %r{   \A
                           [ ]*  ## ignore leading spaces (if any)
                         (?: »|>> ) 
                           [ ]+
                            (?<round_outline>
                               ## must start with letter - why? why not?
                               ###   1st round
                               ##  allow numbers e.g. Group A - 1 
                               .+?   ## use non-greedy 
                            )
                           [ ]*  ## ignore trailing spaces (if any) 
                         $
                       }ix


end  # class Lexer
end # module SportDb
