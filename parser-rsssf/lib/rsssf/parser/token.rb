

module Rsssf
class Parser



BASICS_RE = %r{
    (?<spaces> [ ]{2,}) |
    (?<space>  [ ]) 
        |
    (?<sym>[;,@|\[\]\(\)])     ## note - add () too  - why? why not?
}ix



VS_RE = %r{   ## must be space before and after!!!
                    (?<vs>
                      (?<=[ ])	# Positive lookbehind for space
                         -
                       (?=[ ])   # positive lookahead for space 
                    )
                }ix
                




RE = Regexp.union(  GROUP_RE, ROUND_RE, LEG_RE,
                    DATE_RE,
                    VS_RE,
                    SCORE_RE,
                    SCORE_AWD_RE, SCORE_ABD_RE, SCORE_PPD_RE, SCORE_NP_RE,
                       SCORE_WO_RE,
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


## open/close pairs - lookup close (by open char)
SYM_CLOSE = {
  '(' => ')',
  '[' => ']',
}

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

      ctx = @re == INSIDE_RE ? 'INSIDE_RE' : 'RE'  ## assume RE
      ## fix/change - use str.inspect to show tabs (\t)
      ##          and possibly other special characters causing trouble     
      msg =  "  !! WARN - parse error (#{ctx}) - skipping >#{line[pos..(offsets[0]-1)]}< @#{offsets[0]},#{offsets[1]} in line >#{line}<"
      puts msg

      errors << "parse error (#{ctx}) - skipping >#{line[pos..(offsets[0]-1)]}< @#{offsets[0]},#{offsets[1]}"
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
             when '[', '('
               if sym == @sym_open   
                 ## report error - already in inside mode!!!
                 ##  e.g. another [ in [] or ( in ()
                 log( "warn - unexpected (opening) #{sym} in inside (goal) mode" )
               end
               nil
             when ']', ')'   ## allow [] AND () for inside mode
               ## puts "  leave inside match mode"
               if sym == @sym_close 
                   @re = RE
                   @sym_open  = nil  ## reset sym_open/close
                   @sym_close = nil
               end
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
           elsif m[:group]
             [:group, m[:group]]
           elsif m[:round]
             [:round, m[:round]]
           elsif m[:leg]
             [:leg, m[:leg]]
           elsif m[:date]
             [:date, m[:date]]
           elsif m[:vs]
             [:vs, m[:vs]]
           elsif m[:score]
             [:score, m[:score]]
           elsif m[:score_awd]   # awarded (awd)
             [:score_awd, m[:score_awd]]
           elsif m[:score_abd]   # abandoned (abd)
             [:score_abd, m[:score_abd]]
           elsif m[:score_ppd]   # postponed (ppd)
             [:score_ppd, m[:score_ppd]]
           elsif m[:score_np]    # not played (n/p)
             [:score_np, m[:score_np]]
           elsif m[:score_wo]    # walk over (w/o)
             [:score_wo, m[:score_wo]]
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
             when '[', '('
               ##  switch to inside mode!!!
               ## puts "  enter inside match mode"
               @re = INSIDE_RE
               @sym_open  =  sym      ## record open/close style - why? why not?
               @sym_close =  SYM_CLOSE[sym]
               nil
             when ']', ')'
               log( "warn - unexpected (closing) #{sym} in standard mode" )   
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

    ## note - report regex context
    ##  e.g.  RE or INSIDE_RE  to help debugging/troubleshooting format errors
    ctx = @re == INSIDE_RE ? 'INSIDE_RE' : 'RE'  ## assume RE
    ## fix/change - use str.inspect to show tabs (\t)
    ##          and possibly other special characters causing trouble     

    msg =  "  !! WARN - parse error (#{ctx}) - skipping >#{line[offsets[1]..-1]}< @#{offsets[1]},#{line.size} in line >#{line}<"
    puts msg
    log( msg )

    errors << "parse error (#{ctx}) - skipping >#{line[offsets[1]..-1]}< @#{offsets[1]},#{line.size}"
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
  