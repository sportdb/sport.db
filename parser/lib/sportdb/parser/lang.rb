
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
##  use "key" of group - why? why not?

GROUP_RE = %r{^
                Group [ ]
                   (?<key>[a-z0-9]+)
              $}ix
def self.is_group?( text )
   ## use regex for match
   GROUP_RE.match?( text )
end




ROUND_RE = %r{^(
   ## add special case for group play-off rounds!
   ##  group 2 play-off   (e.g. worldcup 1954, 1958)
   ##
   ### note - allow Group ("stand-alone") as "generic" round for now
   ##      BUT do NOT allow Group 1, Group 2, Group A, Group B, etc.
     (?: Group [ ] [A-Z0-9]+ [ ] Play-?offs?  |
         Group (?: [ ] phase)?  |
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
      )
       |
   ##  starting with qual(ification)
   ##   Qual. Round 1 / Qual. Round 2 / Qual. Round 3
   ##  or
   ##  Playoff Round 1
   ##  Play-in Round 1
     (?:  (?: Qual \. |
              Play-?off |
              Play-?in
          )
           [ ] Round [ ] [1-9][0-9]* )
       |
   ## 1. Round / 2. Round / 3. Round / etc.
   ##  First Round
   ##  Play-off Round
   ##  Final Round   (e.g. Worldcup 1950)
      (?:
           (?: [1-9][0-9]* \.  |
                1st | First   |
                2nd | Second  |
                Play-?off   |
                Final
           )
             [ ] Round
       )
       |
  ## starting with preliminary
  #   e.g.  Preliminary round
     (?:  Preliminary  [ ]
           (?:  Round |
                Semi-?finals |
                Final
           )
     )
     |
   # more (kockout) rounds
   # playoffs  - playoff, play-off, play-offs
        (?: Play-?offs?
           (?: [ ]for[ ]quarter-?finals )?
        )
        |
   # round32
        (?: Round[ ]of[ ]32 |
            Last[ ]32 )
          |
   # round16
        (?: Round[ ]of[ ]16 |
            Last[ ]16 |
            8th[ ]finals )
           |
   # fifthplace
         (?:
             (?: (Fifth|5th)[ -]place
                  (?: [ ] (?: match|play-?off|final ))?
              ) |
             (?: Match[ ]for[ ](?: fifth|5th )[ -]place )
         )
          |
   # thirdplace
          (?:
              (?: (Third|3rd)[ -]place
                     (?: [ ] (?: match|play-?off|final ))?
               ) |
              (?: Match[ ]for[ ](?: third|3rd )[ -]place )
           )
           |
   # quarterfinals
         (?:
              Quarter-?finals? |
              Quarters |
              Last[ ]8
          )
          |
   # semifinals
        (?:
             Semi-?finals? |
             Semis |
             Last[ ]4
        )
        |
   # final
         Finals?
         |
   # decider e.g. Entscheidungsspiel
         Decider
         |
    ## add replays
    ##  e.g. Final Replay
    ##       Quarter-finals replays
    ##       First round replays
     (?:
        (?: First [ ] Round |
            Quarter-?finals? |
            Finals?
         )
        [ ] Replays?
      )
     |
  ## more
     (?:
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

    ROUND_RE.match?( text ) || more_round_names.any?{ |str| str.casecmp( text )==0 }
end

##
## keep leg separate (from round) - why? why not?
##
LEG_RE = %r{^
  # leg1
     (?: 1st|First)[ ]leg
     |
  # leg2
     (?: 2nd|Second)[ ]leg
$}ix

### Pair matches/games if marked with leg1 n leg2
def self.is_leg?( text )
   LEG_RE.match?( text )
end


end  # module Lang
end  # module SportDb
