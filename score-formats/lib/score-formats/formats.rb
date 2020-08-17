
module ScoreFormats

    ## todo/check: use ‹› (unicode chars) to mark optional parts in regex constant name - why? why not?

    #####
    #  english helpers (penalty, extra time, ...)
    P_EN  =  '(?: p | pen\.? | pso )'     # e.g. p, pen, pen., PSO, etc.
    ET_EN =  '(?: aet | a\.e\.t\.? )'     # note: make last . optional (e.g a.e.t) allowed too


    ##  note: allow SPECIAL cases WITHOUT full time scores (just a.e.t or pen. + a.e.t.)
    ##      3-4 pen. 2-2 a.e.t.
    ##               2-2 a.e.t.
    EN__P_ET__RE = /\b
            (?:
               (?<score1p>\d{1,2})
                 [ ]* - [ ]*          # note: sep in optional block; CANNOT use a reference
               (?<score2p>\d{1,2})
                 [ ]* #{P_EN} [ ]*
             )?            # note: make penalty (P) score optional for now
            (?<score1et>\d{1,2})
               [ ]* - [ ]*
            (?<score2et>\d{1,2})
               [ ]* #{ET_EN}
               (?=[ \]]|$)/xi    ## todo/check:  remove loakahead assertion here - why require space?
                   ## note: \b works only after non-alphanum e.g. )


    ## e.g. 3-4 pen. 2-2 a.e.t. (1-1, 1-1)  or
    ##      3-4 pen. 2-2 a.e.t. (1-1, )     or
    ##      3-4 pen. 2-2 a.e.t. (1-1)       or
    ##               2-2 a.e.t. (1-1, 1-1)  or
    ##               2-2 a.e.t. (1-1, )     or
    ##               2-2 a.e.t. (1-1)

    EN__P_ET_FT_HT__RE = /\b
               (?:
                (?<score1p>\d{1,2})
                   [ ]* - [ ]*          # note: sep in optional block; CANNOT use a reference
                (?<score2p>\d{1,2})
                   [ ]* #{P_EN} [ ]*
                )?            # note: make penalty (P) score optional for now
               (?<score1et>\d{1,2})
                   [ ]* - [ ]*
               (?<score2et>\d{1,2})
                   [ ]* #{ET_EN} [ ]*
                   \(
                   [ ]*
              (?<score1>\d{1,2})
                   [ ]* - [ ]*
              (?<score2>\d{1,2})
                   [ ]*
                (?:
                     , [ ]*
                    (?: (?<score1i>\d{1,2})
                        [ ]* - [ ]*
                        (?<score2i>\d{1,2})
                        [ ]*
                    )?
                )?              # note: make half time (HT) score optional for now
              \)
             (?=[ \]]|$)/xi    ## todo/check:  remove loakahead assertion here - why require space?
                               ## note: \b works only after non-alphanum e.g. )

    ###
    ##   special case for case WITHOUT extra time!!
    ##     same as above (but WITHOUT extra time and pen required)
    EN__P_FT_HT__RE = /\b
     (?<score1p>\d{1,2})
        [ ]* - [ ]*          # note: sep in optional block; CANNOT use a reference
     (?<score2p>\d{1,2})
        [ ]* #{P_EN} [ ]*
        \(
        [ ]*
   (?<score1>\d{1,2})
        [ ]* - [ ]*
   (?<score2>\d{1,2})
        [ ]*
     (?:
          , [ ]*
         (?: (?<score1i>\d{1,2})
             [ ]* - [ ]*
             (?<score2i>\d{1,2})
             [ ]*
         )?
     )?              # note: make half time (HT) score optional for now
   \)
  (?=[ \]]|$)/xi    ## todo/check:  remove loakahead assertion here - why require space?
                    ## note: \b works only after non-alphanum e.g. )



    ## e.g. 2-1 (1-1) or
    ##      2-1
    ## note: for now add here used in Brazil / Portugal
    ##  e.g 1x1 or 1X1 or 0x2 or 3x3  too
    ##   todo/check/fix: move to its own use PT__FT_HT etc!!!!

    EN__FT_HT__RE = /\b
              (?<score1>\d{1,2})
                [ ]* (?<sep>[x-]) [ ]*
              (?<score2>\d{1,2})
               (?:
                   [ ]* \( [ ]*
                (?<score1i>\d{1,2})
                   [ ]* \k<sep> [ ]*
                (?<score2i>\d{1,2})
                   [ ]* \)
               )?   # note: make half time (HT) score optional for now
             (?=[ \]]|$)/xi    ## todo/check:  remove loakahead assertion here - why require space?
                               ## note: \b works only after non-alphanum e.g. )


    #####
    #  deutsch / german helpers (penalty, extra time, ...)
    ## todo add more marker e.g. im Elf. or such!!!
    P_DE  =  '(?: ie | i\.e\.? )'     # e.g. iE, i.E., i.E etc.
    ET_DE =  '(?: nv | n\.v\.? )'     # e.g. nV, n.V., n.V etc.


    ## support alternate all-in-one score e.g.
    ##     i.E. 2:4, n.V. 3:3 (1:1, 1:1)  or
    ##               n.V. 3:2 (2:2, 1:2)
    DE__P_ET_FT_HT__RE = /\b
                     (?:
                     #{P_DE}
                      [ ]*
                     (?<score1p>\d{1,2})
                      [ ]* : [ ]*
                     (?<score2p>\d{1,2})
                      [ ]* (?:, [ ]*)?
                     )?   # note: make penalty (P) score optional for now
                      #{ET_DE}
                      [ ]*
                     (?<score1et>\d{1,2})
                      [ ]* : [ ]*
                     (?<score2et>\d{1,2})
                      [ ]*
                    \(
                 [ ]*
             (?<score1>\d{1,2})
                  [ ]* : [ ]*
             (?<score2>\d{1,2})
                  [ ]*
               (?:
                   , [ ]*
                   (?:
                    (?<score1i>\d{1,2})
                      [ ]* : [ ]*
                    (?<score2i>\d{1,2})
                      [ ]*
                   )?
               )?    # note: make half time (HT) score optional for now
             \)
            (?=[ \]]|$)
              /xi

    ## support all-in-one "literal form e.g.
    #  2:2 (1:1, 1:0) n.V. 5:1 i.E.   or
    #  2-2 (1-1, 1-0) n.V. 5-1 i.E.
    DE__ET_FT_HT_P__RE = /\b
               (?<score1et>\d{1,2})
                   [ ]* (?<sep>[:-]) [ ]*     ## note: for now allow : or - as separator!!
               (?<score2et>\d{1,2})
                   [ ]*
                   \(
                  [ ]*
              (?<score1>\d{1,2})
                   [ ]* \k<sep> [ ]*
              (?<score2>\d{1,2})
                   [ ]*
                (?:
                    , [ ]*
                    (?:
                     (?<score1i>\d{1,2})
                       [ ]* \k<sep> [ ]*
                     (?<score2i>\d{1,2})
                       [ ]*
                    )?
                )?    # note: make half time (HT) score optional for now
              \)
               [ ]*
               #{ET_DE}
              (?:
                [ ]*
                (?<score1p>\d{1,2})
                 [ ]* \k<sep> [ ]*
                (?<score2p>\d{1,2})
                  [ ]*
                #{P_DE}
              )?       # note: make penalty (P) score optional for now
             (?=[ \]]|$)
               /xi    ## todo/check:  remove loakahead assertion here - why require space?
                               ## note: \b works only after non-alphanum e.g. )


    ## e.g. 2:1 (1:1)  or
    ##      2-1 (1-1)  or
    ##      2:1        or
    ##      2-1
    DE__FT_HT__RE = /\b
              (?<score1>\d{1,2})
                [ ]* (?<sep>[:-]) [ ]*
              (?<score2>\d{1,2})
               (?:
                  [ ]* \( [ ]*
                      (?<score1i>\d{1,2})
                        [ ]* \k<sep> [ ]*
                      (?<score2i>\d{1,2})
                  [ ]* \)
               )?   # note: make half time (HT) score optional for now
             (?=[ \]]|$)/x    ## todo/check:  remove loakahead assertion here - why require space?
                               ## note: \b works only after non-alphanum e.g. )


