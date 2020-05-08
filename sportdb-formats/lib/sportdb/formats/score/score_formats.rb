
module ScoreFormats

    ## e.g. 3-4 pen. 2-2 a.e.t. (1-1, 1-1)  or
    ##      3-4 pen. 2-2 a.e.t. (1-1, )
    EN__P_ET_FT_HT__RE = /\b
               (?<score1p>\d{1,2})
                     -
               (?<score2p>\d{1,2})
                   \s*                # allow optional spaces
               (?:p|pen\.?|pso)       # e.g. pen, pen., PSO, p etc.
                   \s*                # allow optional spaces
               (?<score1et>\d{1,2})
                     -
               (?<score2et>\d{1,2})
                   \s*                # allow optional spaces
               (?:aet|a\.e\.t\.)
                   \s*                # allow optional spaces
                   \(
              (?<score1>\d{1,2})
                   -
              (?<score2>\d{1,2})
                  \s*
                  ,
                  \s*
                (?:
                    (?<score1i>\d{1,2})
                      -
                    (?<score2i>\d{1,2})
                )?    # note: make half time (HT) score optional for now
              \)
             (?=[\s\]]|$)/xi    ## todo/check:  remove loakahead assertion here - why require space?
                               ## note: \b works only after non-alphanum e.g. )


    ## e.g. 2-1 a.e.t. (1-1, 0-0)  or
    ##      2-1 a.e.t. (1-1, )
    EN__ET_FT_HT__RE = /\b
               (?<score1et>\d{1,2})
                     -
               (?<score2et>\d{1,2})
                   \s*                # allow optional spaces
               (?:aet|a\.e\.t\.)
                   \s*                # allow optional spaces
                   \(
              (?<score1>\d{1,2})
                   -
              (?<score2>\d{1,2})
                  \s*
                  ,
                  \s*
                (?:
                  (?<score1i>\d{1,2})
                    -
                  (?<score2i>\d{1,2})
                )?    # note: make half time (HT) score optional for now
              \)
             (?=[\s\]]|$)/xi    ## todo/check:  remove loakahead assertion here - why require space?
                               ## note: \b works only after non-alphanum e.g. )


    ## e.g. 2-1 (1-1)
    EN__FT_HT__RE = /\b
              (?<score1>\d{1,2})
                 -
              (?<score2>\d{1,2})
               \s*
               \(
              (?<score1i>\d{1,2})
                 -
              (?<score2i>\d{1,2})
                 \)
             (?=[\s\]]|$)/x    ## todo/check:  remove loakahead assertion here - why require space?
                               ## note: \b works only after non-alphanum e.g. )



  #######################################
  # more

    # e.g. 1:2 or 0:2 or 3:3  or
    #      1-1 or 0-2 or 3-3  or
    #      1x1 or 1X1 or 0x2 or 3x3   -- used in Brazil / Portugal
    FT_RE = /\b
              (?<score1>\d{1,2})
                 [:\-xX]
              (?<score2>\d{1,2})
             \b/x


    # e.g. 1:2nV  => after extra time a.e.t

    # note: possible ending w/ . -> thus cannot use /b will not work w/ .; use zero look-ahead
    ET_RE = /\b
                 (?<score1>\d{1,2})
                    [:\-xX]
                 (?<score2>\d{1,2})
                    \s?                # allow optional space
                  (?:nv|n\.v\.|aet|a\.e\.t\.)        # allow optional . e.g. nV or n.V.
                 (?=[\s\)\]]|$)/xi

    ## todo: add/allow english markers e.g. pen or p  ??

    # e.g. 5:4iE  => penalty / after penalty a.p


    # note: possible ending w/ . -> thus cannot use /b will not work w/ .; use zero look-ahead
    P_RE = /\b
                (?<score1>\d{1,2})
                    [:\-xX]
                (?<score2>\d{1,2})
                    \s?                # allow optional space
                  (?:iE|i\.E\.|p|pen|PSO)       # allow optional . e.g. iE or i.E.
                (?=[\s\)\]]|$)/xi


#############################################
# map tables - 1) regex,  2) tag - note: order matters; first come-first matched/served


FORMATS_EN = [
  [ EN__P_ET_FT_HT__RE, '[SCORES.EN__P_ET_FT_HT]' ],
  [ EN__ET_FT_HT__RE,   '[SCORES.EN__ET_FT_HT]'   ],
  [ EN__FT_HT__RE,      '[SCORES.EN__FT_HT]'      ],
]

FORMATS_DE = [
  # to be done
]

FORMATS = {
  en: FORMATS_EN,
  de: FORMATS_DE,
}

end # module ScoreFormats
