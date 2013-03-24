# encoding: utf-8

### some utils moved to worldbdb/utils for reuse


module SportDb::FixtureHelpers

  def is_postponed?( line )
    # check if line include postponed marker e.g. =>
    line =~ /=>/
  end

  def is_round?( line )
    line =~ SportDb.lang.regex_round
  end

  def is_group?( line )
    # NB: check after is_round? (round may contain group reference!)
    line =~ SportDb.lang.regex_group
  end

  def is_knockout_round?( line )

    ## todo: check for adding ignore case for regex (e.g. 1st leg/1st Leg)

    if line =~ SportDb.lang.regex_leg1
      logger.debug "  two leg knockout; skip knockout flag on first leg"
      false
    elsif line =~ SportDb.lang.regex_knockout_round
      logger.debug "   setting knockout flag to true"
      true
    elsif line =~ /K\.O\.|K\.o\.|Knockout/
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

  def cut_off_end_of_line_comment!( line )
    #  cut off (that is, remove) optional end of line comment starting w/ #
    
    line = line.sub( /#.*$/, '' )
    line
  end


  def find_round_title2!( line )
    # assume everything after // is title2 - strip off leading n trailing whitespaces
    regex = /\/{2,}\s*(.+)\s*$/
    if line =~ regex
      logger.debug "   title2: >#{$1}<"
      
      line.sub!( regex, '[ROUND|TITLE2]' )
      return $1
    else
      return nil    # no round title2 found (title2 is optional)
    end
  end


  def find_round_title!( line )
    # assume everything left is the round title
    #  extract all other items first (round title2, round pos, group title n pos, etc.)

    buf = line.dup
    logger.debug "  find_round_title! line-before: >>#{buf}<<"

    buf.gsub!( /\[.+?\]/, '' )   # e.g. remove [ROUND|POS], [ROUND|TITLE2], [GROUP|TITLE+POS] etc.
    buf.sub!( /\s+[\/\-]{1,}\s+$/, '' )    # remove optional trailing / or / chars (left over from group)
    buf.strip!    # remove leading and trailing whitespace

    logger.debug "  find_round_title! line-after: >>#{buf}<<"

    ### bingo - assume what's left is the round title

    logger.debug "   title: >>#{buf}<<"
    line.sub!( buf, '[ROUND|TITLE]' )

    buf
  end


  def find_round_pos!( line )
    ## fix/todo:
    ##  if no round found assume last_pos+1 ??? why? why not?

    # extract optional round pos from line
    # e.g.  (1)   - must start line 
    regex_pos = /^[ \t]*\((\d{1,3})\)[ \t]+/

    ## find free standing number
    regex_num = /\b(\d{1,3})\b/

    if line =~ regex_pos
      logger.debug "   pos: >#{$1}<"
      
      line.sub!( regex_pos, '[ROUND|POS] ' )  ## NB: add back trailing space that got swallowed w/ regex -> [ \t]+
      return $1.to_i
    elsif line =~ regex_num
      ## assume number in title is pos (e.g. Jornada 3, 3 Runde etc.)
      ## NB: do NOT remove pos from string (will get removed by round title)
      logger.debug "   pos: >#{$1}<"
      return $1.to_i
    else
      ## fix: add logger.warn no round pos found in line
      return nil
    end
  end # method find_round_pos!
  
  def find_date!( line )
    # extract date from line
    # and return it
    # NB: side effect - removes date from line string
    
    # e.g. 2012-09-14 20:30   => YYYY-MM-DD HH:MM
    #  nb: allow 2012-9-3 7:30 e.g. no leading zero required
    regex_db = /\b(\d{4})-(\d{1,2})-(\d{1,2})\s+(\d{1,2}):(\d{2})\b/
    
    # e.g. 2012-09-14  w/ implied hours (set to 12:00)
    #  nb: allow 2012-9-3 e.g. no leading zero required
    regex_db2 = /\b(\d{4})-(\d{1,2})-(\d{1,2})\b/

    # e.g. 14.09. 20:30  => DD.MM. HH:MM
    #  nb: allow 2.3.2012 e.g. no leading zero required
    #  nb: allow hour as 20.30  or 3.30 instead of 03.30
    regex_de = /\b(\d{1,2})\.(\d{1,2})\.\s+(\d{1,2})[:.](\d{2})\b/
    
    # e.g. 14.09.2012 20:30   => DD.MM.YYYY HH:MM
    #  nb: allow 2.3.2012 e.g. no leading zero required
    #  nb: allow hour as 20.30
    regex_de2 = /\b(\d{1,2})\.(\d{1,2})\.(\d{4})\s+(\d{1,2})[:.](\d{2})\b/


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
      
      #### fix/todo:
      #  get year from event start date!!!!
      #  do NOT hard code!!!!
      
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
  

end # module SportDb::FixtureHelpers
