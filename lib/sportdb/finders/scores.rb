# encoding: utf-8

module SportDb

class ScoresFinder

  include LogUtils::Logging

  # e.g. 1:2 or 0:2 or 3:3  or
  #      1-1 or 0-2 or 3-3
  STD_REGEX = /\b
            (?<score1>\d{1,2})
               [:\-]
            (?<score2>\d{1,2})
           \b/x

  ## todo: add/allow english markers e.g. aet a.e.t ??

  # e.g. 1:2nV  => after extra time a.e.t
  
  ### fix: use nV or n.V.  do NOT allow nV. for example!!!
  
  # note: possible ending w/ . -> thus cannot use /b will not work w/ .; use zero look-ahead
  ET_REGEX = /\b
               (?<score1>\d{1,2})
                  [:\-]
               (?<score2>\d{1,2})
                  \s?                # allow optional space
                  n\.?V\.?           # allow optional . e.g. nV or n.V.
               (?=$|[\s\)\]])/xi

  ## todo: add/allow english markers e.g. pen or p  ??

  # e.g. 5:4iE  => penalty / after penalty a.p


  ### fix: use iE or i.E.  do NOT allow i.E or iE. for example!!!

  # note: possible ending w/ . -> thus cannot use /b will not work w/ .; use zero look-ahead
  P_REGEX = /\b
              (?<score1>\d{1,2})
                  [:\-]
              (?<score2>\d{1,2})
                  \s?                # allow optional space
                 i\.?E\.?            # allow optional . e.g. iE or i.E.
              (?=$|[\s\)\]])/xi


  ## todo: allow all-in-one "literal form a la kicker" e.g.
  #  2:2 (1:1, 1:0) n.V. 5:1 i.E.

  def initialize
    # nothing here for now
  end

  def find!( line, opts={} )

    ### fix: match all-in-one literal first, followed by
    ### fix: match nV or iE first
    ##  fix: last try std pattern

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

  end


end # class ScoresFinder

end # module SportDb