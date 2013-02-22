# encoding: utf-8

### some utils moved to worldbdb/utils for reuse


module SportDB::FixtureHelpers

  def is_round?( line )
    line =~ SportDB.lang.regex_round
  end

  def is_group?( line )
    # NB: check after is_round? (round may contain group reference!)
    line =~ SportDB.lang.regex_group
  end

  def is_knockout_round?( line )
    
    ## todo: check for adding ignore case for regex (e.g. 1st leg/1st Leg)
    
    if line =~ SportDB.lang.regex_leg1
      logger.debug "  two leg knockout; skip knockout flag on first leg"
      false
    elsif line =~ SportDB.lang.regex_knockout_round
      logger.debug "   setting knockout flag to true"
      true
    elsif line =~ /K\.O\.|Knockout/
        ## NB: add two language independent markers, that is, K.O. and Knockout
      logger.debug "   setting knockout flag to true (lang independent marker)"
      true
    else
      false
    end
  end
  
  def find_group_title_and_pos!( line )
    ## group pos - for now support single digit e.g 1,2,3 or letter e.g. A,B,C or HEX
    ## nb:  (?:)  = is for non-capturing group(ing)
    regex = /(?:Group|Gruppe|Grupo)\s+((?:\d{1}|[A-Z]{1,3}))\b/
    
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
          when 'K' then 11
          when 'L' then 12
          when 'HEX' then 666    # HEX for Hexagonal - todo/check: map to something else ??
          else  match[1].to_i
          end

    title = match[0]

    logger.debug "   title: >#{title}<"
    logger.debug "   pos: >#{pos}<"
      
    line.sub!( regex, '[GROUP|TITLE+POS]' )

    return [title,pos]
  end
  
  def find_round_pos!( line )
    
    ## todo: let title2 go first to cut off //
    ## todo: cut of end of line comments w/ # ???
    
    ## fix/todo:
    ##  if no round found assume last_pos+1 ??? why? why not?

    # extract optional round pos from line
    # e.g.  (1)   - must start line 
    regex = /^[ \t]*\((\d{1,3})\)[ \t]+/
    if line =~ regex
      logger.debug "   pos: >#{$1}<"
      
      line.sub!( regex, '[ROUND|POS] ' )  ## NB: add back trailing space that got swallowed w/ regex -> [ \t]+
      return $1.to_i
    end

    # continue; try some other options

    # NB: do not search string after free standing / or //
    #  cut-off optional trailing part w/ starting w/  / or //
    #
    # e.g.  Viertelfinale   //   Di+Mi 10.+11. April 2012  becomes just
    #       Viertelfinale
    
    cutoff_regex = /^(.+?)[ \t]\/{1,3}[ \t]/
    
    if line =~ cutoff_regex
      line = $1.to_s    # cut off the rest if regex matches
    end

    ## fix/todo: use cutoff_line for search
    ## and use line.sub! to change original string
    # e.g.  Jornada 3  // 1,2 y 3 febrero
    #   only replaces match in local string w/ [ROUND|POS]

    regex = /\b(\d+)\b/
    
    if line =~ regex
      value = $1.to_i
      logger.debug "   pos: >#{value}<"
      
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
    
    # e.g. 2012-09-14  w/ implied hours (set to 12:00)
    regex_db2 = /\b(\d{4})-(\d{2})-(\d{2})\b/

    # e.g. 14.09. 20:30  => DD.MM. HH:MM
    regex_de = /\b(\d{2})\.(\d{2})\.\s+(\d{2}):(\d{2})\b/
    
    # e.g. 14.09.2012 20:30   => DD.MM.YYYY HH:MM
    regex_de2 = /\b(\d{2})\.(\d{2})\.(\d{4})\s+(\d{2}):(\d{2})\b/

    if line =~ regex_db
      value = "#{$1}-#{$2}-#{$3} #{$4}:#{$5}"
      logger.debug "   date: >#{value}<"

      ## todo: lets you configure year
      ##  and time zone (e.g. cet, eet, utc, etc.)
      
      line.sub!( regex_db, '[DATE.DB]' )

      return DateTime.strptime( value, '%Y-%m-%d %H:%M' )
    elsif line =~ regex_db2
      value = "#{$1}-#{$2}-#{$3} 12:00"
      logger.debug "   date: >#{value}<"
      
      line.sub!( regex_db2, '[DATE.DB2]' )

      return DateTime.strptime( value, '%Y-%m-%d %H:%M' )
    elsif line =~ regex_de2
      value = "#{$3}-#{$2}-#{$1} #{$4}:#{$5}"
      logger.debug "   date: >#{value}<"

      ## todo: lets you configure year
      ##  and time zone (e.g. cet, eet, utc, etc.)
      
      line.sub!( regex_de2, '[DATE.DE2]' )

      return DateTime.strptime( value, '%Y-%m-%d %H:%M' )
    elsif line =~ regex_de
      value = "2012-#{$2}-#{$1} #{$3}:#{$4}"
      logger.debug "   date: >#{value}<"

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
      logger.debug "   pos: >#{$1}<"
      
      line.sub!( regex, '[POS] ' )
      return $1.to_i
    else
      return nil
    end

  end

  def find_scores!( line )

    ### fix: depending on language allow 1:1 or 1-1
    ##   do NOT allow mix and match
    ##  e.g. default to en is  1-1
    ##    de is 1:1 etc.
    

    # extract score from line
    # and return it
    # NB: side effect - removes date from line string
    
    # e.g. 1:2 or 0:2 or 3:3 // 1-1 or 0-2 or 3-3
    regex = /\b(\d)[:\-](\d)\b/
    
    # e.g. 1:2nV  => overtime
    regex_ot = /\b(\d)[:\-](\d)[ \t]?[nN][vV]\b/
    
    # e.g. 5:4iE  => penalty
    regex_p = /\b(\d)[:\-](\d)[ \t]?[iI][eE]\b/
    
    scores = []
    
    if line =~ regex
      logger.debug "   score: >#{$1}-#{$2}<"
      
      line.sub!( regex, '[SCORE]' )

      scores << $1.to_i
      scores << $2.to_i
      
      if line =~ regex_ot
        logger.debug "   score.ot: >#{$1}-#{$2}<"
      
        line.sub!( regex_ot, '[SCORE.OT]' )

        scores << $1.to_i
        scores << $2.to_i
      
        if line =~ regex_p
          logger.debug "   score.p: >#{$1}-#{$2}<"
      
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
      logger.debug "   team#{index}: >#{value}<"
      
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
        logger.debug "     match for team >#{key}< >#{value}<"
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
