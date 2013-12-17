# encoding: utf-8

### note: some utils moved to worldbdb/utils for reuse


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
    
    line.sub!( /#.*$/ ) do |_|
      logger.debug "   cutting off end of line comment - >>#{$&}<<"
      ''
    end
    
    # NB: line = line.sub  will NOT work - thus, lets use line.sub!
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


  def calculate_year( day, month, start_at )
    if month >= start_at.month
      # assume same year as start_at event (e.g. 2013 for 2013/14 season)
      start_at.year
    else
      # assume year+1 as start_at event (e.g. 2014 for 2013/14 season)
      start_at.year+1
    end
  end

  def find_date!( line, opts={} )

    ## NB: lets us pass in start_at/end_at date (for event)
    #   for auto-complete year

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

    # e.g. 14.09.2012  => DD.MM.YYYY w/ implied hours (set to 12:00)
    regex_de3 = /\b(\d{1,2})\.(\d{1,2})\.(\d{4})\b/

    # e.g. 14.09.  => DD.MM. w/ implied year and implied hours (set to 12:00)
    regex_de4 = /\b(\d{1,2})\.(\d{1,2})\.\s+/


    month_abbrev_en = "Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec"

    # e.g. 12 May 2013 14:00  => D|DD.MMM.YYYY H|HH:MM
    regex_en = /\b(\d{1,2})\s(#{month_abbrev_en})\s(\d{4})\s+(\d{1,2}):(\d{2})\b/

    ## todo: add version w/ hours
    # e.g.  Jun/12  w/ implied year and implied hours (set to 12:00)
    regex_en2 = /\b(#{month_abbrev_en})\/(\d{1,2})\b/


    if line =~ regex_db
      value = '%d-%02d-%02d %02d:%02d' % [$1.to_i, $2.to_i, $3.to_i, $4.to_i, $5.to_i]
      logger.debug "   date: >#{value}<"

      ## todo: lets you configure year
      ##  and time zone (e.g. cet, eet, utc, etc.)
      
      line.sub!( regex_db, '[DATE.DB]' )

      return DateTime.strptime( value, '%Y-%m-%d %H:%M' )
    elsif line =~ regex_db2
      value = '%d-%02d-%02d 12:00' % [$1.to_i, $2.to_i, $3.to_i]
      logger.debug "   date: >#{value}<"

      line.sub!( regex_db2, '[DATE.DB2]' )

      return DateTime.strptime( value, '%Y-%m-%d %H:%M' )
    elsif line =~ regex_de2
      value = '%d-%02d-%02d %02d:%02d' % [$3.to_i, $2.to_i, $1.to_i, $4.to_i, $5.to_i]
      logger.debug "   date: >#{value}<"

      ## todo: lets you configure year
      ##  and time zone (e.g. cet, eet, utc, etc.)
      
      line.sub!( regex_de2, '[DATE.DE2]' )

      return DateTime.strptime( value, '%Y-%m-%d %H:%M' )
    elsif line =~ regex_de

      year = calculate_year( $1.to_i, $2.to_i, opts[:start_at] )

      value = '%d-%02d-%02d %02d:%02d' % [year, $2.to_i, $1.to_i, $3.to_i, $4.to_i]
      logger.debug "   date: >#{value}<"

      ## todo: lets you configure year
      ##  and time zone (e.g. cet, eet, utc, etc.)
      
      line.sub!( regex_de, '[DATE.DE]' )

      return DateTime.strptime( value, '%Y-%m-%d %H:%M' )
    elsif line =~ regex_de3
      value = '%d-%02d-%02d 12:00' % [$3.to_i, $2.to_i, $1.to_i]
      logger.debug "   date: >#{value}<"

      ## todo: lets you configure year
      ##  and time zone (e.g. cet, eet, utc, etc.)
      
      line.sub!( regex_de3, '[DATE.DE3]' )

      return DateTime.strptime( value, '%Y-%m-%d %H:%M' )
    elsif line =~ regex_de4

      year = calculate_year( $1.to_i, $2.to_i, opts[:start_at] )

      value = '%d-%02d-%02d 12:00' % [year, $2.to_i, $1.to_i]
      logger.debug "   date: >#{value}<"

      ## todo: lets you configure year
      ##  and time zone (e.g. cet, eet, utc, etc.)

      ### NOTE: needs a trailing space
      #   not if regex ends w/ whitespace e.g. /s+
      #  make sure sub! adds a space at the end
      #   e.g. '[DATE.DE4]' becomes '[DATE.DE4] '

      line.sub!( regex_de4, '[DATE.DE4] ' )

      return DateTime.strptime( value, '%Y-%m-%d %H:%M' )
    elsif line =~ regex_en
      value = '%d-%s-%02d %02d:%02d' % [$3.to_i, $2, $1.to_i, $4.to_i, $5.to_i]
      logger.debug "   date: >#{value}<"

      line.sub!( regex_en, '[DATE.EN]' )

      return DateTime.strptime( value, '%Y-%b-%d %H:%M' )   ## %b - abbreviated month name (e.g. Jan,Feb, etc.)
    elsif line =~ regex_en2
      # todo: make more generic for reuse
      month_abbrev_en_to_i = {
        'Jan' => 1,
        'Feb' => 2,
        'Mar' => 3,
        'Apr' => 4,
        'May' => 5,
        'Jun' => 6,
        'Jul' => 7,
        'Aug' => 8,
        'Sep' => 9,
        'Oct' => 10,
        'Nov' => 11,
        'Dec' => 12 }

      day   = $2.to_i
      month = month_abbrev_en_to_i[ $1 ]
      year = calculate_year( day, month, opts[:start_at] )

      value = '%d-%02d-%02d 12:00' % [year, month, day]
      logger.debug "   date: >#{value}<"

      line.sub!( regex_en2, '[DATE.EN2] ' )

      return DateTime.strptime( value, '%Y-%m-%d %H:%M' )
    else
      return nil
    end
  end


  def find_record_comment!( line )
    # assume everything left after the last record marker,that is, ] is a record comment

    regex = /]([^\]]+?)$/   # NB: use non-greedy +?

    if line =~ regex
      value = $1.strip
      return nil if value.blank?   # skip whitespaces only

      logger.debug "   comment: >#{value}<"

      line.sub!( value, '[REC.COMMENT] ' )
      return value
    else
      return nil
    end
  end


  def find_record_timeline!( line )

    #  +1 lap or +n laps
    regex_laps = /\s+\+\d{1,2}\s(lap|laps)\b/

    #  2:17:15.123
    regex_time = /\b\d{1,2}:\d{2}:\d{2}\.\d{1,3}\b/

    #  +40.1 secs
    regex_secs = /\s+\+\d{1,3}\.\d{1,3}\s(secs)\b/   # NB: before \+ - boundry (\b) will not work 

    # NB: $& contains the complete matched text

    if line =~ regex_laps
      value = $&.strip
      logger.debug "   timeline.laps: >#{value}<"

      line.sub!( value, '[REC.TIMELINE.LAPS] ' ) # NB: add trailing space
      return value
    elsif line =~ regex_time
      value = $&.strip
      logger.debug "   timeline.time: >#{value}<"

      line.sub!( value, '[REC.TIMELINE.TIME] ' ) # NB: add trailing space
      return value
    elsif line =~ regex_secs
      value = $&.strip
      logger.debug "   timeline.secs: >#{value}<"

      line.sub!( value, '[REC.TIMELINE.SECS] ' ) # NB: add trailing space
      return value
    else
      return nil
    end
  end

  def find_record_laps!( line )
    # e.g.  first free-standing number w/ one or two digits e.g. 7 or 28 etc.
    regex = /\b(\d{1,2})\b/
    if line =~ regex
      logger.debug "   laps: >#{$1}<"
      
      line.sub!( regex, '[REC.LAPS] ' ) # NB: add trailing space
      return $1.to_i
    else
      return nil
    end
  end

  def find_record_leading_state!( line )
    # e.g.  1|2|3|etc or Ret  - must start line 
    regex = /^[ \t]*(\d{1,3}|Ret)[ \t]+/
    if line =~ regex
      value = $1.dup
      logger.debug "   state: >#{value}<"

      line.sub!( regex, '[REC.STATE] ' ) # NB: add trailing space
      return value
    else
      return nil
    end
  end


  def find_leading_pos!( line )
    # extract optional game pos from line
    # and return it
    # NB: side effect - removes pos from line string

    # e.g.  (1)   - must start line 
    regex = /^[ \t]*\((\d{1,3})\)[ \t]+/
    if line =~ regex
      logger.debug "   pos: >#{$1}<"

      line.sub!( regex, '[POS] ' ) # NB: add trailing space
      return $1.to_i
    else
      return nil
    end
  end

  def find_game_pos!( line )
    ## fix: add depreciation warning - remove - use find_leading_pos!
    find_leading_pos!( line )
  end


  def find_scores!( line )

    # note: always call after find_dates !!!
    #  scores match date-like patterns!!  e.g. 10-11  or 10:00 etc.
    #   -- note: score might have two digits too

    ### fix: depending on language allow 1:1 or 1-1
    ##   do NOT allow mix and match
    ##  e.g. default to en is  1-1
    ##    de is 1:1 etc.
    

    # extract score from line
    # and return it
    # NB: side effect - removes date from line string
    
    # note: regex should NOT match regex extra time or penalty
    #  thus, we do NOT any longer allow spaces for now between
    #   score and marker (e.g. nV,iE, etc.)

    # e.g. 1:2 or 0:2 or 3:3 // 1-1 or 0-2 or 3-3
    regex = /\b(\d{1,2})[:\-](\d{1,2})\b/

    ## todo: add/allow english markers e.g. aet ??

    ## fix: use case insansitive flag instead e.g. /i
    #    instead of [nN] etc.

    # e.g. 1:2nV  => after extra time a.e.t
    regex_et = /\b(\d{1,2})[:\-](\d{1,2})[nN][vV]\b/

    # e.g. 5:4iE  => penalty / after penalty a.p
    regex_p = /\b(\d{1,2})[:\-](\d{1,2})[iI][eE]\b/

    scores = []

    ## todo: how to handle game w/o extra time
    #   but w/ optional penalty ???  e.g. used in copa liberatores, for example
    #    retrun 0,0 or nil,nil for extra time score ?? or -1, -1 ??
    #    for now use nil,nil

    if line =~ regex
      logger.debug "   score: >#{$1}-#{$2}<"
      
      line.sub!( regex, '[SCORE]' )

      scores << $1.to_i
      scores << $2.to_i
    end

    ## todo:
    ##   reverse matching order ??? allows us to support spaces for nV and iE
    ##    why? why not??

    if line =~ regex_et
      logger.debug "   score.et: >#{$1}-#{$2}<"
      
      line.sub!( regex_et, '[SCORE.ET]' )

      ## check scores empty? - fill with nil,nil
      scores += [nil,nil]  if scores.size == 0

      scores << $1.to_i
      scores << $2.to_i
    end

    if line =~ regex_p
      logger.debug "   score.p: >#{$1}-#{$2}<"
      
      line.sub!( regex_p, '[SCORE.P]' )

      ## check scores empty? - fill with nil,nil
      scores += [nil,nil]  if scores.size == 0
      scores += [nil,nil]  if scores.size == 2

      scores << $1.to_i
      scores << $2.to_i
    end
    scores
  end # methdod find_scores!



  def find_teams!( line ) # NB: returns an array - note: plural! (teamsss)
    TextUtils.find_keys_for!( 'team', line )
  end
  
  def find_team!( line )  # NB: returns key (string or nil)
    TextUtils.find_key_for!( 'team', line )
  end

  ## todo: check if find_team1 gets used?  if not remove it!!  use find_teams!
  def find_team1!( line )
    TextUtils.find_key_for!( 'team1', line )
  end

  def find_team2!( line )
    TextUtils.find_key_for!( 'team2', line )
  end

  ## todo/fix: pass in known_teams as a parameter? why? why not?

  def map_teams!( line )
    TextUtils.map_titles_for!( 'team', line, @known_teams )
  end
  
  def map_team!( line )  # alias map_teams!
    map_teams!( line )
  end

  def find_track!( line )
    TextUtils.find_key_for!( 'track', line )
  end

  ## todo/fix: pass in known_tracks as a parameter? why? why not?
  def map_track!( line )
    TextUtils.map_titles_for!( 'track', line, @known_tracks )
  end

  def find_person!( line )
    TextUtils.find_key_for!( 'person', line )
  end

  def map_person!( line )
    TextUtils.map_titles_for!( 'person', line, @known_persons)
  end



  ## depreciated methods - use map_
  def match_teams!( line )   ## fix: rename to map_teams!! - remove match_teams!
    ## todo: issue depreciated warning
    map_teams!( line )
  end # method match_teams!

  def match_track!( line )  ## fix: rename to map_track!!!
    ## todo: issue depreciated warning
    map_track!( line )
  end # method match_tracks!


end # module SportDb::FixtureHelpers
