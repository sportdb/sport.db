# encoding: utf-8

module SportDb
  module FixtureHelpers


  def find_record_comment!( line )
    # assume everything left after the last record marker,that is, ] is a record comment

    regex = /]([^\]]+?)$/   # NB: use non-greedy +?

    if line =~ regex
      value = $1.strip
      return nil if value.blank?   # skip whitespaces only

      logger.debug "   comment: >#{value}<"

      line.sub!( value, '[REC.COMMENT] ' )
      return value
    else
      return nil
    end
  end


  def find_record_timeline!( line )

    #  +1 lap or +n laps
    regex_laps = /\s+\+\d{1,2}\s(lap|laps)\b/

    #  2:17:15.123
    regex_time = /\b\d{1,2}:\d{2}:\d{2}\.\d{1,3}\b/

    #  +40.1 secs
    regex_secs = /\s+\+\d{1,3}\.\d{1,3}\s(secs)\b/   # NB: before \+ - boundry (\b) will not work 

    # NB: $& contains the complete matched text

    if line =~ regex_laps
      value = $&.strip
      logger.debug "   timeline.laps: >#{value}<"

      line.sub!( value, '[REC.TIMELINE.LAPS] ' ) # NB: add trailing space
      return value
    elsif line =~ regex_time
      value = $&.strip
      logger.debug "   timeline.time: >#{value}<"

      line.sub!( value, '[REC.TIMELINE.TIME] ' ) # NB: add trailing space
      return value
    elsif line =~ regex_secs
      value = $&.strip
      logger.debug "   timeline.secs: >#{value}<"

      line.sub!( value, '[REC.TIMELINE.SECS] ' ) # NB: add trailing space
      return value
    else
      return nil
    end
  end

  def find_record_laps!( line )
    # e.g.  first free-standing number w/ one or two digits e.g. 7 or 28 etc.
    regex = /\b(\d{1,2})\b/
    if line =~ regex
      logger.debug "   laps: >#{$1}<"
      
      line.sub!( regex, '[REC.LAPS] ' ) # NB: add trailing space
      return $1.to_i
    else
      return nil
    end
  end

  def find_record_leading_state!( line )
    # e.g.  1|2|3|etc or Ret  - must start line 
    regex = /^[ \t]*(\d{1,3}|Ret)[ \t]+/
    if line =~ regex
      value = $1.dup
      logger.debug "   state: >#{value}<"

      line.sub!( regex, '[REC.STATE] ' ) # NB: add trailing space
      return value
    else
      return nil
    end
  end


  end # module FixtureHelpers
end # module SportDb
