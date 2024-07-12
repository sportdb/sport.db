
    ## todo/check: use ‹› (unicode chars) to mark optional parts in regex constant name - why? why not?

    #####
    #  english helpers (penalty, extra time, ...)
    ##   note - p must go last (shortest match)
    #     pso = penalty shootout 
    P_EN  =  '(?: pso | pen\.? | p\.? )'     # e.g. p., p, pen, pen., PSO, etc.
    ET_EN =  '(?: aet | a\.e\.t\.? )'     # note: make last . optional (e.g a.e.t) allowed too


    ##  note: allow SPECIAL cases WITHOUT full time scores (just a.e.t or pen. + a.e.t.)
    ##      3-4 pen. 2-2 a.e.t.
    ##      3-4 pen.   2-2 a.e.t.
    ##               2-2 a.e.t.
    SCORE__P_ET__RE = %r{
        (?<score>
           \b
            (?:
               (?<score1p>\d{1,2}) - (?<score2p>\d{1,2})
                 [ ]* #{P_EN} [ ]+
             )?             # note: make penalty (P) score optional for now
            (?<score1et>\d{1,2}) - (?<score2et>\d{1,2})
               [ ]* #{ET_EN}
               (?=[ \]]|$)
        )}ix  
                ## todo/check:  remove loakahead assertion here - why require space?
                ## note: \b works only after non-alphanum e.g. )


    ## e.g. 3-4 pen. 2-2 a.e.t. (1-1, 1-1)  or
    ##      3-4p 2-2aet (1-1, )     or
    ##      3-4 pen.  2-2 a.e.t. (1-1)       or
    ##               2-2 a.e.t. (1-1, 1-1)  or
    ##               2-2 a.e.t. (1-1, )     or
    ##               2-2 a.e.t. (1-1)

    SCORE__P_ET_FT_HT__RE = %r{
          (?<score>
               \b
               (?:
                (?<score1p>\d{1,2}) - (?<score2p>\d{1,2})
                   [ ]* #{P_EN} [ ]+
                )?            # note: make penalty (P) score optional for now
               (?<score1et>\d{1,2}) - (?<score2et>\d{1,2})
                   [ ]* #{ET_EN} [ ]+
                   \(
                   [ ]*
              (?<score1>\d{1,2}) - (?<score2>\d{1,2})
                   [ ]*
                (?:
                     , [ ]*
                    (?: (?<score1i>\d{1,2}) - (?<score2i>\d{1,2})
                        [ ]*
                    )?
                )?              # note: make half time (HT) score optional for now
              \)
             (?=[ \]]|$)
            )}ix       ## todo/check:  remove loakahead assertion here - why require space?
                               ## note: \b works only after non-alphanum e.g. )

    ###
    ##   special case for case WITHOUT extra time!!
    ##     same as above (but WITHOUT extra time and pen required)
    SCORE__P_FT_HT__RE = %r{
             (?<score>
                \b
     (?<score1p>\d{1,2}) - (?<score2p>\d{1,2})
        [ ]* #{P_EN} [ ]+
        \(
        [ ]*
      (?<score1>\d{1,2}) - (?<score2>\d{1,2})
        [ ]*
     (?:
          , [ ]*
         (?: (?<score1i>\d{1,2}) - (?<score2i>\d{1,2})
             [ ]*
         )?
     )?              # note: make half time (HT) score optional for now
   \)
  (?=[ \]]|$)
    )}ix    ## todo/check:  remove loakahead assertion here - why require space?
            ## note: \b works only after non-alphanum e.g. )



    ## e.g. 2-1 (1-1) or
    ##      2-1
 
    SCORE__FT_HT__RE = %r{      
            (?<score>
              \b
              (?<score1>\d{1,2}) - (?<score2>\d{1,2})
               (?:
                   [ ]+ \( [ ]*
                (?<score1i>\d{1,2}) - (?<score2i>\d{1,2})
                   [ ]* \)
               )?   # note: make half time (HT) score optional for now
             (?=[ \]]|$)
             )}ix    ## todo/check:  remove loakahead assertion here - why require space?
                    ## note: \b works only after non-alphanum e.g. )


                    
#############################################
# map tables 
#  note: order matters; first come-first matched/served

SCORE_RE = Regexp.union( 
  SCORE__P_ET_FT_HT__RE,  # e.g. 5-1 pen. 2-2 a.e.t. (1-1, 1-0)
  SCORE__P_FT_HT__RE,     # e.g. 5-1 pen. (1-1)
  SCORE__P_ET__RE,        # e.g. 2-2 a.e.t.  or  5-1 pen. 2-2 a.e.t.
  SCORE__FT_HT__RE        # e.g. 1-1 (1-0)
)

