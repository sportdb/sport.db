#####################
# helpers for parsing & finding match status e.g.
#    - cancelled / canceled
#    - awarded
#    - abandoned
#    - replay
#    etc.


module SportDb


  ### todo/fix: move Status inside Match struct - why? why not?

  class Status
# note: use a class as an "enum"-like namespace for now - why? why not?
#   move class into Match e.g. Match::Status  - why? why not?
    CANCELLED = 'CANCELLED'   # canceled (US spelling), cancelled (UK spelling) - what to use?
    AWARDED   = 'AWARDED'
    POSTPONED = 'POSTPONED'
    ABANDONED = 'ABANDONED'
    REPLAY    = 'REPLAY'
  end # class Status


  
  #
  #  todo/fix - move self.parse to class Status e.g.
  #    use Status.parse( str ) NOT StatusParser...

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

  end # class StatusParser
end # module SportDb

