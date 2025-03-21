module SportDb
class TxtMatchWriter



## note: build returns buf - an (in-memory) string buf(fer)
def self.build_v2( matches, rounds: true )
  ## note: make sure rounds is a bool, that is, true or false  (do NOT pass in strings etc.)
  raise ArgumentError, "rounds flag - bool expected; got: #{rounds.inspect}"    unless rounds.is_a?( TrueClass ) || rounds.is_a?( FalseClass )


  ### check for stages & stats
  stats = _calc_stats( matches )


  buf = String.new

  ### add comment header
  buf << _build_stats( stats )
  buf << "\n\n"

  buf << _build_batch_v2( matches, rounds: rounds )

  buf
end


def self._build_batch_v2( matches, rounds: true )
  ## note: make sure rounds is a bool, that is, true or false  (do NOT pass in strings etc.)
  raise ArgumentError, "rounds flag - bool expected; got: #{rounds.inspect}"    unless rounds.is_a?( TrueClass ) || rounds.is_a?( FalseClass )

  last_round = nil
  last_year  = nil  
  last_date  = nil
  last_time  = nil


  buf = String.new


  matches.each_with_index do |match,i|

     ## note: make rounds optional (set rounds flag to false to turn off)
     if rounds
        ## build round string
        round = if match.round.is_a?( Integer ) ||
                   match.round =~ /^[0-9]+$/   ## all numbers/digits
                      ## default "class format
                      ##   e.g. Runde 1, Spieltag 1, Matchday 1, Week 1
                      "Matchday #{match.round}"
                else ## use as is from match
                  ## note: for now assume english names
                  if match.round.nil?
                    ## warn
                    puts "!! ERROR - match with round nil?"
                    pp match
                    exit 1
                  end
                  (ROUND_TRANSLATIONS[match.round] || match.round)
                end
  
        ## if stage present - (auto-)add upfront
        round = "#{match.stage}, #{round}"   if match.stage


        if round != last_round
         buf << (i == 0 ? "\n" : "\n\n")    ## start with single empty line
         buf << "» #{round}\n" 
         
         ## note - reset last_date & last_time on every new round header
         last_date  = nil
         last_time  = nil
         last_round = round
       end
     end


     date = if match.date.is_a?( String )
               Date.strptime( match.date, '%Y-%m-%d' )
            else  ## assume it's already a date (object) or nil!!!!
               match.date
            end

     time = if match.time.is_a?( String )
              Time.strptime( match.time, '%H:%M')
            else ## assume it's already a time (object) or nil
              match.time
            end


     ## note - date might be NIL!!!!!
     date_yyyymmdd = date ? date.strftime( '%Y-%m-%d' ) : nil
  
     ## note: time is OPTIONAL for now
     ## note: use 17.00 and NOT 17:00 for now
     time_hhmm     = time ? time.strftime( '%H.%M' ) : nil


     if date_yyyymmdd
         if date_yyyymmdd != last_date
            ## note: add an extra leading blank line (if no round headings printed)
            buf << "\n"   unless rounds

            buf << "  "
            ## note: only add year if different for last date header
            buf << if (date ? date.year : nil) != last_year
                     "#{date.strftime( '%a %b/%-d %Y' )}" 
                   else 
                     "#{date.strftime( '%a %b/%-d' )}"
                   end
            buf << "\n"
            last_time = nil
         end
     end


     ## allow strings and structs for team names
     team1 = match.team1.is_a?( String ) ? match.team1 : match.team1.name
     team2 = match.team2.is_a?( String ) ? match.team2 : match.team2.name


     line = String.new
     line << '  '

     if time
        if last_time != time_hhmm
          line << "  %5s" % time_hhmm
        else
          line << (' ' *7)
        end
        line << '  '
     else
       line << (' ' *9)
     end

     line << "%-23s" % team1    ## note: use %-s for left-align
     line << " v "
     line << "%-23s" % team2

     ## note - only print if score is available
     ##          returns - for not available for now!!!!
     score = match.score.to_s( lang: 'en' )
     if score != '-'
        ## note: separate by at least two spaces for now
        line << "  #{score}  "  
     end

     if match.status
      line << '  '
      case match.status
      when Status::CANCELLED
        line << '[cancelled]'
      when Status::AWARDED
        line << '[awarded]'
      when Status::ABANDONED
        line << '[abandoned]'
      when Status::REPLAY
        line << '[replay]'
      when Status::POSTPONED
        line << '[postponed]'
        ## was -- note: add NOTHING for postponed for now
      else
        puts "!! WARN - unknown match status >#{match.status}<:"
        pp match
        line << "[#{match.status.downcase}]"  ## print "literal" downcased for now
      end
     end

     ## add match line
     buf << line.rstrip   ## remove possible right trailing spaces before adding
     buf << "\n"

     if match.goals
       buf << '    '               # 4 space indent
       buf << '       '  if time   # 7 (5+2) space indent (for hour e.g. 17.30)
       buf << "[#{build_goals(match.goals)}]"
       buf << "\n"
     end

     last_year  = date ? date.year : nil
     last_date  = date_yyyymmdd
     last_time  = time_hhmm
  end
  buf
end

end # class TxtMatchWriter
end # module SportDb
