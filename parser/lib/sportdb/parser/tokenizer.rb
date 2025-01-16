
module SportDb
class Parser



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

    ##
    ## note: racc requires pairs e.g. [:TOKEN, VAL]
    ##         for VAL use "text" or ["text", { opts }]  array


  t = if @re == PROP_RE
         if m[:space]
              ## skip space
              nil
         elsif m[:spaces]
              ## skip spaces
              nil
         elsif m[:prop_name]
               if m[:name] == 'Y'
                 [:YELLOW_CARD, m[:name]]
               elsif m[:name] == 'R'
                 [:RED_CARD, m[:name]]
               else 
                 [:PROP_NAME, m[:name]]
               end
         elsif m[:minute]
              minute = {}
              minute[:m]      = m[:value].to_i(10)
              minute[:offset] = m[:value2].to_i(10)   if m[:value2]
             ## note - for debugging keep (pass along) "literal" minute
             [:MINUTE, [m[:minute], minute]]
         elsif m[:sym]
            sym = m[:sym]
            ## return symbols "inline" as is - why? why not?
            ## (?<sym>[;,@|\[\]-])
 
            case sym
            when ',' then [:',']
            when ';' then [:';']
            when '[' then [:'[']
            when ']' then [:']']
            when '(' then [:'(']
            when ')' then [:')']
            when '-' then [:'-']
            when '.' then 
                ## switch back to top-level mode!!
                puts "  LEAVE PROP_RE MODE, BACK TO TOP_LEVEL/RE"
                @re = RE 
                [:'.']
            else
              nil  ## ignore others (e.g. brackets [])
            end
         else
            ## report error
             puts "!!! TOKENIZE ERROR (PROP_RE) - no match found"
             nil 
         end
      else  ## assume TOP_LEVEL (a.k.a. RE) machinery
        if m[:space]
           ## skip space
           nil
        elsif m[:spaces]
           ## skip spaces
           nil
        elsif m[:prop_key]
           ##  switch context  to PROP_RE
           @re = PROP_RE
           puts "  ENTER PROP_RE MODE"
           [:PROP, m[:key]]
        elsif m[:text]
          [:TEXT, m[:text]]   ## keep pos - why? why not?
        elsif m[:status]   ## (match) status e.g. cancelled, awarded, etc.
          ## todo/check - add text (or status) 
          #     to opts hash {} by default (for value)
          if m[:status_note]   ## includes note? e.g.  awarded; originally 2-0
             [:STATUS, [m[:status], {status: m[:status], 
                                     note:   m[:status_note]} ]]
          else
             [:STATUS, [m[:status], {status: m[:status] } ]]
          end
        elsif m[:time]
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
               [:TIME, [m[:time], {h:hour,m:minute}]]
              else
                 raise ArgumentError, "parse error - time >#{m[:time]}< out-of-range"
              end
        elsif m[:date]
            date = {}
 ## map month names
 ## note - allow any/upcase JULY/JUL etc. thus ALWAYS downcase for lookup
            date[:y] = m[:year].to_i(10)  if m[:year]
            date[:m] = MONTH_MAP[ m[:month_name].downcase ]   if m[:month_name]
            date[:d]  = m[:day].to_i(10)   if m[:day]
            date[:wday] = DAY_MAP[ m[:day_name].downcase ]   if m[:day_name]
            ## note - for debugging keep (pass along) "literal" date
            [:DATE, [m[:date], date]]
        elsif m[:timezone]
          [:TIMEZONE, m[:timezone]]
        elsif m[:duration]
            ## todo/check/fix - if end: works for kwargs!!!!!
            duration = { start: {}, end: {}}
            duration[:start][:y] = m[:year1].to_i(10)  if m[:year1]
            duration[:start][:m] = MONTH_MAP[ m[:month_name1].downcase ]   if m[:month_name1]
            duration[:start][:d]  = m[:day1].to_i(10)   if m[:day1]
            duration[:start][:wday] = DAY_MAP[ m[:day_name1].downcase ]   if m[:day_name1]
            duration[:end][:y] = m[:year2].to_i(10)  if m[:year2]
            duration[:end][:m] = MONTH_MAP[ m[:month_name2].downcase ]   if m[:month_name2]
            duration[:end][:d]  = m[:day2].to_i(10)   if m[:day2]
            duration[:end][:wday] = DAY_MAP[ m[:day_name2].downcase ]   if m[:day_name2]
            ## note - for debugging keep (pass along) "literal" duration
            [:DURATION, [m[:duration], duration]]
        elsif m[:num]   ## fix - change to ord (for ordinal number!!!)
              ## note -  strip enclosing () and convert to integer
             [:ORD, [m[:num], { value: m[:value].to_i(10) } ]]
        elsif m[:score]
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
            [:SCORE, [m[:score], score]]
        elsif m[:minute]
              minute = {}
              minute[:m]      = m[:value].to_i(10)
              minute[:offset] = m[:value2].to_i(10)   if m[:value2]
             ## note - for debugging keep (pass along) "literal" minute
             [:MINUTE, [m[:minute], minute]]
        elsif m[:og]
           [:OG, m[:og]]    ## for typed drop - string version/variants ??  why? why not?
        elsif m[:pen]
           [:PEN, m[:pen]]
        elsif m[:vs]
           [:VS, m[:vs]]
        elsif m[:sym]
          sym = m[:sym]
          ## return symbols "inline" as is - why? why not?
          ## (?<sym>[;,@|\[\]-])
 
          case sym
          when ',' then [:',']
          when ';' then [:';']
          when '@' then [:'@']
          when '|' then [:'|']
          when '[' then [:'[']
          when ']' then [:']']
          when '-' then [:'-']
          else
            nil  ## ignore others (e.g. brackets [])
          end
        else
          ## report error
           puts "!!! TOKENIZE ERROR - no match found"
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
end # module SportDb
