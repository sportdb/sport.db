
## use Sports (not SportDb) for module - why? why not?



module SportDb

## use module or class for Lang namespace??
##   start with module for now


module Lang

## Group A-Z
## Group 1-99
## Group HEX  # used in concaf world cup quali
## Group 1A or A1, B1  - used anywhere
##   yes - A1, A2, B1, C1, etc. used in UEFA Nations League for example!!
##
##     exlcude
##  use "key" of group - why? why not?
##
##  note - will include group stage too
##           make sure is_round gets called before is_group for now!!!

GROUP_RE = %r{^
                Group [ ]
                   (?<key> [a-z0-9]+ )
              $}ix

def self.is_group?( text )
   ## use regex for match
   GROUP_RE.match?( text )
end




ROUND_RE = %r{^
  (?:
  
  ## add special case for group play-off rounds!
   ##  group 2 play-off   (e.g. worldcup 1954, 1958)
   ##
   ### note - allow Group ("stand-alone") as "generic" round for now
   ##      BUT do NOT allow Group 1, Group 2, Group A, Group B, etc.
     (?: Group [ ] [a-z0-9]+ [ ] Play-?offs?  |
         Group (?: [ ] (?: phase|stage))?  |
         League (?: [ ] phase)?
     )
        |

   # round  - note - requiers number e.g. round 1,2, etc.
   #   note - use 1-9 regex (cannot start with 0) - why? why not?
   #             make week 01 or round 01 or matchday 01 possible?
      (?: (?: Round |
              Matchday |
              Week
           )
           [ ] [1-9][0-9]*
          (?:    ## note - add optional   Matchday 1 of 2 or such
               [ ] of [ ] [1-9][0-9]*
          )?
      )
       |
      (?:  Round [ ]  One
       )
       |
   ##  starting with qual(ification)
   ##   Qual. Round 1 / Qual. Round 2 / Qual. Round 3
   ##  or
   ##  Playoff Round 1
   ##  Play-in Round 1
     (?:  (?: Qual \. |
              Play[ -]?off |
              Play[ -]?in
          )
           [ ] Round [ ] [1-9][0-9]* )
       |
   ## 1. Round / 2. Round / 3. Round / etc.
   ##  First Round
   ##  Play-off Round
   ##  Final Round   (e.g. Worldcup 1950)
      (?:   (?:
                Play[ -]?off  |
                Final |
                Wildcard |
                Qualifying |
                (?:
                   (?:
                     [1-9][0-9]* \.  |
                     1st | First   |
                     2nd | Second  |
                     3rd | Third   |
                     4th | Fourth  | 
                     5th | Fifth
                   ) 
                   (?:   ## with optionals
                     [ ] Qualifying
                   )?
                )
            )
            [ ] Round
       )
       |
  ## starting with preliminary
  #   e.g.  Preliminary round
     (?:  Preliminary  [ ]
           (?:  Round |
                Semi[ -]?finals |
                Final |
                Qualifier
           )
     )
     |
   # more (kockout) rounds
   # playoffs  - playoff, play-off, play-offs  &
   # playins
        (?: 
           Play[ -]?offs? (?: [ ]for[ ]quarter-?finals )?
             |
           Play[ -]?ins?
        )
        |
   # round32
        (?: Round[ ]of[ ]32 |
            Last[ ]32 |
            16th[ ]finals |
            1/16[ ]finals  )
          |
   # round16
        (?: Round[ ]of[ ]16 |
            Last[ ]16 |
            8th[ ]finals |
            1/8[ ]finals  )
           |
   # round8 aka quarterfinals
   #   note - allow quarter-finals/quarter finals/quarterfinals 
         (?:  Round[ ]of[ ]8 |
              Last[ ]8  |   
              1/4[ ]finals  | 
              Quarter[ -]?finals? |
              Quarters  )
          |
   # fifthplace
         (?:
             (?: (Fifth|5th)[ -]place
                  (?: [ ] (?: match|final|play[ -]?off ))?
              ) |
             (?: Match[ ]for[ ](?: fifth|5th )[ -]place )
         )
          |
   # thirdplace
          (?:
              (?: (Third|3rd)[ -]place
                     (?: [ ] (?: match|final|play[ -]?off ))?
               ) |
              (?: Match[ ]for[ ](?: third|3rd )[ -]place )
           )
           |
   # round4 aka semifinals
        (?:
             Round[ ]of[ ]4 |
             Last[ ]4 | 
             Semi[ -]?finals? |
             Semis )
        |
   # round2 aka final
         Finals?
        |
    ## add replays
    ##  e.g. Final Replay
    ##       Quarter-finals replays
    ##       First round replays
     (?:
        (?: (?: 1st | First |
                2nd | Second | 
                3rd | Third | 
                4th | Fourth |
                5th | Fifth ) [ ] Round |
            Quarter[ -]?finals? |
            Finals?
         )
        [ ] Replays?
      )
     |
  ## more
     (?:
        Decider  |   # decider e.g. Entscheidungsspiel
        Reclassification 
     )
)$}ix


