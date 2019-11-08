# encoding: utf-8


module DateFormats


  def self.lang
    @@lang ||= :en            ## defaults to english (:en)
  end
  def self.lang=( value )
    @@lang  = value.to_sym    ## note: make sure lang is always a symbol for now (NOT a string)
  end

  
  def self.parser( lang: )  ## find parser
    lang = lang.to_sym  ## note: make sure lang is always a symbol for now (NOT a string)

     ## note: cache all "built-in" lang versions (e.g. formats == nil)
     @@parser ||= {}
     parser = @@parser[ lang ] ||= DateParser.new( lang: lang )
   end
    
  def self.parse( line,
                  lang:    DateFormats.lang,    ## todo/check: if is for modules something like self.class.lang??
                  start:   Date.new( Date.today.year, 1, 1 )  ## note: default to current YYYY.01.01. if no start provided
                )
     parser( lang: lang ).parse( line, start: start )
  end

  def self.find!( line,
                  lang:  DateFormats.lang,    ## todo/check: if is for modules something like self.class.lang??
                  start: Date.new( Date.today.year, 1, 1 ) ## note: default to current YYYY.01.01. if no start provided
                )
     parser( lang: lang ).find!( line, start: start )
  end



  class DateParser

    include LogUtils::Logging

    def initialize( lang: )
      @lang = lang.to_sym

      ## fallback to english if lang not available
      ##  todo/fix: add/issue warning!!!!!          
      @formats =  FORMATS[ @lang ] || FORMATS[:en]
      
      ## fix/fix:  add MONTH_NAMES and DAY_NAMES if present and build/gen mappings etc.  (do NOT forget to downcase!!!)
    end

    def parse( line, start: )
      date = nil
      @formats.each do |format|
        re = format[0]
        m = re.match( line )
        if m
          date = parse_match_data( m, start: start )
          break
        end
        # no match; continue; try next regex pattern
      end

      ## todo/fix - raise ArgumentError - invalid date; no format match found
      date  # note: nil if no match found
    end


    def find!( line, start: )
      # fix: use more lookahead for all required trailing spaces!!!!!
      # fix: use <name capturing group> for month,day,year etc.!!!

      #
      # fix: !!!!
      #   date in [] will become [[DATE.DE4]] - when getting removed will keep ]!!!!
      #   fix: change regex to \[[A-Z0-9.]\]  !!!!!!  plus add unit test too!!!
      #

      date = nil
      @formats.each do |format|
        re  = format[0]
        tag = format[1]
        m = re.match( line )
        if m
          date = parse_match_data( m, start: start )
          ## fix: use md[0] e.g. match for sub! instead of using regex again - why? why not???
          ## fix: use md.begin(0), md.end(0)
          line.sub!( m[0], tag )
          ## todo/fix: make sure match data will not get changed (e.g. using sub! before parse_date_time)
          break
        end
        # no match; continue; try next regex pattern
      end
      date  # note: nil if no match found
    end

  private
    def calc_year( month, day, start: )

      logger.debug "   [calc_year] ????-#{month}-#{day} -- start: #{start}"

      if month >= start.month
        # assume same year as start_at event (e.g. 2013 for 2013/14 season)
        start.year
      else
        # assume year+1 as start_at event (e.g. 2014 for 2013/14 season)
        start.year+1
      end
    end


    def parse_match_data( m, start: )
      # convert regex match_data captures to hash
      # - note: cannont use match_data like a hash (e.g. raises exception if key/name not present/found)
      h = {}
      # - note: do NOT forget to turn name into symbol for lookup in new hash (name.to_sym)
      m.names.each { |name| h[name.to_sym] = m[name] }  # or use match_data.names.zip( match_data.captures )  - more cryptic but "elegant"??

      ## puts "[parse_date_time] match_data:"
      ## pp h
      logger.debug "   [parse_match_data] hash: >#{h.inspect}<"

      h[ :month ] = MONTH_EN_TO_MM[ h[:month_en] ]  if h[:month_en]   ## todo/fix: change to "generic" month_name and day_name !!!
      h[ :month ] = MONTH_ES_TO_MM[ h[:month_es] ]  if h[:month_es]
      h[ :month ] = MONTH_FR_TO_MM[ h[:month_fr] ]  if h[:month_fr]
      h[ :month ] = MONTH_DE_TO_MM[ h[:month_de] ]  if h[:month_de]
      h[ :month ] = MONTH_IT_TO_MM[ h[:month_it] ]  if h[:month_it]
      h[ :month ] = MONTH_PT_TO_MM[ h[:month_pt] ]  if h[:month_pt]

      month   = h[:month]
      day     = h[:day]
      year    = h[:year]     || calc_year( month.to_i, day.to_i, start: start ).to_s

      if h[:hours] || h[:minutes]   ## check time (hours or minutes) is present (otherwise asume just Date and NOT DateTime)
        hours   = h[:hours]    || '00'   # default to 00:00 for HH:MM (hours:minutes)
        minutes = h[:minutes]  || '00'

        value = '%d-%02d-%02d %02d:%02d' % [year.to_i, month.to_i, day.to_i, hours.to_i, minutes.to_i]
        logger.debug "   datetime: >#{value}<"

        DateTime.strptime( value, '%Y-%m-%d %H:%M' )
      else
        value = '%d-%02d-%02d' % [year.to_i, month.to_i, day.to_i]
        logger.debug "   date: >#{value}<"

        Date.strptime( value, '%Y-%m-%d' )
      end
    end  # method parse
  end # class DateParser



  class RsssfDateParser < DateParser

    MONTH_EN = 'Jan|'+
               'Feb|'+
               'March|Mar|'+
               'April|Apr|'+
               'May|'+
               'June|Jun|'+
               'July|Jul|'+
               'Aug|'+
               'Sept|Sep|'+
               'Oct|'+
               'Nov|'+
               'Dec'

    ## e.g.
    ##  [Jun 7]  or [Aug 12] etc.  - not MUST include brackets e.g. []
    ##
    ##  check add \b at the beginning and end - why?? why not?? working??
    EN__MONTH_DD__DATE_RE = /\[
                     (?<month_en>#{MONTH_EN})
                        \s
                     (?<day>\d{1,2})
                       \]/x

    def initialize
      super( lang:    'en',
             formats: [[EN__MONTH_DD__DATE_RE, '[EN_MONTH_DD]']]
           )
    end
  end  ## class RsssfDateParser

end # module DateFormats
