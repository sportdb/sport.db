# encoding: utf-8

module SportDb
  module FixtureHelpers

  def is_round_def?( line )
    ## must include bar (|) marker (make required)
    line =~ /\|/ && is_round?( line ) 
  end

  def is_round?( line )
    ## note: =~ return nil if not match found, and 0,1, etc for match
    (line =~ SportDb.lang.regex_round) != nil
  end

  def is_knockout_round?( line )

    ## todo: check for adding ignore case for regex (e.g. 1st leg/1st Leg)

    if line =~ SportDb.lang.regex_leg1
      logger.debug "  two leg knockout; skip knockout flag on first leg"
      false
    elsif line =~ SportDb.lang.regex_knockout_round
      logger.debug "   setting knockout flag to true"
      true
    elsif line =~ /K\.O\.|K\.o\.|Knockout/
        ## NB: add two language independent markers, that is, K.O. and Knockout
      logger.debug "   setting knockout flag to true (lang independent marker)"
      true
    else
      false
    end
  end


  ##
  ## fix/todo: check that [ROUND.TITLE2] and friends do NOT use pipes (|)
  ##  change all pipes (|) to dot (.)
  ## - pipes get used for def markers!!!

  def find_round_header_title2!( line )
    ## todo/fix:
    ##  cleanup method
    ##   use  buf.index( '//' ) to split string (see found_round_def)
    ##     why? simpler why not?
    ##  - do we currently allow groups if title2 present? add example if it works?


    # assume everything after // is title2 - strip off leading n trailing whitespaces
    regex = /\/{2,}\s*(.+)\s*$/
    if line =~ regex
      logger.debug "   title2: >#{$1}<"
      
      line.sub!( regex, '[ROUND.TITLE2]' )
      return $1
    else
      return nil    # no round title2 found (title2 is optional)
    end
  end


  def find_round_header_title!( line )
    # assume everything left is the round title
    #  extract all other items first (round title2, round pos, group title n pos, etc.)

    ## todo/fix:
    ##  cleanup method
    ##   use  buf.index( '//' ) to split string (see found_round_def)
    ##     why? simpler why not?
    ##  - do we currently allow groups if title2 present? add example if it works?

    buf = line.dup
    logger.debug "  find_round_header_title! line-before: >>#{buf}<<"

    buf.gsub!( /\[[^\]]+\]/, '' )   # e.g. remove [ROUND.POS], [ROUND.TITLE2], [GROUP.TITLE+POS] etc.
    buf.sub!( /\s+[\/\-]{1,}\s+$/, '' )    # remove optional trailing / or / chars (left over from group)
    buf.strip!    # remove leading and trailing whitespace

    logger.debug "  find_round_title! line-after: >>#{buf}<<"

    ### bingo - assume what's left is the round title

    logger.debug "   title: >>#{buf}<<"
    line.sub!( buf, '[ROUND.TITLE]' )

    buf
  end


  def find_round_def_title!( line )
    # assume everything before pipe (\) is the round title
    #  strip [ROUND.POS],  todo:?? [ROUND.TITLE2]

    # todo/fix: add title2 w/  // or /  why? why not?
    #  -- strip / or / chars

    buf = line.dup
    logger.debug "  find_round_def_title! line-before: >>#{buf}<<"

    ## cut-off everything after (including) pipe (|)
    buf = buf[ 0...buf.index('|') ]

    # e.g. remove [ROUND.POS], [ROUND.TITLE2], [GROUP.TITLE+POS] etc.
    buf.gsub!( /\[[^\]]+\]/, '' )    ## fix: use helper for (re)use e.g. remove_match_placeholder/marker or similar?
    # remove leading and trailing whitespace
    buf.strip!

    logger.debug "  find_round_def_title! line-after: >>#{buf}<<"

    logger.debug "   title: >>#{buf}<<"
    line.sub!( buf, '[ROUND.TITLE]' )

    buf
  end


  def find_round_pos!( line )
    ## fix/todo:
    ##  if no round found assume last_pos+1 ??? why? why not?

    # extract optional round pos from line
    # e.g.  (1)   - must start line 
    regex_pos = /^[ \t]*\((\d{1,3})\)[ \t]+/

 
    #### fix:
    ## use/make keywords required
    # e.g. Round of 16  -> should NOT match 16!
    # Round 16 - ok
    #  thus, check for required keywords

    ## find free standing number
    # note: /\b(\d{1,3})\b/
    #   will match -12
    #  thus, use space required - will NOT match  -2 e.g. Group-2 Play-off
    regex_num = /(?:^|\s)(\d{1,3})(?:\s|$)/

    if line =~ regex_pos
      logger.debug "   pos: >#{$1}<"
      
      line.sub!( regex_pos, '[ROUND.POS] ' )  ## NB: add back trailing space that got swallowed w/ regex -> [ \t]+
      return $1.to_i
    elsif line =~ regex_num
      ## assume number in title is pos (e.g. Jornada 3, 3 Runde etc.)
      ## NB: do NOT remove pos from string (will get removed by round title)
      logger.debug "   pos: >#{$1}<"
      return $1.to_i
    else
      ## fix: add logger.warn no round pos found in line
      return nil
    end
  end # method find_round_pos!


  end # module FixtureHelpers
end # module SportDb