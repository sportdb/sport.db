module SportDb
class TxtMatchWriter


  ## translate from lang x (german, etc) to english
 ROUND_TRANSLATIONS = {
   # de/german
   '1. Runde'      => 'Round 1',
   '2. Runde'      => 'Round 2',
   'Achtelfinale'  => 'Round of 16',
   'Viertelfinale' => 'Quarterfinals',
   'Halbfinale'    => 'Semifinals',
   'Finale'        => 'Final',
 }


## note: build returns buf - an (in-memory) string buf(fer)
def self.build( matches, rounds: true )
  ## note: make sure rounds is a bool, that is, true or false  (do NOT pass in strings etc.)
  raise ArgumentError, "rounds flag - bool expected; got: #{rounds.inspect}"    unless rounds.is_a?( TrueClass ) || rounds.is_a?( FalseClass )


  ### check for stages & stats
  stats = {  'stage' => Hash.new(0),
             'date' =>  { 'start_date' => nil,
                          'end_date'   => nil, },
             'teams' => Hash.new(0),
              }

## add matches played stats too??

  matches.each do |match|
     stage = match.stage
     stage = 'Regular Season'   if stage.nil? || stage.empty?
     stats['stage'][ stage ] += 1

     if match.date

      ## todo/fix - norm date (parse as Date)
      ##   check format etc.
      date = if match.date.is_a?( String )
                Date.strptime( match.date, '%Y-%m-%d' )
              else  ## assume it's already a date (object)
                match.date
              end
       stats['date']['start_date'] ||= date
       stats['date']['end_date']   ||= date

       stats['date']['start_date'] = date  if date < stats['date']['start_date']
       stats['date']['end_date']   = date  if date > stats['date']['end_date']
      end

     [match.team1, match.team2].each do |team|
        stats['teams'][ team ] += 1    if team && !['N.N.'].include?( team )
     end
  end

  use_stages =  if stats['stage'].size >= 2  ||
                   (stats['stage'].size == 1  &&
                    stats['stage'].keys[0] != 'Regular Season')
                  true
                else
                  false
                end


   ### add comment header
    buf = String.new
    # e.g. 13 April – 25 September 2024
    #  or  16 August 2024 – 25 May 2025
    ## note - date is optional!!
    if stats['date']['start_date']
      buf << "# Date       "
      start_date = stats['date']['start_date']
      end_date   = stats['date']['end_date']
      if start_date.year != end_date.year
        buf << "#{start_date.strftime('%a %b/%-d %Y')} - #{end_date.strftime('%a %b/%-d %Y')}"
      else
        buf << "#{start_date.strftime('%a %b/%-d')} - #{end_date.strftime('%a %b/%-d %Y')}"
      end
      buf << " (#{end_date.jd-start_date.jd}d)"   ## add days
      buf << "\n"
    end

    buf << "# Teams      #{stats['teams'].size}\n"
    buf << "# Matches    #{matches.size}\n"

    if use_stages
      buf << "# Stages     "
      stages = stats['stage'].map { |name,count| "#{name} (#{count})" }.join( '  ' )
      buf << stages
      buf << "\n"
    end
    buf << "\n\n"


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

  ## note: for now always english
  round              = 'Matchday'
  format_date        = ->(date) { date.strftime( '%a %b/%-d' )  }
  format_score       = ->(match) { match.score.to_s( lang: 'en' ) }
  round_translations = ROUND_TRANSLATIONS

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
             buf << "#{round} #{match.round}"
         else ## use as is from match
           ## note: for now assume english names
            if match.round.nil?
              ## warn
              puts "!! ERROR - match with round nil?"
              pp match
              exit 1
            end

           buf << (round_translations[match.round] || match.round)
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
            buf << "[#{format_date.call( date )}]\n"
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

     line << "  #{format_score.call( match )}  "  ## note: separate by at least two spaces for now

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


def self.write( path, matches, name:, rounds: true)

  buf = build( matches, rounds: rounds )

  ## for convenience - make sure parent folders/directories exist
  FileUtils.mkdir_p( File.dirname( path) )  unless Dir.exist?( File.dirname( path ))

  puts "==> writing to >#{path}<..."
  File.open( path, 'w:utf-8' ) do |f|
    f.write( "= #{name}\n" )
    f.write( buf )
  end
end # method self.write


def self.build_goals( goals )
  ## todo/fix: for now assumes always minutes (without offset) - add offset support

  ## note: "fold" multiple goals by players
  team1_goals = {}
  team2_goals = {}
  goals.each do |goal|
    team_goals = goal.team == 1 ? team1_goals : team2_goals
    player_goals = team_goals[ goal.player ] ||= []
    player_goals << goal
  end

  buf = String.new
  if team1_goals.size > 0
    buf << build_goals_for_team( team1_goals )
  end

  ## note: only add a separator (;) if BOTH teams have goal scores
  if team1_goals.size > 0 && team2_goals.size > 0
    buf << '; '
  end

  if team2_goals.size > 0
    buf << build_goals_for_team( team2_goals )
  end
  buf
end


def self.build_goals_for_team( team_goals )
  buf = String.new
  team_goals.each_with_index do |(player_name, goals),i|
    buf << ' ' if i > 0
    buf << "#{player_name} "
    buf << goals.map do |goal|
                        str = "#{goal.minute}'"
                        str << " (o.g.)"      if goal.owngoal?
                        str << " (pen.)"      if goal.penalty?
                        str
                     end.join( ', ' )
  end
  buf
end


end # class TxtMatchWriter
end # module SportDb
