

module SportDb 
class Parser


##
#  keep 18h30 - why? why not?
#    add support for 6:30pm 8:20am etc. - why? why not?

TIME_RE = %r{
    ## e.g. 18.30 (or 18:30 or 18h30)
    (?<time>  \b
              (?<hour>\d{1,2})
                 (?: :|\.|h )
              (?<minute>\d{2})
              \b
    )     
}ix



##
# for timezone format use for now:
# (BRT/UTC-3)      (e.g. brazil time)
#
# (CET/UTC+1)   - central european time
# (CEST/UTC+2)  - central european summer time  - daylight saving time (DST).
# (EET/UTC+1)  - eastern european time
# (EEST/UTC+2)  - eastern european summer time  - daylight saving time (DST).
# 
# UTC+3
# UTC+4
# UTC+0
# UTC+00
# UTC+0000
#
#  - allow +01 or +0100  - why? why not
#  -       +0130 (01:30)
#
# see
#   https://en.wikipedia.org/wiki/Time_zone
#   https://en.wikipedia.org/wiki/List_of_UTC_offsets
#   https://en.wikipedia.org/wiki/UTC−04:00  etc.

TIMEZONE_RE = %r{
   ## e.g. (UTC-2) or (CEST/UTC-2) etc.
   (?<timezone>  
      \(
           ## optional "local" timezone name eg. BRT or CEST etc.
           (?:  [a-z]+
                 /
           )?
            [a-z]+
            [+-]
            \d{1,4}   ## e.g. 0 or 00 or 0000
      \)
   )
}ix




