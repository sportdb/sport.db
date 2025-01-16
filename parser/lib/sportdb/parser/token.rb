

module SportDb
class Parser


##
#  keep 18h30 - why? why not?
#    add support for 6:30pm 8:20am etc. - why? why not?

TIME_RE = %r{
    ## e.g. 18.30 (or 18:30 or 18h30)
    (?<time>  \b
              (?<hour>\d{1,2})
                 (?: :|\.|h )
              (?<minute>\d{2})
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

TIMEZONE_RE = %r{
   ## e.g. (UTC-2) or (CEST/UTC-2) etc.
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




BASICS_RE = %r{
    ## e.g. (51) or (1) etc.  - limit digits of number???
    (?<num> \(  (?<value>\d+) \) )
       |
    (?<vs>
       (?<=[ ])	# Positive lookbehind for space
       (?:
          vs|v
       )  
           # not bigger match first e.g. vs than v etc.
           # todo/fix - make vs|v case sensitive!!! only match v/vs - why? why not?
       (?=[ ])   # positive lookahead for space
    )
       |
    (?<spaces> [ ]{2,}) |
    (?<space>  [ ])
        |
    (?<sym>[;,@|\[\]-])
}ix


## removed from basics
=begin
    (?<none>
       (?<=[ \[]|^)	 # Positive lookbehind for space or [
           -
        (?=[ ]*;)   # positive lookahead for space
    )
       |
   (?<vs>
       (?<=[ ])	# Positive lookbehind for space
       (?:
          vs\.?|   ## allow optional dot (eg. vs. v.)
          v\.?|
          -
       )   # not bigger match first e.g. vs than v etc.
       (?=[ ])   # positive lookahead for space
    )
       |
 
    make - into a simple symbol !!!
=end


MINUTE_RE = %r{
     (?<minute>
       (?<=[ (])	 # Positive lookbehind for space or opening ( e.g. (61') required
           (?<value>\d{1,3})      ## constrain numbers to 0 to 999!!!
        (?: \+
            (?<value2>\d{1,3})
        )?
        '     ## must have minute marker!!!!
     )
}ix


##   goal types
# (pen.) or (pen) or (p.) or (p)
## (o.g.) or (og)
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






PROP_BASICS_RE = %r{
    (?<spaces> [ ]{2,}) |
    (?<space>  [ ])
        |
    (?<sym>[.;,\(\)\[\]-])   ## note - dot (.) is the (all-important) end-of-prop marker!!!
}ix


## name different from text (does not allow number in name/text)
##
##  note - includes special handling for dot (.) if at the end of line!!!
##            end-of-line dot (.) is the prop end-of-marker - do NOT eat-up!!!

PROP_NAME_RE = %r{
                 (?<prop_name> \b
                   (?<name>
                      \p{L}+       
                       (?: \. (?: (?![ ]*$) )
                        )?      ## edge case - check for end of prop marker! (e.g. Stop.)
                      (?: 
                          [ ]?    # only single spaces allowed inline!!!
                          (?:
                              (?:
                                (?<=\p{L})   ## use lookbehind
                                 [/'-]   ## must be surrounded by letters
                                       ## e.g. One/Two NOT
                                       ##      One/ Two or One / Two or One /Two etc.
                                (?=\p{L})      ## use lookahead        
                              )
                                 |   
                              (?:
                                (?<=[ ])   ## use lookbehind  -- add letter (plus dot) or such - why? why not?
                                 [']   ## must be surrounded by leading space and
                                       ## traling letters  (e.g. UDI 'Beter Bed)
                                (?=\p{L})      ## use lookahead        
                              )   
                                 |
                              (?:
                                (?<=\p{L})   ## use lookbehind
                                 [']   ## must be surrounded by leading letter and
                                       ## trailing space PLUS letter  (e.g. UDI' Beter Bed)
                                (?=[ ]\p{L})      ## use lookahead (space WITH letter         
                              )   
                                 |
                              (?: \p{L}+
                                  (?: \. 
                                      (?: (?![ ]*$) )
                                  )?  ## last dot is delimiter!!!
                              )
                          )+
                     )*
                   )
               ## add lookahead - must be non-alphanum (or dot)
                  (?=[ .,;\]\)]|$)
                  )
}ix




##############
#  add support for props/ attributes e.g.
# 
#    Germany:    Neuer - Kimmich, Rüdiger, Tah [Y], Mittelstädt – Andrich [Y] (46' Groß),
#      Kroos (80' Can) – Musiala (74' Müller), Gündogan,
#      Wirtz (63' Sane) – Havertz (63' Füllkrug).
#    Scotland:   Gunn – Porteous [R 44'], Hendry, Tierney (78' McKenna) – Ralston [Y],
#      McTominay, McGregor (67' Gilmour), Robertson – Christie (82' Shankland),
#      Adams (46' Hanley), McGinn (67' McLean).
#
## note:  colon (:) MUST be followed by one (or more) spaces
##      make sure mon feb 12 18:10 will not match
##        allow 1. FC Köln etc.
##               Mainz 05:
##           limit to 30 chars max
##          only allow  chars incl. intl but (NOT ()[]/;)


  PROP_KEY_RE = %r{ 
                 (?<prop_key> \b
                   (?<key>
                       (?:\p{L}+
                           |
                           \d+  # check for num lookahead (MUST be space or dot)
                        ## MUST be followed by (optional dot) and
                        ##                      required space !!!
                        ## MUST be follow by a to z!!!!
                         \.?     ## optional dot
                         [ ]?   ## make space optional too  - why? why not?
                             ##  yes - eg. 1st, 2nd, 5th etc.
                         \p{L}+
                        )
                        [\d\p{L}'/° -]*?   ## allow almost anyting 
                                          ## fix - add negative lookahead 
                                          ##         no space and dash etc.
                                          ##    only allowed "inline" not at the end
                                          ## must end with latter or digit!
                   )
                    [ ]*?     # slurp trailing spaces
                     :
                    (?=[ ]+)  ## possitive lookahead (must be followed by space!!)
                   )
                 }ix




PROP_RE = Regexp.union(
   PROP_BASICS_RE, 
   MINUTE_RE,
   PROP_NAME_RE,
)



RE = Regexp.union(  PROP_KEY_RE, ##  start with prop key (match will/should switch into prop mode!!!)
                    STATUS_RE,
                    TIMEZONE_RE,
                     TIME_RE,
                     DURATION_RE,  # note - duration MUST match before date
                    DATE_RE,
                    SCORE_RE,
                    BASICS_RE, MINUTE_RE,
                    GOAL_OG_RE, GOAL_PEN_RE,
                     TEXT_RE )


end  # class Parser
end # module SportDb
