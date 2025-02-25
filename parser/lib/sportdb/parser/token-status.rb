module SportDb
class Lexer
  
##  (match) status
##    note: english usage - cancelled (in UK), canceled (in US)
##
##  add more variants - why? why not?


STATUS_RE = %r{
            \[
      (?:    
            ### opt 1 - allow long forms with note/comment for some stati
           (?: (?<status> awarded
             ## e.g. [awarded match to Leones Negros by undue alignment; original result 1-2]
             ##     [awarded 3-0 to Cafetaleros by undue alignment; originally ended 2-0]
             ##     [awarded 3-0; originally 0-2, América used ineligible player (Federico Viñas)]
                            |
                          annulled
                            |
                          abandoned
             ## e.g. [abandoned at 1-1 in 65' due to cardiac arrest Luton player Tom Lockyer]
             ##      [abandoned at 0-0 in 6' due to waterlogged pitch]
             ##     [abandoned at 5-0 in 80' due to attack on assistant referee by Cerro; result stood]
             ##    [abandoned at 1-0 in 31']
             ##    [abandoned at 0-1' in 85 due to crowd trouble]
                            |
                          postponed
             ## e.g. [postponed due to problems with the screen of the stadium]
             ##      [postponed by storm]
             ##      [postponed due to tropical storm "Hanna"]
             ##      [postponed from Sep 10-12 due to death Queen Elizabeth II]
                           |
                        suspended
             ## e.g. [suspended at 0-0 in 12' due to storm]  
             ##      [suspended at 84' by storm; result stood]
                           |
                         verified
             ## e.g.  [verified 2:0 wo.]
   

               ) [ ;,]* (?<status_note> [^\]]+ )
                 [ ]*
            )
            |
        
            ## opt 2 - short from only (no note/comments)
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
                 |
               suspended    ### todo/fix - add status upstream - why? why not?
                            ###  move to note(s) - do NOT interpret as status - why? why not?
                 |
               verified     ### todo/fix - add status upstream (same as ??) - why? why not? 
                            ###  move to note(s) - do NOT interpret as status - why? why not?
            )
      )
    \]
}ix




###
## todo/fix - move to token-note.rb (standalone) file 

NOTE_RE = %r{
    \[ 
   (?<note>
     (?:  ##  starting with ___   PLUS requiring more text
       (?:
          nb:
          ##  e.g. [NB: between top-8 of regular season]
          #        [NB: América, Morelia and Tigres qualified on better record regular season]
          #        [NB: Celaya qualified on away goals]
          #        [NB: Alebrijes qualified on away goal]
          #        [NB: Leones Negros qualified on away goals]
          #
          # todo/fix:
          # add "top-level" NB: version
          ##   with full (end-of) line note - why? why not?
          |
          (?: originally[ ])? scheduled
          ## e.g. [originally scheduled to play in Mexico City] 
          |
          rescheduled
          ## e.g.  [Rescheduled due to earthquake occurred in Mexico on September 19]
          |
          remaining
          ## e.g. [remaining 79']   
          ##      [remaining 84'] 
          ##      [remaining 59']   
          ##      [remaining 5']
          |
          played  
          ## e.g. [played in Macaé-RJ]
          ##      [played in Caxias do Sul-RS]
          ##      [played in Sete Lagoas-MG]
          ##      [played in Uberlândia-MG]
          ##      [played in Brasília-DF]
          ##      [played in Vöcklabruck]
          ##      [played in Pasching]
          |
          declared
          ## e.g.  [declared void]
          |
          inter-group
          ## e.g. [inter-group A-B]
          ##      [inter-group C-D]
       )
      [ ]
      [^\]]+?    ## slurp all to next ] - (use non-greedy) 
     )
      |
     (?:
       ## starting with in  - do NOT allow digits
       ##   name starting with in possible - why? why not?
           in[ ]
            [^0-9\]]+?
       ## e.g. [In Estadio La Corregidora] 
       ##      [in Unidad Deportiva Centenario]
       ##      [in Estadio Olímpico Universitario]
       ##      [in Estadio Victoria]
       ##      [in UD José Brindis]
       ##      [in Colomos Alfredo "Pistache" Torres stadium]
     )
       |
      (?:
         ## e.g. Spain wins on penalties
         ##       1860 München wins on penalties etc.
         ##   must start with digit 1-9 or letter
         ##     todo - add more special chars - why? why not?
            [1-9\p{L}][0-9\p{L} .-]+?    
            [ ]wins[ ]on[ ]penalties
             [^\]]*?   ## use non-greedy
      )
   )
   \] 
}ix    


end  #  class Lexer
end  # module SportDb
  