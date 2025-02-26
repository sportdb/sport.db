

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



##
# for timezone format use for now:
# (BRT/UTC-3)      (e.g. brazil time)
#
# (CET/UTC+1)   - central european time
# (CEST/UTC+2)  - central european summer time  - daylight saving time (DST).
# (EET/UTC+1)  - eastern european time
# (EEST/UTC+2)  - eastern european summer time  - daylight saving time (DST).
#
# UTC+3
# UTC+4
# UTC+0
# UTC+00
# UTC+0000
#
#  - allow +01 or +0100  - why? why not
#  -       +0130 (01:30)
#
# see
#   https://en.wikipedia.org/wiki/Time_zone
#   https://en.wikipedia.org/wiki/List_of_UTC_offsets
#   https://en.wikipedia.org/wiki/UTC−04:00  etc.
#
#  e.g. (UTC-2) or (CEST/UTC-2) etc.
#    todo check - only allow upcase 
#    or  (utc-2) and (cest/utc-2) too - why? why not?
 
TIMEZONE_RE = %r{
   (?<timezone>
      \(
           ## optional "local" timezone name eg. BRT or CEST etc.
           (?:  [a-z]+
                 /
           )?
            [a-z]+
            [+-]
            \d{1,4}   ## e.g. 0 or 00 or 0000
      \)
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
  \b     ## todo/check - must be followed by two spaces or space + [( etc.
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
                 ##   PROP_KEY_RE,           ##  start with prop key (match will switch into prop mode!!!)
                    STATUS_RE,
                    NOTE_RE,
                    TIMEZONE_RE,
                     TIME_RE,
                     DURATION_RE,  # note - duration MUST match before date
                    DATE_RE,
                    SCORE_MORE_RE, 
                    SCORE_RE,   ## note basic score e.g. 1-1 must go after SCORE_MORE_RE!!!
                    BASICS_RE, 
                 ##   PLAYER_WITH_MINUTE_RE, ## (goes befor test), match will switch into goal(lines) mode!!!
                    TEXT_RE,
                     WDAY_RE,  # allow standalone weekday name (e.g. Mo/Tu/etc.) - why? why not?
                               #    note - wday MUST be after text e.g. Sun Ke 68' is Sun Ke (NOT Sun) etc.
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
    PROP_NAME_RE,    ## note - (re)use prop name for now for (player) name
)



end  # class Lexer
end # module SportDb
