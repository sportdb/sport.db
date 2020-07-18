#####################
# helpers for parsing & finding match status e.g.
#    - cancelled / canceled
#    - awarded
#    - abandoned
#    - replay
#    etc.


module SportDb

  class Status
# note: use a class as an "enum"-like namespace for now - why? why not?
#   move class into Match e.g. Match::Status  - why? why not?
    CANCELLED = 'CANCELLED'   # canceled (US spelling), cancelled (UK spelling) - what to use?
    AWARDED   = 'AWARDED'
    POSTPONED = 'POSTPONED'
    ABANDONED = 'ABANDONED'
    REPLAY    = 'REPLAY'
  end # class Status



  class StatusParser

    def self.parse( str )
      ## note: returns nil if no match found
      ## note: english usage - cancelled (in UK), canceled (in US)
      if str =~ /^(cancelled|
                   canceled|
                   can\.
                  )/xi
        Status::CANCELLED
      elsif str =~ /^(awarded|
                       awd\.
                      )/xi
        Status::AWARDED
      elsif str =~ /^(postponed
                      )/xi
        Status::POSTPONED
      elsif str =~ /^(abandoned|
                       abd\.
                      )/xi
        Status::ABANDONED
      elsif str =~ /^(replay
                      )/xi
        Status::REPLAY
      else
        # no match
        nil
      end
    end


    RUN_RE = /\[
                 (?<text>[^\]]+)
               \]
             /x
    def self.find!( line )
      ## for now check all "protected" text run blocks e.g. []
      ##  puts "line: >#{line}<"

      status = nil

      str = line
      while m = str.match( RUN_RE )
        str = m.post_match  ## keep on processing rest of line/str (a.k.a. post match string)

        ## check for status match
        match_str = m[0]  ## keep a copy of the match string (for later sub)
        text = m[:text].strip
        ## puts "  text: >#{text}<"

        status = parse( text )

        if status
           line.sub!( match_str, "[STATUS.#{status}]" )
           break
        end
      end  # while match

      status
    end # method find!
 end # class StatusParser

end # module SportDb