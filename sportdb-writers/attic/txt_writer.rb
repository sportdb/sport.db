module SportDb
class TxtMatchWriter



## note: build returns buf - an (in-memory) string buf(fer)
def self.build( matches, rounds: true )
  ## note: make sure rounds is a bool, that is, true or false  (do NOT pass in strings etc.)
  raise ArgumentError, "rounds flag - bool expected; got: #{rounds.inspect}"    unless rounds.is_a?( TrueClass ) || rounds.is_a?( FalseClass )


  ### calc stats and check for stages
  stats = _calc_stats( matches )

  buf = String.new

  ### add comment header
  buf << _build_stats( stats )
  buf << "\n\n"


  use_stages = stats['use_stages' ]
  if use_stages
    ## split matches by stage
    matches_by_stage = {}
    matches.each do |match|
      stage = match.stage || ''
      matches_by_stage[stage] ||= []
      matches_by_stage[stage] << match
    end

    ## todo/fix
    ## note - empty stage must go first!!!!
    matches_by_stage.each_with_index do |(name, matches),i|
      buf << "\n"  if i != 0   # add extra new line (if not first stage)
      if name.empty?
        buf << "# Regular Season\n"   ## empty stage
      else
        buf << "== #{name}\n"
      end
      buf +=  _build_batch( matches, rounds: rounds )
      buf << "\n"    if i+1 != matches_by_stage.size
    end
    buf
  else
    buf += _build_batch( matches, rounds: rounds )
    buf
  end
end


def self._build_batch( matches, rounds: true )
  ## note: make sure rounds is a bool, that is, true or false  (do NOT pass in strings etc.)
  raise ArgumentError, "rounds flag - bool expected; got: #{rounds.inspect}"    unless rounds.is_a?( TrueClass ) || rounds.is_a?( FalseClass )

  buf = String.new

  last_round = nil
  last_date  = nil
  last_time  = nil


  matches.each_with_index do |match,i|

     ## note: make rounds optional (set rounds flag to false to turn off)
     if rounds
       if match.round != last_round
         buf << (i == 0 ? "\n" : "\n\n")    ## start with single empty line
         if match.round.is_a?( Integer ) ||
            match.round =~ /^[0-9]+$/   ## all numbers/digits
             ## default "class format
             ##   e.g. Runde 1, Spieltag 1, Matchday 1, Week 1
             buf << "Matchday #{match.round}"
         else ## use as is from match
           ## note: for now assume english names
            if match.round.nil?
              ## warn
              puts "!! ERROR - match with round nil?"
              pp match
              exit 1
            end

           buf << (ROUND_TRANSLATIONS[match.round] || match.round)
         end
         ## note - reset last_date & last_time on every new round header
         last_date = nil
         last_time = nil

         buf << "\n"
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
            buf << "[#{date.strftime( '%a %b/%-d' )}]\n"
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
          line << "%5s" % time_hhmm
        else
          line << '     '
        end
        line << '  '
     else
       line << '       '
     end

     line << "%-23s" % team1    ## note: use %-s for left-align

     ## note: separate by at least two spaces for now
     line << "  #{match.score.to_s( lang: 'en' )}  "

     line << "%-23s" % team2


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


     last_round = match.round
     last_date  = date_yyyymmdd
     last_time  = time_hhmm
  end
  buf
end



end # class TxtMatchWriter
end # module SportDb
