#####################
# helpers for parsing & finding match status e.g.
#    - canceled / cancelled
#    - awarded
#    - abadoned
#    - replay
#    etc.


module SportDb


 class StatusParser
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

        ## note: english usage - cancelled (in UK), canceled (in US)

        status =  if text =~ /^(cancelled|
                                canceled|
                                can\.
                               )/xi
                             'CANCELLED'
                  elsif text =~ /^(awarded|
                                   awd\.
                                  )/xi
                             'AWARDED'
                  elsif text =~ /^(postponed
                                  )/xi
                             'POSTPONED'
                  elsif text =~ /^(abandoned|
                                   abd\.
                                  )/xi
                             'ABANDONED'
                  elsif text =~ /^(replay
                                  )/xi
                             'REPLAY'
                  else
                          # no match; continue searching
                          nil
                  end

            if status
              line.sub!( match_str, "[STATUS.#{status}]" )
              break
            end
      end  # while match

      status
    end # method find!
 end # class StatusParser

end # module SportDb