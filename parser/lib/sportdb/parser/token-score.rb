module SportDb
class Lexer


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
        (?<score_more>
           \b
            (?:
               (?<p1>\d{1,2}) - (?<p2>\d{1,2})
                 [ ]* #{P_EN} [ ]+
             )?             # note: make penalty (P) score optional for now
            (?<et1>\d{1,2}) - (?<et2>\d{1,2})
               [ ]* #{ET_EN}
               (?=[ ,\]]|$)
        )}ix
                ## todo/check:  remove loakahead assertion here - why require space?
                ## note: \b works only after non-alphanum e.g. )


    ##  note: allow SPECIAL with penalty only
    ##      3-4 pen.
    SCORE__P__RE = %r{
        (?<score_more>
           \b
              (?<p1>\d{1,2}) - (?<p2>\d{1,2})
                [ ]* #{P_EN}
                (?=[ ,\]]|$)
         )}ix
                ## todo/check:  remove loakahead assertion here - why require space?
                ## note: \b works only after non-alphanum e.g. )

   ####
   ## support short all-in-one e.g.
   ##  e.g.      3-4 pen. 2-2 a.e.t. (1-1, 1-1) becomes
   ##   3-4 pen. (2-2, 1-1, 1-1)            
         
   SCORE__P_ET_FT_HT_V2__RE = %r{
          (?<score_more>
               \b
                (?<p1>\d{1,2}) - (?<p2>\d{1,2})
                   [ ]* #{P_EN} [ ]+       
                   \(
               (?<et1>\d{1,2}) - (?<et2>\d{1,2})
                   [ ]*, [ ]*
               (?<ft1>\d{1,2}) - (?<ft2>\d{1,2})
                   [ ]*, [ ]*
               (?<ht1>\d{1,2}) - (?<ht2>\d{1,2})
                   [ ]*
                \)
               (?=[ ,\]]|$)
            )}ix       ## todo/check:  remove loakahead assertion here - why require space?
                               ## note: \b works only after non-alphanum e.g. )


    ## e.g. 3-4 pen. 2-2 a.e.t. (1-1, 1-1)  or
    ##      3-4p 2-2aet (1-1, )     or
    ##      3-4 pen.  2-2 a.e.t. (1-1)       or
    ##               2-2 a.e.t. (1-1, 1-1)  or
    ##               2-2 a.e.t. (1-1, )     or
    ##               2-2 a.e.t. (1-1)

    SCORE__P_ET_FT_HT__RE = %r{
          (?<score_more>
               \b
               (?:
                (?<p1>\d{1,2}) - (?<p2>\d{1,2})
                   [ ]* #{P_EN} [ ]+
                )?            # note: make penalty (P) score optional for now
               (?<et1>\d{1,2}) - (?<et2>\d{1,2})
                   [ ]* #{ET_EN} [ ]+
                   \(
                   [ ]*
              (?<ft1>\d{1,2}) - (?<ft2>\d{1,2})
                   [ ]*
                (?:
                     , [ ]*
                    (?: (?<ht1>\d{1,2}) - (?<ht2>\d{1,2})
                        [ ]*
                    )?
                )?              # note: make half time (HT) score optional for now
              \)
             (?=[ ,\]]|$)
            )}ix       ## todo/check:  remove loakahead assertion here - why require space?
                               ## note: \b works only after non-alphanum e.g. )

    ###
    ##   special case for case WITHOUT extra time!!
    ##     same as above (but WITHOUT extra time and pen required)
    SCORE__P_FT_HT__RE = %r{
             (?<score_more>
                \b
     (?<p1>\d{1,2}) - (?<p2>\d{1,2})
        [ ]* #{P_EN} [ ]+
        \(
        [ ]*
      (?<ft1>\d{1,2}) - (?<ft2>\d{1,2})
        [ ]*
     (?:
          , [ ]*
         (?: (?<ht1>\d{1,2}) - (?<ht2>\d{1,2})
             [ ]*
         )?
     )?              # note: make half time (HT) score optional for now
   \)
  (?=[ ,\]]|$)
    )}ix    ## todo/check:  remove loakahead assertion here - why require space?
            ## note: \b works only after non-alphanum e.g. )


    ##########
    ## e.g. 2-1 (1-1)
    SCORE__FT_HT__RE = %r{
            (?<score_more>
              \b
              (?<ft1>\d{1,2}) - (?<ft2>\d{1,2})
                   [ ]+ \( [ ]*
                (?<ht1>\d{1,2}) - (?<ht2>\d{1,2})
                   [ ]* \)
             (?=[ ,\]]|$)
             )}ix    ## todo/check:  remove loakahead assertion here - why require space?
                    ## note: \b works only after non-alphanum e.g. )

    #####
    ##      2-1
    SCORE__FT__RE = %r{
            (?<score>
              \b
              (?<ft1>\d{1,2}) - (?<ft2>\d{1,2})
              \b
             )}ix  

#############################################
# map tables
#  note: order matters; first come-first matched/served
#
## check - find a better name for SCORE_MORE - SCORE_EX, SCORE_BIG, or ___ - why? why not?

SCORE_MORE_RE = Regexp.union(
  SCORE__P_ET_FT_HT_V2__RE,  # e.g. 5-1 pen. (2-2, 1-1, 1-0)  
  SCORE__P_ET_FT_HT__RE,    # e.g. 5-1 pen. 2-2 a.e.t. (1-1, 1-0)
  SCORE__P_FT_HT__RE,     # e.g. 5-1 pen. (1-1)
  SCORE__P_ET__RE,        # e.g. 2-2 a.e.t.  or  5-1 pen. 2-2 a.e.t.
  SCORE__P__RE,           # e.g. 5-1 pen.
  SCORE__FT_HT__RE,        # e.g. 1-1 (1-0)
  ##  note - keep basic score as its own token!!!!
  ##   that is, SCORE & SCORE_MORE
  ### SCORE__FT__RE,           # e.g. 1-1  -- note - must go last!!!
)

SCORE_RE   =   SCORE__FT__RE
  

end  #  class Lexer
end  # module SportDb
