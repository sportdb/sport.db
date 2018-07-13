# encoding: utf-8

module SportDb

class ScoresFinder

  include LogUtils::Logging


  ## e.g. 3-4 pen. 2-2 a.e.t. (1-1, 1-1)
  EN__P_ET_FT_HT__REGEX = /\b
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
            (?<score1i>\d{1,2})
               -
            (?<score2i>\d{1,2})
               \)
           (?=[\s\]]|$)/xi    ## todo/check:  remove loakahead assertion here - why require space?
                             ## note: \b works only after non-alphanum e.g. )


  ## e.g. 2-1 a.e.t. (1-1, 0-0)
  EN__ET_FT_HT__REGEX = /\b
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
            (?<score1i>\d{1,2})
               -
            (?<score2i>\d{1,2})
               \)
           (?=[\s\]]|$)/xi    ## todo/check:  remove loakahead assertion here - why require space?
                             ## note: \b works only after non-alphanum e.g. )


  ## e.g. 2-1 (1-1)
  EN__FT_HT__REGEX = /\b
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



###################
# more

  # e.g. 1:2 or 0:2 or 3:3  or
  #      1-1 or 0-2 or 3-3
  FT_REGEX = /\b
            (?<score1>\d{1,2})
               [:\-]
            (?<score2>\d{1,2})
           \b/x


  # e.g. 1:2nV  => after extra time a.e.t

  # note: possible ending w/ . -> thus cannot use /b will not work w/ .; use zero look-ahead
  ET_REGEX = /\b
               (?<score1>\d{1,2})
                  [:\-]
               (?<score2>\d{1,2})
                  \s?                # allow optional space
                (?:nv|n\.v\.|aet|a\.e\.t\.)        # allow optional . e.g. nV or n.V.
               (?=[\s\)\]]|$)/xi

  ## todo: add/allow english markers e.g. pen or p  ??

  # e.g. 5:4iE  => penalty / after penalty a.p


  # note: possible ending w/ . -> thus cannot use /b will not work w/ .; use zero look-ahead
  P_REGEX = /\b
              (?<score1>\d{1,2})
                  [:\-]
              (?<score2>\d{1,2})
                  \s?                # allow optional space
                (?:iE|i\.E\.|p|pen|PSO)       # allow optional . e.g. iE or i.E.
              (?=[\s\)\]]|$)/xi


  ## todo: allow all-in-one "literal form a la kicker" e.g.
  #  2:2 (1:1, 1:0) n.V. 5:1 i.E.

  def initialize
    # nothing here for now
  end

  def find!( line, opts={} )

    ### fix: add and match all-in-one literal first, followed by

    # note: always call after find_dates !!!
    #  scores match date-like patterns!!  e.g. 10-11  or 10:00 etc.
    #   -- note: score might have two digits too

    ### fix: depending on language allow 1:1 or 1-1
    ##   do NOT allow mix and match
    ##  e.g. default to en is  1-1
    ##    de is 1:1 etc.


    # extract score from line
    # and return it
    # note: side effect - removes date from line string


    score1i   = nil    # half time (ht) scores
    score2i   = nil

    score1   = nil    # full time (ft) scores
    score2   = nil

    score1et = nil    # extra time (et) scores
    score2et = nil

    score1p  = nil   # penalty (p) scores
    score2p  = nil


    if (md = EN__P_ET_FT_HT__REGEX.match( line ))
      score1i   = md[:score1i].to_i
      score2i   = md[:score2i].to_i
      score1    = md[:score1].to_i
      score2    = md[:score2].to_i
      score1et  = md[:score1et].to_i
      score2et  = md[:score2et].to_i
      score1p   = md[:score1p].to_i
      score2p   = md[:score2p].to_i

      logger.debug "   score.en__p_et_ft_ht: >#{score1p}-#{score2p} pen. #{score1et}-#{score2et} a.e.t. (#{score1}-#{score2}, #{score1i}-#{score2i})<"

      line.sub!( md[0], '[SCORES.EN__P_ET_FT_HT]' )

    elsif (md = EN__ET_FT_HT__REGEX.match( line ))
      score1i   = md[:score1i].to_i
      score2i   = md[:score2i].to_i
      score1    = md[:score1].to_i
      score2    = md[:score2].to_i
      score1et  = md[:score1et].to_i
      score2et  = md[:score2et].to_i

      logger.debug "   score.en__et_ft_ht: >#{score1et}-#{score2et} a.e.t. (#{score1}-#{score2}, #{score1i}-#{score2i})<"

      line.sub!( md[0], '[SCORES.EN__ET_FT_HT]' )

    elsif (md = EN__FT_HT__REGEX.match( line ))
      score1i = md[:score1i].to_i
      score2i = md[:score2i].to_i
      score1  = md[:score1].to_i
      score2  = md[:score2].to_i

      logger.debug "   score.en__ft_ht: >#{score1}-#{score2} (#{score1i}-#{score2i})<"

      line.sub!( md[0], '[SCORES.EN__FT_HT]' )
    else
      #######################################################
      ## try "standard" generic patterns for fallbacks

      if (md = ET_REGEX.match( line ))
        score1et = md[:score1].to_i
        score2et = md[:score2].to_i

        logger.debug "   score.et: >#{score1et}-#{score2et}<"

        line.sub!( md[0], '[SCORE.ET]' )
      end

      if (md = P_REGEX.match( line ))
        score1p = md[:score1].to_i
        score2p = md[:score2].to_i

        logger.debug "   score.p: >#{score1p}-#{score2p}<"

        line.sub!( md[0], '[SCORE.P]' )
      end

      ## let full time (ft) standard regex go last - has no marker

      if (md = FT_REGEX.match( line ))
        score1 = md[:score1].to_i
        score2 = md[:score2].to_i

        logger.debug "   score: >#{score1}-#{score2}<"

        line.sub!( md[0], '[SCORE]' )
      end
    end

    ## todo: how to handle game w/o extra time
    #   but w/ optional penalty ???  e.g. used in copa liberatores, for example
    #    retrun 0,0 or nil,nil for extra time score ?? or -1, -1 ??
    #    for now use nil,nil

    scores = []
    scores += [score1i, score2i]     if score1p || score2p || score1et || score2et || score1 || score2 || score1i || score2i
    scores += [score1, score2]       if score1p || score2p || score1et || score2et || score1 || score2
    scores += [score1et, score2et]   if score1p || score2p || score1et || score2et
    scores += [score1p,  score2p]    if score1p || score2p

    scores
  end

end # class ScoresFinder

end # module SportDb
