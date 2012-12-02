
### some utils moved to worldbdb/utils for reuse


module SportDB::FixtureHelpers

  def is_round?( line )
    line =~ /Spieltag|Runde|Achtelfinale|Viertelfinale|Halbfinale|Finale/
  end
  
  def is_group?( line )
    # NB: check after is_round? (round may contain group reference!)
    line =~ /Gruppe|Group/
  end
  
  def is_knockout_round?( line )
    if line =~ /Achtelfinale|Viertelfinale|Halbfinale|Spiel um Platz 3|Finale|K\.O\.|Knockout/
      puts "   setting knockout flag to true"
      true
    else
      false
    end
  end
  
  def find_group_title_and_pos!( line )
    ## group pos - for now support single digit e.g 1,2,3 or letter e.g. A,B,C
    ## nb:  (?:)  = is for non-capturing group(ing)
    regex = /(?:Group|Gruppe)\s+((?:\d{1}|[A-Z]{1}))\b/
    
    match = regex.match( line )
    
    return [nil,nil] if match.nil?

    pos = case match[1]      
          when 'A' then 1
          when 'B' then 2
          when 'C' then 3
          when 'D' then 4
          when 'E' then 5
          when 'F' then 6
          when 'G' then 7
          when 'H' then 8
          when 'I' then 9
          when 'J' then 10
          else  match[1].to_i
          end

    title = match[0]

    puts "   title: >#{title}<"
    puts "   pos: >#{pos}<"
      
    line.sub!( regex, '[GROUP|TITLE+POS]' )

    return [title,pos]
  end
  
  def find_round_pos!( line )
    ## fix/todo:
    ##  if no round found assume last_pos+1 ??? why? why not?

    regex = /\b(\d+)\b/
    
    if line =~ regex
      value = $1.to_i
      puts "   pos: >#{value}<"
      
      line.sub!( regex, '[ROUND|POS]' )

      return value
    else
      return nil
    end    
  end
  
  def find_date!( line )
    # extract date from line
    # and return it
    # NB: side effect - removes date from line string
    
    # e.g. 2012-09-14 20:30   => YYYY-MM-DD HH:MM
    regex_db = /\b(\d{4})-(\d{2})-(\d{2})\s+(\d{2}):(\d{2})\b/

    # e.g. 14.09. 20:30  => DD.MM. HH:MM
    regex_de = /\b(\d{2})\.(\d{2})\.\s+(\d{2}):(\d{2})\b/

    if line =~ regex_db
      value = "#{$1}-#{$2}-#{$3} #{$4}:#{$5}"
      puts "   date: >#{value}<"

      ## todo: lets you configure year
      ##  and time zone (e.g. cet, eet, utc, etc.)
      
      line.sub!( regex_db, '[DATE.DB]' )

      return DateTime.strptime( value, '%Y-%m-%d %H:%M' )
    elsif line =~ regex_de
      value = "2012-#{$2}-#{$1} #{$3}:#{$4}"
      puts "   date: >#{value}<"

      ## todo: lets you configure year
      ##  and time zone (e.g. cet, eet, utc, etc.)
      
      line.sub!( regex_de, '[DATE.DE]' )

      return DateTime.strptime( value, '%Y-%m-%d %H:%M' )
    else
      return nil
    end
  end


  def find_game_pos!( line )
    # extract optional game pos from line
    # and return it
    # NB: side effect - removes pos from line string

    # e.g.  (1)   - must start line 
    regex = /^[ \t]*\((\d{1,3})\)[ \t]+/
    if line =~ regex
      puts "   pos: >#{$1}<"
      
      line.sub!( regex, '[POS] ' )
      return $1.to_i
    else
      return nil
    end

  end

  def find_scores!( line )
    # extract score from line
    # and return it
    # NB: side effect - removes date from line string
    
    # e.g. 1:2 or 0:2 or 3:3
    regex = /\b(\d):(\d)\b/
    
    # e.g. 1:2nV  => overtime
    regex_ot = /\b(\d):(\d)[ \t]?[nN][vV]\b/
    
    # e.g. 5:4iE  => penalty
    regex_p = /\b(\d):(\d)[ \t]?[iI][eE]\b/
    
    scores = []
    
    if line =~ regex
      puts "   score: >#{$1}-#{$2}<"
      
      line.sub!( regex, '[SCORE]' )

      scores << $1.to_i
      scores << $2.to_i
      
      if line =~ regex_ot
        puts "   score.ot: >#{$1}-#{$2}<"
      
        line.sub!( regex_ot, '[SCORE.OT]' )

        scores << $1.to_i
        scores << $2.to_i
      
        if line =~ regex_p
          puts "   score.p: >#{$1}-#{$2}<"
      
          line.sub!( regex_p, '[SCORE.P]' )

          scores << $1.to_i
          scores << $2.to_i
        end
      end
    end
    scores
  end # methdod find_scores!
  

  def find_team_worker!( line, index )
    regex = /@@oo([^@]+?)oo@@/     # e.g. everything in @@ .... @@ (use non-greedy +? plus all chars but not @, that is [^@])
    
    if line =~ regex
      value = "#{$1}"
      puts "   team#{index}: >#{value}<"
      
      line.sub!( regex, "[TEAM#{index}]" )

      return $1
    else
      return nil
    end
  end
  
  def find_teams!( line )
    counter = 1
    teams = []
    
    team = find_team_worker!( line, counter )
    while team.present?
      teams << team
      counter += 1
      team = find_team_worker!( line, counter )
    end
    
    teams
  end

  def find_team1!( line )
    find_team_worker!( line, 1 )
  end
  
  def find_team2!( line )
    find_team_worker!( line, 2 )
  end


  def match_team_worker!( line, key, values )
    values.each do |value|
      ## nb: \b does NOT include space or newline for word boundry (only alphanums e.g. a-z0-9)
      ## (thus add it, allows match for Benfica Lis.  for example - note . at the end)

      ## check add $ e.g. (\b| |\t|$) does this work? - check w/ Benfica Lis.$
      regex = /\b#{value}(\b| |\t|$)/   # wrap with world boundry (e.g. match only whole words e.g. not wac in wacker) 
      if line =~ regex
        puts "     match for team >#{key}< >#{value}<"
        # make sure @@oo{key}oo@@ doesn't match itself with other key e.g. wacker, wac, etc.
        line.sub!( regex, "@@oo#{key}oo@@ " )    # NB: add one space char at end
        return true    # break out after first match (do NOT continue)
      end
    end
    return false
  end
 
  ## todo/fix: pass in known_teams as a parameter? why? why not?
  def match_teams!( line )
    @known_teams.each do |rec|
      key    = rec[0]
      values = rec[1]
      match_team_worker!( line, key, values )
    end # each known_teams    
  end # method translate_teams!
  

end # module SportDB::FixtureHelpers