####
#  add more round names in different languages
#    via txt files
#
#  for now must match case - maybe make caseinsensitive later - why? why not?
def self.read_names( path )
     txt = read_text( path )
     names = [] # array of lines (with words)
     txt.each_line do |line|
       line = line.strip

       next if line.empty?
       next if line.start_with?( '#' )   ## skip comments too

       ## strip inline (until end-of-line) comments too
       ##   e.g. Janvier  Janv  Jan  ## check janv in use??
       ##   =>   Janvier  Janv  Jan

       line = line.sub( /#.*/, '' ).strip
       ## pp line

       names << line
     end
     names
end


def self.more_round_names
   @more_round_name ||= begin
                           names = []
                           langs = ['en', 'de', 'es', 'pt', 'misc']
                           ## sort names by length??
                           langs.each do |lang|
                             path = "#{SportDb::Module::Parser.root}/config/rounds_#{lang}.txt"
                             names += read_names( path )
                           end
                           names
                        end
end

def self.zone_names
   @zone_name ||= begin
                           names = []
                           langs = ['en']
                           ## sort names by length??
                           langs.each do |lang|
                             path = "#{SportDb::Module::Parser.root}/config/zones_#{lang}.txt"
                             names += read_names( path )
                           end
                           names
                        end
end


def self.is_round?( text )
    ### note - use check for case-insensitive 
    ##   was:
    ##       more_round_names.include?( text )
    ##   change to:
    ##       more_round_names.any?{ |str| str.casecmp( text )==0 }
    ##
    ##  todo/fix:
    ##    maybe in the future use our own unaccent and downcase - wyh? why not?
    ##      note - for now ROUND_RE is also case-insensitive!!

    ROUND_RE.match?( text ) || 
    more_round_names.any?{ |str| str.casecmp( text )==0 }
end

def self.is_zone?( text )
     zone_names.any?{ |str| str.casecmp( text )==0 }
end


##
## keep leg separate (from round) - why? why not?
##
LEG_RE = %r{^
  # leg1
     (?: 1st|First) [ ] leg
     |
  # leg2
     (?: 2nd|Second) [ ] leg
     |
 #  leg 1 of 2 / leg 2 of 2   
 #  note - leg limited to ALWAY 1/2 of 2 for now - why? why not?
 #             for more use match 1/2/3 etc. 
 ##   allow leg of three (e.g. leg 1 of 3) - why? why not?
     (?:  leg [ ] [12]     
          (?: [ ] of [ ] 2)?  )
     |
     (?:  match [ ] [1-9][0-9]* )
$}ix



### Pair matches/games if marked with leg1 n leg2
def self.is_leg?( text )
   LEG_RE.match?( text )
end


end  # module Lang
end  # module SportDb
