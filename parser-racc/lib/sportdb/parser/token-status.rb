
##  (match) status
##    note: english usage - cancelled (in UK), canceled (in US)
##
##  add more variants - why? why not?




STATUS_RE = %r{
          \[
           ### allow long forms with note/comment for some stati
           (?: (?<status> awarded
                            |
                          annulled
                            |
                          abandoned
               ) [ ;,]* (?<status_note> [^\]]+ )
                 [ ]*
            )
            |
            ## short from only (no note/comments)
            (?<status>
               cancelled|canceled|can\.
                 |
               abandoned|abd\.
                 |
               postponed
                 |
               awarded|awd\.
                 |
               replay
                 |
               annulled
            )
      \]
     }ix

