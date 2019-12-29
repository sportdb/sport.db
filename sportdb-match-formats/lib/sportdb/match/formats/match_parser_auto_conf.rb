# encoding: utf-8

module SportDb


class AutoConfParser     ## todo/check: rename/change to MatchAutoConfParser - why? why not?

  def self.parse( lines, start: )
    ##  todo/fix: add support for txt and lines
    ##    check if lines_or_txt is an array or just a string
    parser = new( lines, start )
    parser.parse
  end


  include LogUtils::Logging

  def initialize( lines, start )
     @lines        = lines     ## todo/check: change to text instead of array of lines - why? why not?
     @start        = start
  end

  def parse
    ## try to  find all clubs in match schedule
    @last_round   = nil
    @rounds       = {}           ## track usage counter and match (two clubs) counter
    @clubs        = Hash.new(0)   ## keep track of usage counter


    @lines.each do |line|
      if is_round?( line )
        logger.info "skipping matched round line: >#{line}<"

        round = @rounds[ line ] ||= {count: 0, match_count: 0}   ## usage counter, match counter
        round[:count] +=1
        @last_round = round
      elsif try_parse_game( line )
        # do nothing here
      else
        logger.warn "skipping line (no match found): >#{line}<"
      end
    end # lines.each

    [@clubs, @rounds]
  end

  def is_round?( line )
    ## note: =~ return nil if not match found, and 0,1, etc for match
    (line =~ SportDb.lang.regex_round) != nil
  end

  def try_parse_game( line )
    # note: clone line; for possible test do NOT modify in place for now
    # note: returns true if parsed, false if no match
    parse_game( line.dup )
  end

  def parse_game( line )
    logger.debug "parsing game (fixture) line: >#{line}<"

    ## remove all protected text runs e.g. []
    ##   fix: add [ to end-of-line too
    ##  todo/fix: move remove protected text runs AFTER find date!! - why? why not?

    line = line.gsub( /\[
                        [^\]]+?
                       \]/x, '' ).strip
    return true if line.empty?    ## note: return true (for valid line with no match/clubs)


    ## split by geo (@) - remove for now
    values = line.split( '@' )
    line = values[0]


    ## try find date
    date = find_date!( line, start: @start )
    if date   ## if found remove tagged run too; note using singular sub (NOT global gsub)
      line = line.sub( /\[
                          [^\]]+?
                         \]/x, '' ).strip

    else
      ##  check for leading hours only e.g.  20.30 or 20:30 or 20h30 or 20H30 or 09h00
      ##   todo/fix: make language dependent (or move to find_date/hour etc.) - why? why not?
      line = line.sub(  %r{^           ## MUST be anchored to beginning of line
                            [012]?[0-9]
                            [.:hH]
                            [0-9][0-9]
                           (?=[ ])    ## must be followed by space for now (add end of line too - why? why not?)
                          }x, '' ).strip
    end

    return true if line.empty?    ## note: return true (for valid line with no match/clubs)


    scores = find_scores!( line )

    logger.debug "  line: >#{line}<"

    line = line.sub( /\[
                        [^\]]+?
                       \]/x, '$$' )  # note: replace first score tag with $$
    line = line.gsub( /\[
                    [^\]]+?
                   \]/x, '' )    # note: replace/remove all other score tags with nothing

     ##  clean-up  remove all text run inside () or empty () too
     line = line.gsub( /\(
                     [^)]*?
                    \)/x, '' )


     ## check for more match separators e.g. - or vs for now
     line = line.sub( / \s+
                          (   -
                            | v
                            | vs\.?    # note: allow optional dot eg. vs.
                          )
                        \s+
                       /ix, '$$' )

     values = line.split( '$$' )
     values = values.map { |value| value.strip }        ## strip spaces
     values = values.select { |value| !value.empty? }   ## remove empty strings

     return true    if values.size == 0  ## note: return true (for valid line with no match/clubs)

     if values.size == 1
       puts "(auto config) try matching clubs separated by spaces (2+):"
       pp values

       values = values[0].split( /[ ]{2,}/ )
       pp values
     end

     return false   if values.size != 2

     puts "(auto config) try matching clubs:"
     pp values

     @clubs[ values[0] ] += 1    ## update usage counters
     @clubs[ values[1] ] += 1

     @last_round[ :match_count ] += 1

     true
  end



  def find_scores!( line, opts={} )
    # note: always call after find_dates !!!
    #  scores match date-like patterns!!  e.g. 10-11  or 10:00 etc.
    #   -- note: score might have two digits too

    finder = ScoresFinder.new
    finder.find!( line, opts )
  end

  def find_date!( line, start: )
    ## NB: lets us pass in start_at/end_at date (for event)
    #   for auto-complete year

    # extract date from line
    # and return it
    # NB: side effect - removes date from line string
    DateFormats.find!( line, start: start )
  end
end # class AutoConfParser
end # module SportDb