#############################################
# map tables - 1) regex,  2) tag - note: order matters; first come-first matched/served


FORMATS_EN = [
  [ EN__P_ET_FT_HT__RE, '[SCORE.EN__P?_ET_(FT_HT?)]' ], # e.g. 5-1 pen. 2-2 a.e.t. (1-1, 1-0)
  [ EN__P_FT_HT__RE,    '[SCORE.EN__P_(FT_HT?)]'     ], # e.g. 5-1 pen. (1-1)
  [ EN__P_ET__RE,       '[SCORE.EN__P?_ET]'          ], # e.g. 2-2 a.e.t.  or  5-1 pen. 2-2 a.e.t.
  [ EN__FT_HT__RE,      '[SCORE.EN__FT_(HT)?]'       ], # e.g. 1-1 (1-0)
]

FORMATS_DE = [
  [ DE__ET_FT_HT_P__RE, '[SCORE.DE__ET_(FT_HT?)_P?]' ], # e.g. 2:2 (1:1, 1:0) n.V. 5:1 i.E.
  [ DE__P_ET_FT_HT__RE, '[SCORE.DE__P?_ET_(FT_HT?)]' ], # e.g. i.E. 2:4, n.V. 3:3 (1:1, 1:1)
  [ DE__FT_HT__RE,      '[SCORE.DE__FT_(HT)?]'       ], # e.g. 1:1 (1:0)
]

FORMATS = {
  en: FORMATS_EN,
  de: FORMATS_DE,
}

end # module ScoreFormats
