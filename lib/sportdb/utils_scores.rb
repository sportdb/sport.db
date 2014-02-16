# encoding: utf-8

module SportDb
  module FixtureHelpers


  def find_scores!( line )

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
    
    # note: regex should NOT match regex extra time or penalty
    #  thus, we do NOT any longer allow spaces for now between
    #   score and marker (e.g. nV,iE, etc.)

    # e.g. 1:2 or 0:2 or 3:3 // 1-1 or 0-2 or 3-3
    regex = /\b(\d{1,2})[:\-](\d{1,2})\b/

    ## todo: add/allow english markers e.g. aet ??

    ## fix: use case insansitive flag instead e.g. /i
    #    instead of [nN] etc.

    # e.g. 1:2nV  => after extra time a.e.t
    regex_et = /\b(\d{1,2})[:\-](\d{1,2})[nN][vV]\b/

    # e.g. 5:4iE  => penalty / after penalty a.p
    regex_p = /\b(\d{1,2})[:\-](\d{1,2})[iI][eE]\b/

    scores = []

    ## todo: how to handle game w/o extra time
    #   but w/ optional penalty ???  e.g. used in copa liberatores, for example
    #    retrun 0,0 or nil,nil for extra time score ?? or -1, -1 ??
    #    for now use nil,nil

    if line =~ regex
      logger.debug "   score: >#{$1}-#{$2}<"
      
      line.sub!( regex, '[SCORE]' )

      scores << $1.to_i
      scores << $2.to_i
    end

    ## todo:
    ##   reverse matching order ??? allows us to support spaces for nV and iE
    ##    why? why not??

    if line =~ regex_et
      logger.debug "   score.et: >#{$1}-#{$2}<"
      
      line.sub!( regex_et, '[SCORE.ET]' )

      ## check scores empty? - fill with nil,nil
      scores += [nil,nil]  if scores.size == 0

      scores << $1.to_i
      scores << $2.to_i
    end

    if line =~ regex_p
      logger.debug "   score.p: >#{$1}-#{$2}<"
      
      line.sub!( regex_p, '[SCORE.P]' )

      ## check scores empty? - fill with nil,nil
      scores += [nil,nil]  if scores.size == 0
      scores += [nil,nil]  if scores.size == 2

      scores << $1.to_i
      scores << $2.to_i
    end
    scores
  end # methdod find_scores!


  end # module FixtureHelpers
end # module SportDb

