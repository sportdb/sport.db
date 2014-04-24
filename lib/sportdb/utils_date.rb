# encoding: utf-8

module SportDb
  module FixtureHelpers

  def is_postponed?( line )
    # check if line include postponed marker e.g. =>
    line =~ /=>/
  end


  def calculate_year( day, month, start_at )
  ##
  #  fix: change arg order to month, day  --  to match parse_date_time etc. ?? why? why not?
  #
    if month >= start_at.month
      # assume same year as start_at event (e.g. 2013 for 2013/14 season)
      start_at.year
    else
      # assume year+1 as start_at event (e.g. 2014 for 2013/14 season)
      start_at.year+1
    end
  end

  ### helpers for parsing dates (from strings)
  def parse_date_time( match_data, opts={} )
    # todo:
    #  - rename to parse_date_time_from_match_data ?? why? why not?
    #  - wrap into DateParser - why? why not?
    
    # convert regex match_data captures to hash
    # - note: cannont use match_data like a hash (e.g. raises exception if key/name not present/found)
    h = {}
    match_data.names.each { |name| h[name] = match_data[name] }  # or use match_data.names.zip( match_data.captures )  - more cryptic but "elegant"??

    month   = h[:month]
    day     = h[:day]
    year    = h[:year]     || calculate_year( day.to_i, month.to_i, opts[:start_at] )

    hours   = h[:hours]    || '12'   # default to 12:00 for HH:MM (hours:minutes)
    minutes = h[:minutes]  || '00'
    
    value = '%d-%02d-%02d %02d:%02d' % [year.to_i, month.to_i, day.to_i, hours.to_i, minutes.to_i]
    logger.debug "   date: >#{value}<"

    DateTime.strptime( value, '%Y-%m-%d %H:%M' )
  end

  def parse_date( match_data, opts )
    ## just pass through for now
    parse_date_time( match_data, opts )  
  end



  def find_date!( line, opts={} )

    ## NB: lets us pass in start_at/end_at date (for event)
    #   for auto-complete year

    # extract date from line
    # and return it
    # NB: side effect - removes date from line string
    

    # fix: use more lookahead for all required trailing spaces!!!!!
    # fix: use <name capturing group> for month,day,year etc.!!!

    #
    # fix: !!!!
    #   date in [] will become [[DATE.DE4]] - when getting removed will keep ]!!!!
    #   fix: change regex to \[[A-Z0-9.]\]  !!!!!!  plus add unit test too!!!
    #

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

    # todo/fix - add de and es too!!
    # note: in Austria - Jänner - in Deutschland Januar allow both ??
    month_abbrev_de = 'J[aä]n|Feb|Mär|Apr|Mai|Jun|Jul|Aug|Sep|Okt|Nov|Dez'

    # e.g. 12 May 2013 14:00  => D|DD.MMM.YYYY H|HH:MM
    regex_en = /\b
                (?<day>\d{1,2})
                   \s
                (?<month_en>#{month_abbrev_en})
                   \s
                (?<year>\d{4})
                   \s+
                (?<hours>\d{1,2})
                  :
                (?<minutes>\d{2})
                  \b/x


    # e.g.  Jun/12 14:00  w/ implied year H|HH:MM
    regex_en2  = /\b
                   (?<month_en>#{month_abbrev_en})
                     \/
                   (?<day>\d{1,2})
                     \s+
                   (?<hours>\d{1,2})
                     :
                   (?<minutes>\d{2})
                     \b/x

    # e.g.  Jun/12  w/ implied year and implied hours (set to 12:00)
    regex_en21 = /\b
                   (?<month_en>#{month_abbrev_en})
                      \/
                   (?<day>\d{1,2})
                     \b/x

    # e.g.  12 Ene  w/ implied year and implied hours (set to 12:00)
    regex_es21 = /\b
                   (?<day>\d{1,2})
                     \s
                   (?<month_es>#{month_abbrev_es})
                     \b/x


    md = nil
    if (md=DB_DATE_TIME_REGEX.match( line ))
      ## fix: use md[0] e.g. match for sub! instead of using regex again - why? why not???
      line.sub!( DB_DATE_TIME_REGEX, '[DATE_TIME_DB]' )

      return parse_date_time( md, opts )
    elsif (md=DB_DATE_REGEX.match( line ))
      line.sub!( DB_DATE_REGEX, '[DATE_DB]' )

      return parse_date( md, opts )
    elsif (md=DE_DATE_TIME_REGEX.match( line ))
      line.sub!( DE_DATE_TIME_REGEX, '[DATE_TIME_DE]' )

      return parse_date_time( md, opts )
    elsif (md=DE2_DATE_TIME_REGEX.match( line ))
      line.sub!( DE2_DATE_TIME_REGEX, '[DATE_TIME_DE2]' )

      return parse_date_time( md, opts )  ## note: pass along opts[:start_at] to calculate year!!!
    elsif (md=DE_DATE_REGEX.match( line ))
      line.sub!( DE_DATE_REGEX, '[DATE_DE]' )

      return parse_date( md, opts )
    elsif (md=DE2_DATE_REGEX.match( line ))
      line.sub!( DE2_DATE_REGEX, '[DATE_DE2]' )

      return parse_date( md, opts )  ## note: pass along opts[:start_at] to calculate year!!!
    elsif (md=regex_en.match( line ))
      day     = md[:day].to_i
      month   = month_abbrev_en_to_i[ md[:month_en] ]   ## fix: change month_abbrev_en_to_i to month_en_to_i
      year    = md[:year].to_i
      hours   = md[:hours].to_i
      minutes = md[:minutes].to_i
      
      value = '%d-%02d-%02d %02d:%02d' % [year, month, day, hours, minutes]
      logger.debug "   date: >#{value}<"

      line.sub!( regex_en, '[DATE_EN]' )

      return DateTime.strptime( value, '%Y-%m-%d %H:%M' ) 
    elsif (md=regex_en2.match( line ))
      day     = md[:day].to_i
      month   = month_abbrev_en_to_i[ md[:month_en] ]   ## fix: change month_abbrev_en_to_i to month_en_to_i
      year    = calculate_year( day, month, opts[:start_at] )
      hours   = md[:hours].to_i
      minutes = md[:minutes].to_i

      value = '%d-%02d-%02d %02d:%02d' % [year, month, day, hours, minutes]
      logger.debug "   date: >#{value}<"

      line.sub!( regex_en2, '[DATE_EN2]' )

      return DateTime.strptime( value, '%Y-%m-%d %H:%M' )
    elsif (md=regex_en21.match( line ))
      day   = md[:day].to_i
      month = month_abbrev_en_to_i[ md[:month_en] ]  ## fix: change month_abbrev_en_to_i to month_en_to_i
      year  = calculate_year( day, month, opts[:start_at] )

      value = '%d-%02d-%02d 12:00' % [year, month, day]
      logger.debug "   date: >#{value}<"

      line.sub!( regex_en21, '[DATE_EN21]' )

      return DateTime.strptime( value, '%Y-%m-%d %H:%M' )
    elsif (md=regex_es21.match( line ))
      day   = md[:day].to_i
      month = month_abbrev_es_to_i[ md[:month_es] ]  ## fix: change month_abbrev_es_to_i to month_es_to_i
      year = calculate_year( day, month, opts[:start_at] )

      value = '%d-%02d-%02d 12:00' % [year, month, day]
      logger.debug "   date: >#{value}<"

      line.sub!( regex_es21, '[DATE_ES21]' )

      return DateTime.strptime( value, '%Y-%m-%d %H:%M' )
    else
      return nil
    end
  end

  end # module FixtureHelpers
end # module SportDb

