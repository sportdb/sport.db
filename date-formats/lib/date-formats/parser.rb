# encoding: utf-8


module DateFormats


  def self.lang
    @@lang ||= :en            ## defaults to english (:en)
  end
  def self.lang=( value )
    @@lang = value.to_sym    ## note: make sure lang is always a symbol for now (NOT a string)
    @@lang      ## todo/check: remove  =() method always returns passed in value? double check
  end


  def self.parser( lang: )  ## find parser
    lang = lang.to_sym  ## note: make sure lang is always a symbol for now (NOT a string)

    ## note: cache all "built-in" lang versions (e.g. formats == nil)
    @@parser ||= {}
    parser = @@parser[ lang ] ||= DateParser.new( lang: lang )
  end

  def self.parse( line,
                  lang:    DateFormats.lang,    ## todo/check: is there a "generic" like self.class.lang form? yes, module DateFormats needs to get changed to class DateFormats to work!!
                  start:   Date.new( Date.today.year, 1, 1 )  ## note: default to current YYYY.01.01. if no start provided
                )
    parser( lang: lang ).parse( line, start: start )
  end

  def self.find!( line,
                  lang:  DateFormats.lang,    ## todo/check: is there a "generic" like self.class.lang form?
                  start: Date.new( Date.today.year, 1, 1 ) ## note: default to current YYYY.01.01. if no start provided
                )
    parser( lang: lang ).find!( line, start: start )
  end




  class DateParser

    include Logging


    def initialize( lang:,
                    formats: nil, month_names: nil, day_names: nil
                  )
      @lang = lang.to_sym   ## note: make sure lang is always a symbol for now (NOT a string)

      if formats
        @formats = formats
      else
        @formats = FORMATS[ @lang ]
        if @formats
          month_names = MONTH_NAMES[ @lang ]
          day_names   = DAY_NAMES[ @lang ]
        else
          ## fallback to english if lang not available
          ##  todo/fix: add/issue warning!!!!!
          @formats    = FORMATS[ :en ]
          month_names = MONTH_NAMES[ :en ]
          day_names   = DAY_NAMES[ :en ]
        end
      end

      ## convert month_names and day_names to map if present
      @month_names = month_names ? build_map( month_names ) : nil
      @day_names   = day_names   ? build_map( day_names )   : nil
    end


    def parse( line, start: )
      date = nil
      @formats.each do |format|
        re = format[0]
        m = re.match( line )
        if m
          date = parse_matchdata( m, start: start )
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
          date = parse_matchdata( m, start: start )
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


    def parse_matchdata( m, start: )
      # convert regex match_data captures to hash
      # - note: cannont use match_data like a hash (e.g. raises exception if key/name not present/found)
      h = {}
      # - note: do NOT forget to turn name into symbol for lookup in new hash (name.to_sym)
      m.names.each { |name| h[name.to_sym] = m[name] }  # or use match_data.names.zip( match_data.captures )  - more cryptic but "elegant"??

      ## puts "[parse_date_time] match_data:"
      ## pp h
      logger.debug "   [parse_matchdata] hash: >#{h.inspect}<"

      if h[:month_name]
        ## todo/fix: issue error if no month names defined !!!
        if @month_names
         h[ :month ] = @month_names[ h[:month_name] ]
        else
          ## todo/fix: change to ArgumentError( "invalid date; ")
          puts "** !!! ERROR !!! - no month names defined for lang #{@lang}; cannot match:"
          pp m
          exit 1
        end
      end

      if h[:day_name]
        if @day_names
          ## note: use cwday  in ruby date to get days from 1-7 (Monday (1) to Sunday (7))
          ##            wday  gives you 0-6 (Sunday (0), Monday (1) to Saturday (6))
          h[ :cwday ] = @day_names[ h[:day_name ] ]
        else
          ## todo/fix: change to ArgumentError( "invalid date; ")
          puts "** !!! ERROR !!! - no day names defined for lang #{@lang}; cannot match:"
          pp m
          exit 1
        end
      end

      month   = h[:month]
      day     = h[:day]
      year    = h[:year]     || calc_year( month.to_i, day.to_i, start: start ).to_s

      date =  if h[:hours] || h[:minutes]   ## check time (hours or minutes) is present (otherwise asume just Date and NOT DateTime)
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

      ## check/assert cwday if present!!!!
      date
    end  # method parse

  ##################
  # helpers
  private
    def build_map( lines )
      ## build a lookup map that maps the word to the index (line no) plus 1 e.g.
      ##   note: index is a string too
      ##  {"January" => "1",  "Jan" => "1",
      ##   "February" => "2", "Feb" => "2",
      ##   "March" => "3",    "Mar" => "3",
      ##   "April" => "4",    "Apr" => "4",
      ##   "May" => "5",
      ##   "June" => "6",     "Jun" => "6", ...
      lines.each_with_index.reduce( {} ) do |h,(line,i)|
        line.each { |name| h[ name ] = (i+1).to_s }  ## note: start mapping with 1 (and NOT zero-based, that is, 0)
        h
      end
    end
  end # class DateParser




  class RsssfDateParser < DateParser

    MONTH_NAMES = DateFormats.parse_month( <<TXT )
Jan
Feb
March  Mar
April  Apr
May
June   Jun
July   Jul
Aug
Sept   Sep
Oct
Nov
Dec
TXT

    MONTH_EN = DateFormats.build_names( MONTH_NAMES )    ## re helper e.g. Jan|Feb|March|Mar|...

    ## e.g.
    ##  [Jun 7]  or [Aug 12] etc.  - not MUST include brackets e.g. []
    ##
    ##  check add \b at the beginning and end - why?? why not?? working??
    EN__MONTH_DD__DATE_RE = /\[
                     (?<month_name>#{MONTH_EN})
                        \s
                     (?<day>\d{1,2})
                       \]/x

    def initialize
      super( lang: 'en',
             formats: [[EN__MONTH_DD__DATE_RE, '[EN_MONTH_DD]']],
             month_names: MONTH_NAMES
           )
    end
  end  ## class RsssfDateParser

end # module DateFormats
