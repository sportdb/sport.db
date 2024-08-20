
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
    ## note: =~ returns nil if not match found, and 0,1, etc for match

    ##  note: allow "free standing" leg 1 and leg 2 too
    ##         (e.g. Hinspiel, Rückspiel etc. used for now in Relegation, for example)
    ##    note ONLY allowed if "free standing", that is, full line with nothing else
    ##          use "custom" regex for special case for now
    ##               avoids match HIN in PascHINg, for example (hin in german for leg 1)
    line =~ SportDb.lang.regex_round    ||
    line =~ /^(#{SportDb.lang.leg1})$/i ||
    line =~ /^(#{SportDb.lang.leg2})$/i
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
    # note: check after is_round? (round may contain group reference!)
    ## note: =~ return nil if not match found, and 0,1, etc for match
    (line =~ SportDb.lang.regex_group) != nil
  end

  def is_group_def?( line )
    # note: check after is_round? (round may contain group reference!)
    ## must include bar (|) marker (make required)
    ## todo/fix:  use split('|') and check is_round? only on left hand side!!!! not whole line
    line =~ /\|/ && is_group?( line )
  end


  def is_goals?( line )
    # check if is goals line
    #  e.g. looks like
    #   Neymar 29', 71' (pen.) Oscar 90+1';  Marcelo 11' (o.g.)
    #  check for
    #    <space>90'  or
    #    <space>90+1'

    line =~ /[ ](\d{1,3}\+)?\d{1,3}'/
  end


  end  # module ParserHelper
end   # module SportDb

