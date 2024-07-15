

module Rsssf
class Parser



BASICS_RE = %r{
    (?<spaces> [ ]{2,}) |
    (?<space>  [ ]) 
        |
    (?<sym>[;,@|\[\]]) 
}ix




=begin
MINUTE_RE = %r{
     (?<minute>
       (?<=[ ])	 # Positive lookbehind for space required
           (?<value>\d{1,3})      ## constrain numbers to 0 to 999!!!
        (?: \+
            (?<value2>\d{1,3})
        )? 	
        '     ## must have minute marker!!!!
     )
}ix
=end

##  (match) status 
##    note: english usage - cancelled (in UK), canceled (in US)
##
##  add more variants - why? why not?

STATUS_RE = %r{
     (?<status>
         \b
         (?:
            cancelled|canceled|can\.
               |
            abandoned|abd\.
               |
            postponed
               |
            awarded|awd\. 
               |
            replay     
         )
   (?=[ \]]|$)
     )}ix

## todo/check:  remove loakahead assertion here - why require space?
## note: \b works only after non-alphanum  
##          to make it work with awd. (dot) "custom" lookahead neeeded 



##   goal types
GOAL_PEN_RE = %r{
   (?<pen> 
        (?<=\d)	## must follow a number
            pen
            \b 
    )
}ix

GOAL_OG_RE = %r{
   (?<og> 
        (?<=\d)	## must follow a number
          og
          \b
   )
}ix


###
##  move to token-note(s) file !!!!
##

NOTE_RE = %r{
    \[
   (?<note>
        ##  starting with ___ 
      (?:
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
          (?: originally[ ])? scheduled
          ## e.g. [originally scheduled to play in Mexico City] 
          |
          rescheduled
          ## e.g.  [Rescheduled due to earthquake occurred in Mexico on September 19]
          |
          suspended
          ## e.g. [suspended at 0-0 in 12' due to storm]  
          ##      [suspended at 84' by storm; result stood]
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
    )      
     \] 
}ix





RE = Regexp.union(   STATUS_RE,
                     GROUP_RE, ROUND_RE, LEG_RE,
                    DATE_RE,
                    SCORE_RE,
                    SCORE_EXT_RE,
                    NOTE_RE,
                    BASICS_RE,
                     TEXT_RE )


## "strict" text match mode inside brackets  
##  ]                     
INSIDE_RE  = Regexp.union(  GOAL_OG_RE, GOAL_PEN_RE,
                            BASICS_RE,
                            TEXT_STRICT_RE,
                            MINUTE_RE, 
                         )

def log( msg )
   ## append msg to ./logs.txt  
   ##     use ./errors.txt - why? why not?
   File.open( './logs.txt', 'a:utf-8' ) do |f|
     f.write( msg )
     f.write( "\n" ) 
   end
end



def tokenize_with_errors( line, debug: false )
  tokens = []
  errors = []   ## keep a list of errors - why? why not?

  puts ">#{line}<"    if debug

  pos = 0
  ## track last offsets - to report error on no match 
  ##   or no match in end of string
  offsets = [0,0]
  m = nil

  ####
  ## quick hack - keep re state/mode between tokenize calls!!!
  @re  ||= RE     ## note - switch between RE & INSIDE_RE


  while m = @re.match( line, pos )
    if debug
      pp m
      puts "pos: #{pos}"  
    end
    offsets = [m.begin(0), m.end(0)]

    if offsets[0] != pos
      ## match NOT starting at start/begin position!!!
      ##  report parse error!!!
      msg =  "!! WARN - parse error - skipping >#{line[pos..(offsets[0]-1)]}< @#{offsets[0]},#{offsets[1]} in line >#{line}<"
      puts msg

      errors << "parse error - skipping >#{line[pos..(offsets[0]-1)]}< @#{offsets[0]},#{offsets[1]}"
      log( msg )
    end

    ##
    ## todo/fix - also check if possible
    ##   if no match but not yet end off string!!!!
    ##    report skipped text run too!!!

    pos = offsets[1]

    pp offsets   if debug

    t =  if @re == INSIDE_RE
          if m[:space]
           nil   ## skip space
          elsif m[:spaces]
           nil  ## skip spaces
          elsif m[:text] 
            [:text, m[:text]]   ## keep pos - why? why not?
          elsif m[:minute]
            [:minute, m[:minute]]
          elsif m[:og]
            [:og, m[:og]]    ## for typed drop - string version/variants
          elsif m[:pen]
            [:pen, m[:pen]]
          elsif m[:sym]
            sym = m[:sym]
            ## return symbols "inline" as is - why? why not?
            case sym
            when ',' then [:',']
            when ';' then [:';']
            when '@' then [:'@']
            when '|' then [:'|']   
            when '['
               ## report error - already in inside mode!!!
               nil
            when ']'
               puts "  leave inside match mode"
               @re = RE
               nil
            else
              nil  ## ignore others (e.g. brackets [])
            end
          else
            ## report error  - why? why not?
            nil
          end    
        else  ## assume standard mode/ctx
          if m[:space]
           nil   ## skip space
          elsif m[:spaces]
           nil  ## skip spaces
          elsif m[:text] 
            [:text, m[:text]]   ## keep pos - why? why not?
          elsif m[:note]
            [:note, m[:note]]
          elsif m[:status]   ## (match) status e.g. cancelled, awarded, etc.
            [:status, m[:status]]   
          elsif m[:group]
            [:group, m[:group]]
          elsif m[:round]
            [:round, m[:round]]
          elsif m[:leg]
            [:leg, m[:leg]]
          elsif m[:date]
            [:date, m[:date]]
          elsif m[:score]
            [:score, m[:score]]
          elsif m[:score_ext]
            [:score_ext, m[:score_ext]]
          elsif m[:sym]
          sym = m[:sym]
          ## return symbols "inline" as is - why? why not?
          case sym
          when ',' then [:',']
          when ';' then [:';']
          when '@' then [:'@']
          when '|' then [:'|']   
          when '['
             ##  switch to inside mode!!!
             puts "  enter inside match mode"
             @re = INSIDE_RE
             nil
          when ']'
             ## already in standard mode/ctx
             ##  report warn/error - why? why not?
             nil
          else
            nil  ## ignore others (e.g. brackets [])
          end
        else
          ## report error  - why? why not?
          nil
        end
      end


    tokens << t    if t    

    if debug
      print ">"
      print "*" * pos
      puts "#{line[pos..-1]}<"
    end
  end

  ## check if no match in end of string
  if offsets[1] != line.size
    msg =  "!! WARN - parse error - skipping >#{line[offsets[1]..-1]}< @#{offsets[1]},#{line.size} in line >#{line}<"
    puts msg
    log( msg )

    errors << "parse error - skipping >#{line[offsets[1]..-1]}< @#{offsets[1]},#{line.size}"
  end


  [tokens,errors] 
end


### convience helper - ignore errors by default
def tokenize(  line, debug: false )
   tokens, _ = tokenize_with_errors( line, debug: debug )
   tokens
end


end  # class Parser
end # module Rsssf
  