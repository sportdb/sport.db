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

  def self.lang
    @@lang ||= :en            ## defaults to english (:en)
  end
  def self.lang=( value )
    @@lang = value.to_sym    ## note: make sure lang is always a symbol for now (NOT a string)
    @@lang      ## todo/check: remove  =() method always returns passed in value? double check
  end


  def self.parser( lang: )  ## find parser
    lang = lang.to_sym  ## note: make sure lang is always a symbol for now (NOT a string)

    ## note: cache all "built-in" lang versions (e.g. formats == nil)
    @@parser ||= {}
    parser = @@parser[ lang ] ||= ScoreParser.new( lang: lang )
  end

  def self.parse( line, lang: ScoreFormats.lang )
    parser( lang: lang ).parse( line )
  end

  def self.find!( line, lang: ScoreFormats.lang )
    parser( lang: lang ).find!( line )
  end


class ScoreParser

  include LogUtils::Logging

  def initialize( lang: )
    @lang    = lang.to_sym   ## note: make sure lang is always a symbol for now (NOT a string)

    ## fallback to english if lang not available
    ##  todo/fix: add/issue warning - why? why not?
    @formats = FORMATS[ @lang ] || FORMATS[ :en ]
  end


  def parse( line )

     ##########
     ## todo/fix/check: add unicode to regular dash conversion - why? why not?
     ##  e.g. – becomes -  (yes, the letters a different!!!)
     #############

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

    score  # note: nil if no match found
  end # method find!

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

    if h[:score1] && h[:score2]     ## note: full time (FT) score can be optional too!!!
      score1 = h[:score1].to_i
      score2 = h[:score2].to_i
    end

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

