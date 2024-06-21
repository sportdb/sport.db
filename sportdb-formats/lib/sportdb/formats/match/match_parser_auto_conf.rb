
module SportDb


class AutoConfParser     ## todo/check: rename/change to MatchAutoConfParser - why? why not?

  def self.parse( lines, start: )
    ##  todo/fix: add support for txt and lines
    ##    check if lines_or_txt is an array or just a string
    parser = new( lines, start )
    parser.parse
  end


  include Logging         ## e.g. logger#debug, logger#info, etc.
  include ParserHelper    ## e.g. read_lines, etc.


  def initialize( lines, start )
    # for convenience split string into lines
    ##    note: removes/strips empty lines
    ## todo/check: change to text instead of array of lines - why? why not?
 
    ## note - wrap in enumerator/iterator a.k.a lines reader
    @lines = LinesReader.new( lines.is_a?( String ) ?
                                 read_lines( lines ) : 
                                 lines 
                            )
 
    @start        = start
  end


  ## note:  colon (:) MUST be followed by one (or more) spaces
  ##      make sure mon feb 12 18:10 will not match
  ##        allow 1. FC Köln etc.
  ##               Mainz 05:
  ##           limit to 30 chars max
  ##          only allow  chars incl. intl buut (NOT ()[]/;)
  ##
  ##   Group A:
  ##   Group B:   - remove colon
  ##    or lookup first

  ATTRIB_REGEX = /^  
                   [ ]*?     # slurp leading spaces
                (?<key>[^:|\]\[()\/; -]
                       [^:|\]\[()\/;]{0,30}
                 )
                   [ ]*?     # slurp trailing spaces
                   :[ ]+
                (?<value>.+)
                    [ ]*?   # slurp trailing spaces
                   $
                /ix


  def parse
    ## try to  find all teams in match schedule
    @last_round   = nil
    @last_group   = nil

    ## definitions/defs
    @round_defs = Hash.new(0)
    @group_defs = Hash.new(0)

    ## usage/refs
    @rounds       = {}           ## track usage counter and match (two teams) counter
    @groups       = {}           ##  -"-

    @teams        = Hash.new(0)   ## keep track of usage counter

    ## note: ground incl. optional city (timezone) etc. - why? why not?
    @grounds      = Hash.new(0)    
  
    @warns        = []    ## track list of warnings (unmatched lines)  too - why? why not?


  ## todo/fix - use @lines.rewind first  here - why? why not?   
    @lines.each do |line|
      if is_round_def?( line )
        ## todo/fix:  add round definition (w begin n end date)
        ## todo: do not patch rounds with definition (already assume begin/end date is good)
        ##  -- how to deal with matches that get rescheduled/postponed?
        logger.debug "skipping matched round def line: >#{line}<"
        @round_defs[ line ] += 1
      elsif is_round?( line )
        logger.debug "skipping matched round line: >#{line}<"

        round = @rounds[ line ] ||= {count: 0, match_count: 0}   ## usage counter, match counter
        round[:count] +=1
        @last_round = round
      elsif is_group_def?( line ) ## NB: group goes after round (round may contain group marker too)
        ### todo: add pipe (|) marker (required)
        logger.debug "skipping matched group def line: >#{line}<"
        @group_defs[ line ] += 1
      elsif is_group?( line )
        ##  -- lets you set group  e.g. Group A etc.
        logger.debug "skipping matched group line: >#{line}<"

        group = @groups[ line ] ||= {count: 0, match_count: 0}
        group[:count] +=1
        @last_group = group
        ## todo/fix:  parse group line!!!
      elsif m=ATTRIB_REGEX.match( line )
        ## note: check attrib regex AFTER group def e.g.:
        ##         Group A: 
        ##         Group B:  etc.
        ##     todo/fix - change Group A: to Group A etc.
        ##                       Group B: to Group B

        ## check if line ends with dot
        ##  if not slurp up lines to the next do!!!
        logger.debug "skipping key/value line - >#{line}<"
        while !line.end_with?( '.' ) || line.nil? do
            line = @lines.next
            logger.debug "skipping key/value line (cont.) - >#{line}<"
        end        
      elsif is_goals?( line )
        ## note - goals must be AFTER attributes!!!
        logger.debug "skipping matched goals line: >#{line}<"
      elsif try_parse_game( line )
        # do nothing here
      else
        logger.warn "skipping line (no match found): >#{line}<"
        @warns << line
      end
    end # lines.each

    ## new - add grounds and cities
    [@teams, @rounds, @groups, @round_defs, @group_defs,
     @grounds,  ## note: ground incl. optional city (timezone) etc. 
     @warns]
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
    return true if line.empty?    ## note: return true (for valid line with no match/teams)


    ## split by geo (@) - remove for now
    values = line.split( '@' )

    ### check for ground/stadium and cities
    if values.size == 1
       ## no stadium
    elsif values.size == 2   # bingo!!!
       ## process stadium, city (timezone) etc.
       ## for now keep it simple - pass along "unparsed" all-in-one
       ground = values[1].gsub( /[ \t]+/, ' ').strip   ## squish
       @grounds[ ground ] += 1
    else
       puts "!! ERROR - too many @-markers found in line:"
       puts line
       exit 1
    end

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

    return true if line.empty?    ## note: return true (for valid line with no match/teams)


    score = find_score!( line )

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

     return true    if values.size == 0  ## note: return true (for valid line with no match/teams)

     if values.size == 1
       puts "(auto config) try matching teams separated by spaces (2+):"
       pp values

       values = values[0].split( /[ ]{2,}/ )
       pp values
     end

     return false   if values.size != 2

     puts "(auto config) try matching teams:"
     pp values

     @teams[ values[0] ] += 1    ## update usage counters
     @teams[ values[1] ] += 1

     @last_round[ :match_count ] += 1    if @last_round
     @last_group[ :match_count ] += 1    if @last_group

     true
  end



  def find_score!( line )
    # note: always call after find_dates !!!
    #  scores match date-like patterns!!  e.g. 10-11  or 10:00 etc.
    #   -- note: score might have two digits too
    ScoreFormats.find!( line )
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
