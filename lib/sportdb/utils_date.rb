# encoding: utf-8

module SportDb
  module FixtureHelpers

  def is_postponed?( line )
    # check if line include postponed marker e.g. =>
    line =~ /=>/
  end

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
    regex_de4 = /\b(\d{1,2})\.(\d{1,2})\.(?:\s+|$)/    ## note: allow end-of-string/line too


    # todo: make more generic for reuse
    month_abbrev_en = 'Jan|Feb|March|Mar|April|Apr|May|June|Jun|July|Jul|Aug|Sept|Sep|Oct|Nov|Dec'
    month_abbrev_en_to_i = {
        'Jan' => 1,
        'Feb' => 2,
        'Mar' => 3, 'March' => 3,
        'Apr' => 4, 'April' => 4,
        'May' => 5,
        'Jun' => 6, 'June' => 6,
        'Jul' => 7, 'July' => 7,
        'Aug' => 8,
        'Sep' => 9, 'Sept' => 9,
        'Oct' => 10,
        'Nov' => 11,
        'Dec' => 12 }


    # e.g. 12 May 2013 14:00  => D|DD.MMM.YYYY H|HH:MM
    regex_en = /\b(\d{1,2})\s(#{month_abbrev_en})\s(\d{4})\s+(\d{1,2}):(\d{2})\b/


    # e.g.  Jun/12 14:00  w/ implied year H|HH:MM
    regex_en2  = /\b(#{month_abbrev_en})\/(\d{1,2})\s+(\d{1,2}):(\d{2})\b/

    # e.g.  Jun/12  w/ implied year and implied hours (set to 12:00)
    regex_en21 = /\b(#{month_abbrev_en})\/(\d{1,2})\b/

    # todo/fix - add de and es too!!
    # note: in Austria - Jänner - in Deutschland Januar allow both ??
    month_abbrev_de = 'J[aä]n|Feb|Mär|Apr|Mai|Jun|Jul|Aug|Sep|Okt|Nov|Dez'

    month_abbrev_es = 'Enero|Ene|Feb|Marzo|Mar|Abril|Abr|Mayo|May|Junio|Jun|Julio|Jul|Agosto|Ago|Sept|Set|Sep|Oct|Nov|Dic'
    month_abbrev_es_to_i = {
        'Ene' => 1, 'Enero' => 1,
        'Feb' => 2,
        'Mar' => 3, 'Marzo' => 3,
        'Abr' => 4, 'Abril' => 4,
        'May' => 5, 'Mayo' => 5,
        'Jun' => 6, 'Junio' => 6,
        'Jul' => 7, 'Julio' => 7,
        'Ago' => 8, 'Agosto' => 8,
        'Sep' => 9, 'Set' => 9, 'Sept' => 9,
        'Oct' => 10,
        'Nov' => 11,
        'Dic' => 12 }

    # e.g.  12 Ene  w/ implied year and implied hours (set to 12:00)
    regex_es21 = /\b(\d{1,2})\s(#{month_abbrev_es})\b/

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
      day     = $2.to_i
      month   = month_abbrev_en_to_i[ $1 ]
      year    = calculate_year( day, month, opts[:start_at] )
      hours   = $3.to_i
      minutes = $4.to_i

      value = '%d-%02d-%02d %02d:%02d' % [year, month, day, hours, minutes]
      logger.debug "   date: >#{value}<"

      line.sub!( regex_en2, '[DATE.EN2] ' )

      return DateTime.strptime( value, '%Y-%m-%d %H:%M' )
    elsif line =~ regex_en21
      day   = $2.to_i
      month = month_abbrev_en_to_i[ $1 ]
      year = calculate_year( day, month, opts[:start_at] )

      value = '%d-%02d-%02d 12:00' % [year, month, day]
      logger.debug "   date: >#{value}<"

      line.sub!( regex_en21, '[DATE.EN21] ' )

      return DateTime.strptime( value, '%Y-%m-%d %H:%M' )
    elsif line =~ regex_es21
      day   = $1.to_i
      month = month_abbrev_es_to_i[ $2 ]
      year = calculate_year( day, month, opts[:start_at] )

      value = '%d-%02d-%02d 12:00' % [year, month, day]
      logger.debug "   date: >#{value}<"

      line.sub!( regex_es21, '[DATE.ES21] ' )

      return DateTime.strptime( value, '%Y-%m-%d %H:%M' )
    else
      return nil
    end
  end

  end # module FixtureHelpers
end # module SportDb

