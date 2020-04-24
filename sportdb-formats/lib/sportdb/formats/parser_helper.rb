
module SportDb
  module ParserHelper


  def read_lines( txt )   ## todo/check:  add alias preproc_lines or build_lines or prep_lines etc. - why? why not?
    ## returns an array of lines with comments and empty lines striped / removed
    lines = []
    txt.each_line do |line|    ## preprocess
       line = line.strip

       next if line.empty? || line.start_with?('#')   ###  skip empty lines and comments
       line = line.sub( /#.*/, '' ).strip             ###  cut-off end-of line comments too
       lines << line
    end
    lines
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

  def is_round_def?( line )
    ## must include bar (|) marker (make required)
    ## todo/fix:  use split('|') and check is_round? only on left hand side!!!! not whole line
    line =~ /\|/ && is_round?( line )
  end




  def is_group?( line )
    # NB: check after is_round? (round may contain group reference!)
    ## note: =~ return nil if not match found, and 0,1, etc for match
    (line =~ SportDb.lang.regex_group) != nil
  end

  def is_group_def?( line )
    # NB: check after is_round? (round may contain group reference!)
    ## must include bar (|) marker (make required)
    ## todo/fix:  use split('|') and check is_round? only on left hand side!!!! not whole line
    line =~ /\|/ && is_group?( line )
  end

  end  # module ParserHelper
end   # module SportDb