BASICS_RE = %r{
    ## e.g. (51) or (1) etc.  - limit digits of number???
    (?<num> \(  (?<value>\d+) \) )    
       |
    (?<vs>   
       (?<=[ ])	# Positive lookbehind for space	
       (?: 
          vs\.?|   ## allow optional dot (eg. vs. v.)
          v\.?|
          -
       )   # not bigger match first e.g. vs than v etc.
       (?=[ ])   # positive lookahead for space
    ) 
       | 
    (?<none>
       (?<=[ \[]|^)	 # Positive lookbehind for space or [	
           -
        (?=[ ]*;)   # positive lookahead for space
    )
       |
    (?<spaces> [ ]{2,}) |
    (?<space>  [ ]) 
        |
    (?<sym>[;,@|\[\]]) 
}ix


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
# (pen.) or (pen) or (p.) or (p)  
## (o.g.) or (og)
GOAL_PEN_RE = %r{
   (?<pen> \(  
           (?:pen|p)\.? 
           \)
    )
}ix
GOAL_OG_RE = %r{
   (?<og> \(  
          (?:og|o\.g\.) 
          \)
   )
}ix




RE = Regexp.union(   STATUS_RE,
                     TIMEZONE_RE,
                     TIME_RE,
                     DURATION_RE,  # note - duration MUST match before date
                    DATE_RE,
                    SCORE_RE,
                    BASICS_RE, MINUTE_RE,
                    GOAL_OG_RE, GOAL_PEN_RE,
                     TEXT_RE )


def log( msg )
   ## append msg to ./logs.txt  
   ##     use ./errors.txt - why? why not?
   File.open( './logs.txt', 'a:utf-8' ) do |f|
     f.write( msg )
     f.write( "\n" ) 
   end
end



def tokenize_with_errors( line, typed: false,
                                debug: false )
  tokens = []
  errors = []   ## keep a list of errors - why? why not?

  puts ">#{line}<"    if debug

  pos = 0
  ## track last offsets - to report error on no match 
  ##   or no match in end of string
  offsets = [0,0]
  m = nil

  while m = RE.match( line, pos )
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

    t = if m[:space]
           ## skip space
           nil
        elsif m[:spaces]
           ## skip spaces
           nil
        elsif m[:text] 
          [:text, m[:text]]   ## keep pos - why? why not?
        elsif m[:status]   ## (match) status e.g. cancelled, awarded, etc.
          [:status, m[:status]]   
        elsif m[:time]
          if typed
              ## unify to iso-format
              ###   12.40 => 12:40
              ##    12h40 => 12:40 etc.
              ##  keep string (no time-only type in ruby)
              hour =   m[:hour].to_i(10)  ## allow 08/07/etc.
              minute = m[:minute].to_i(10)
              ## check if valid -  0:00 - 24:00
              ##   check if 24:00 possible? or only 0:00 (23:59)
              if (hour >= 0 && hour <= 24) &&
                 (minute >=0 && minute <= 59)
               ## note - for debugging keep (pass along) "literal" time
               ##   might use/add support for am/pm later                
               [:time, m[:time], {h:hour,m:minute}]
              else
                 raise ArgumentError, "parse error - time >#{m[:time]}< out-of-range"
              end
          else
            [:time, m[:time]]
          end
        elsif m[:date]
          if typed
            date = {}
=begin            
            ((?<day_name>#{DAY_NAMES})
            [ ]
       )?    
       (?<month_name>#{MONTH_NAMES})
           (?: \/|[ ] )
       (?<day>\d{1,2})
       ## optional year
       (  [ ]
          (?<year>\d{4})
       )?   
=end
 ## map month names
 ## note - allow any/upcase JULY/JUL etc. thus ALWAYS downcase for lookup
            date[:y] = m[:year].to_i(10)  if m[:year]       
            date[:m] = MONTH_MAP[ m[:month_name].downcase ]   if m[:month_name]
            date[:d]  = m[:day].to_i(10)   if m[:day]
            date[:wday] = DAY_MAP[ m[:day_name].downcase ]   if m[:day_name]
            ## note - for debugging keep (pass along) "literal" date                
            [:date, m[:date], date]        
          else
            [:date, m[:date]]
          end
        elsif m[:timezone]
          [:timezone, m[:timezone]]
        elsif m[:duration]
          [:duration, m[:duration]]
        elsif m[:num]
          if typed
              ## note -  strip enclosing () and convert to integer
             [:num, m[:value].to_i(10)]
          else 
             [:num, m[:num]]
          end
        elsif m[:score]
          if typed
              score = {}
              ## check for pen
              score[:p] = [m[:p1].to_i(10), 
                           m[:p2].to_i(10)]  if m[:p1] && m[:p2]
              score[:et] = [m[:et1].to_i(10), 
                            m[:et2].to_i(10)]  if m[:et1] && m[:et2]
              score[:ft] = [m[:ft1].to_i(10), 
                            m[:ft2].to_i(10)]  if m[:ft1] && m[:ft2]
              score[:ht] = [m[:ht1].to_i(10), 
                            m[:ht2].to_i(10)]  if m[:ht1] && m[:ht2]

            ## note - for debugging keep (pass along) "literal" score                
            [:score, m[:score], score]
          else
            [:score, m[:score]]
          end
        elsif m[:minute]
          if typed
              minute = {}
              minute[:m]      = m[:value].to_i(10)
              minute[:offset] = m[:value2].to_i(10)   if m[:value2]
             ## note - for debugging keep (pass along) "literal" minute                
             [:minute, m[:minute], minute]
          else
             [:minute, m[:minute]]
          end
        elsif m[:og]
          typed  ?  [:og] : [:og, m[:og]]    ## for typed drop - string version/variants
        elsif m[:pen]
          typed  ?  [:pen] : [:pen, m[:pen]]
        elsif m[:vs]
          typed  ?  [:vs] : [:vs, m[:vs]]
        elsif m[:none]
          typed  ?  [:none] : [:none, m[:none]]
        elsif m[:sym]
          sym = m[:sym]
          ## return symbols "inline" as is - why? why not?
          case sym
          when ',' then [:',']
          when ';' then [:';']
          when '@' then [:'@']
          when '|' then [:'|']   
          else
            nil  ## ignore others (e.g. brackets [])
          end
        else
          ## report error 
          nil
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
def tokenize(  line, typed: false,
                     debug: false )
   tokens, _ = tokenize_with_errors( line, typed: typed,
                                           debug: debug )
   tokens
end


end  # class Parser
end # module SportDb 
  