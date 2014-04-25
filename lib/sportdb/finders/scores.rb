# encoding: utf-8

module SportDb

class ScoresFinder

  include LogUtils::Logging

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
                (?:nV|n\.V\.|aet|a\.e\.t\.)        # allow optional . e.g. nV or n.V.
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
    # NB: side effect - removes date from line string

    score1   = nil
    score2   = nil
    
    score1et = nil
    score2et = nil
    
    score1p  = nil
    score2p  = nil

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

    ## todo: how to handle game w/o extra time
    #   but w/ optional penalty ???  e.g. used in copa liberatores, for example
    #    retrun 0,0 or nil,nil for extra time score ?? or -1, -1 ??
    #    for now use nil,nil

    scores = []
    scores += [score1, score2]       if score1p || score2p || score1et || score2et || score1 || score2
    scores += [score1et, score2et]   if score1p || score2p || score1et || score2et 
    scores += [score1p,  score2p]    if score1p || score2p

    scores
  end

end # class ScoresFinder

end # module SportDb