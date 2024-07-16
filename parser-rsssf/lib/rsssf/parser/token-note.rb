module Rsssf
class Parser
    

###
##  move to token-note(s) file !!!!
##

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
          (?:
             postponed    
             ## e.g. [postponed due to problems with the screen of the stadium]
             ##      [postponed by storm]
             ##      [postponed due to tropical storm "Hanna"]
             ##      [postponed from Sep 10-12 due to death Queen Elizabeth II]
             ##     [postponed]  -- include why? why not?
             |
             awarded
             ## e.g. [awarded match to Leones Negros by undue alignment; original result 1-2]
             ##     [awarded 3-0 to Cafetaleros by undue alignment; originally ended 2-0]
             ##     [awarded 3-0; originally 0-2, América used ineligible player (Federico Viñas)]
             |
             abandoned
             ## e.g. [abandoned at 1-1 in 65' due to cardiac arrest Luton player Tom Lockyer]
             ##      [abandoned at 0-0 in 6' due to waterlogged pitch]
             ##     [abandoned at 5-0 in 80' due to attack on assistant referee by Cerro; result stood]
             ##    [abandoned at 1-0 in 31']
             ##    [abandoned at 0-1' in 85 due to crowd trouble]
             |
              suspended
              ## e.g. [suspended at 0-0 in 12' due to storm]  
              ##      [suspended at 84' by storm; result stood]
              |
              annulled
              ## e.g.  [annulled]
              |
              replay
              ## e.g.  [replay]
          )
        ([ ]    ## note - optional text
          [^\]]+?
         )?         ## slurp all to next ] - (use non-greedy) 
      )
    )    # note capture    
     \] 
}ix


    
end  #   class Parser    
end  #   module Rsssf
        