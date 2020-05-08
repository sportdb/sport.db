# encoding: utf-8


## note: lets follow the model of DateFormats -see DateFormats gem for more!!!


## note: make Score top-level and use like Date - why? why not?
class Score

  attr_reader :score1i,  :score2i,   # half time (ht) score
              :score1,   :score2,    # full time (ft) score
              :score1et, :score2et,  # extra time (et) score
              :score1p,  :score2p    # penalty (p) score
              ## todo/fix: add :score1agg, score2agg too - why? why not?!!!
              ##  add state too e.g. canceled or abadoned etc - why? why not?

  def initialize( *values )
    ## note: for now always assumes integers
    ##  todo/check - check/require integer args - why? why not?

    @score1i  = values[0]    # half time (ht) score
    @score2i  = values[1]

    @score1   = values[2]    # full time (ft) score
    @score2   = values[3]

    @score1et = values[4]    # extra time (et) score
    @score2et = values[5]

    @score1p  = values[6]    # penalty (p) score
    @score2p  = values[7]
  end

  def to_a
    ## todo: how to handle game w/o extra time
    #   but w/ optional penalty ???  e.g. used in copa liberatores, for example
    #    retrun 0,0 or nil,nil for extra time score ?? or -1, -1 ??
    #    for now use nil,nil
    score = []
    score += [score1i,  score2i]     if score1p || score2p || score1et || score2et || score1 || score2 || score1i || score2i
    score += [score1,   score2]      if score1p || score2p || score1et || score2et || score1 || score2
    score += [score1et, score2et]    if score1p || score2p || score1et || score2et
    score += [score1p,  score2p]     if score1p || score2p
    score
  end

end  # class Score



module ScoreFormats

  def self.parse( line ) ScoreParser.new.parse( line ); end
  def self.find!( line ) ScoreParser.new.find!( line ); end

class ScoreParser

  include LogUtils::Logging

  def initialize
    ## note: for now always use english (en) - make multi-lingual later!!!!
    @formats = FORMATS[ :en ]
  end

  def parse( line )
    score = nil
    @formats.each do |format|
      re = format[0]
      m = re.match( line )
      if m
        score = parse_matchdata( m )
        break
      end
      # no match; continue; try next regex pattern
    end

    ## todo/fix - raise ArgumentError - invalid score; no format match found
    score  # note: nil if no match found
  end # method parse

  def find!( line )
    score = nil
    @formats.each do |format|
      re  = format[0]
      tag = format[1]
      m = re.match( line )
      if m
        score = parse_matchdata( m )
        line.sub!( m[0], tag )
        break
      end
      # no match; continue; try next regex pattern
    end

    ##  todo/fix: make fallback fit into format "pipeline" - allow procs not just regexes or such !!!
    score = find_fallback!( line )   if score.nil?
    score  # note: nil if no match found
  end # method find!



  def find_fallback!( line )

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

    score1i  = nil    # half time (ht) scores
    score2i  = nil

    score1   = nil    # full time (ft) scores
    score2   = nil

    score1et = nil    # extra time (et) scores
    score2et = nil

    score1p  = nil   # penalty (p) scores
    score2p  = nil


      #######################################################
      ## try "standard" generic patterns for fallbacks

      if m = ET_RE.match( line )
        score1et = m[:score1].to_i
        score2et = m[:score2].to_i

        logger.debug "   score.et: >#{score1et}-#{score2et}<"

        line.sub!( m[0], '[SCORE.ET]' )
      end

      if m = P_RE.match( line )
        score1p = m[:score1].to_i
        score2p = m[:score2].to_i

        logger.debug "   score.p: >#{score1p}-#{score2p}<"

        line.sub!( m[0], '[SCORE.P]' )
      end

      ## let full time (ft) standard regex go last - has no marker

      if m = FT_RE.match( line )
        score1 = m[:score1].to_i
        score2 = m[:score2].to_i

        logger.debug "   score: >#{score1}-#{score2}<"

        line.sub!( m[0], '[SCORE]' )
      end

      # note: no match; return nil (and NOT score obj)!!!!
      score = if score1i  || score2i  || score1  || score2  ||
                 score1et || score2et || score1p || score2p
                Score.new( score1i,  score2i,
                           score1,   score2,
                           score1et, score2et,
                           score1p,  score2p   )
              else
                nil
              end
      score
  end  # method find_fallback!

private
  def parse_matchdata( m )
    # convert regex match_data captures to hash
    # - note: cannont use match_data like a hash (e.g. raises exception if key/name not present/found)
    h = {}
    # - note: do NOT forget to turn name into symbol for lookup in new hash (name.to_sym)
    m.names.each { |name| h[name.to_sym] = m[name] }  # or use match_data.names.zip( match_data.captures )  - more cryptic but "elegant"??

    ## puts "[parse_date_time] match_data:"
    ## pp h
    logger.debug "   [parse_matchdata] hash: >#{h.inspect}<"

    score1i   = nil    # half time (ht) scores
    score2i   = nil

    score1    = nil    # full time (ft) scores
    score2    = nil

    score1et  = nil    # extra time (et) scores
    score2et  = nil

    score1p   = nil   # penalty (p) scores
    score2p   = nil


    if h[:score1i] && h[:score2i]   ## note: half time (HT) score is optional now
      score1i   = h[:score1i].to_i
      score2i   = h[:score2i].to_i
    end

    score1 = h[:score1].to_i
    score2 = h[:score2].to_i

    if h[:score1et] && h[:score2et]
      score1et = h[:score1et].to_i
      score2et = h[:score2et].to_i
    end

    if h[:score1p] && h[:score2p]
      score1p   = h[:score1p].to_i
      score2p   = h[:score2p].to_i
    end

    score = Score.new( score1i,  score2i,
                       score1,   score2,
                       score1et, score2et,
                       score1p,  score2p   )
    score
  end  # method parse_matchdata



end  # class ScoreParser
end  # module ScoreFormats

