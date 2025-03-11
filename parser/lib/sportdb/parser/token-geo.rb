module SportDb
class Lexer


##
#  allow Cote'd Ivoir or such
##   e.g. add '


## todo/fix - make geo text regex more generic
##               only care about two space rule


GEO_TEXT_RE = %r{
    ## must start with alpha (allow unicode letters!!)
    (?<text>
           ## positive lookbehind -  for now space (or beginning of line - for testing) only
           ##  (MUST be fixed number of chars - no quantifier e.g. +? etc.)
            (?<= [ ,›>\[\]]|^)
            (?:
                # opt 1 - start with alpha
                 \p{L}+    ## all unicode letters (e.g. [a-z])
                   |
                # opt 2 - start with num!! - 
                     \d+  # check for num lookahead (MUST be space or dot)
                      ## MAY be followed by (optional space) !
                      ## MUST be follow by a to z!!!!
                      [ ]?   ## make space optional too  - why? why not?
                             ##  yes - eg. 1st, 2nd, 5th etc.
                       \p{L}+
                  |
                ## opt 3 - add another weirdo case
                ##   e.g.   's Gravenwezel-Schilde
                ##   add more letters (or sequences here - why? why not?)
                    '\p{L}+
               )

               ##
               ## todo/check - find a different "more intuitive" regex/rule if possible?
               ##    for single spaces only (and _/ MUST not be surround by spaces) 

              (?: 
                  [ ]?   # only single spaces allowed inline!!!  
                  (?:
                     \p{L} | \d | [.&'°]
                      |
                     (?: (?<! [ ])  ## no space allowed before (but possible after)
                          [-]
                     )
                       |
                     (?: (?<! [ ])  ## no spaces allowed around these characters
                          [_/]
                         (?! [ ])
                     )
                  )+
              )*
         
              ## must NOT end with space or dash(-)
              ##  todo/fix - possible in regex here
              ##     only end in alphanum a-z0-9 (not dot or & ???)

            ## add lookahead/lookbehind
           ##    must be space!!!
           ##   (or comma or  start/end of string)
           ##   kind of \b !!!
            ## positive lookahead
            (?=[ ,›>\[\]]|$)
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



GEO_BASICS_RE = %r{
    (?<spaces> [ ]{2,}) |
    (?<space>  [ ])
        |
    (?<sym> [,›>\[] )
}ix




GEO_RE = Regexp.union(
                    TIMEZONE_RE,
                    GEO_BASICS_RE, 
                    GEO_TEXT_RE,
                    ANY_RE,
                      )

end # class Lexer
end # module SportDb
