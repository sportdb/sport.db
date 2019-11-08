# encoding: utf-8

module DateFormats


class DateFinderBase

private
  def calc_year( month, day, start: )  ## note: start required param for now on!!!

    logger.debug "   [calc_year] ????-#{month}-#{day} -- start: #{start}"

    if month >= start.month
      # assume same year as start_at event (e.g. 2013 for 2013/14 season)
      start.year
    else
      # assume year+1 as start_at event (e.g. 2014 for 2013/14 season)
      start.year+1
    end
  end


  def parse_date_time( match_data, start: )

    # convert regex match_data captures to hash
    # - note: cannont use match_data like a hash (e.g. raises exception if key/name not present/found)
    h = {}
    # - note: do NOT forget to turn name into symbol for lookup in new hash (name.to_sym)
    match_data.names.each { |name| h[name.to_sym] = match_data[name] }  # or use match_data.names.zip( match_data.captures )  - more cryptic but "elegant"??

    ## puts "[parse_date_time] match_data:"
    ## pp h
    logger.debug "   [parse_date_time] hash: >#{h.inspect}<"

    h[ :month ] = MONTH_EN_TO_MM[ h[:month_en] ]  if h[:month_en]
    h[ :month ] = MONTH_ES_TO_MM[ h[:month_es] ]  if h[:month_es]
    h[ :month ] = MONTH_FR_TO_MM[ h[:month_fr] ]  if h[:month_fr]
    h[ :month ] = MONTH_DE_TO_MM[ h[:month_de] ]  if h[:month_de]
    h[ :month ] = MONTH_IT_TO_MM[ h[:month_it] ]  if h[:month_it]
    h[ :month ] = MONTH_PT_TO_MM[ h[:month_pt] ]  if h[:month_pt]

    month   = h[:month]
    day     = h[:day]
    year    = h[:year]     || calc_year( month.to_i, day.to_i, start: start ).to_s

    hours   = h[:hours]    || '00'   # default to 00:00 for HH:MM (hours:minutes)
    minutes = h[:minutes]  || '00'

    value = '%d-%02d-%02d %02d:%02d' % [year.to_i, month.to_i, day.to_i, hours.to_i, minutes.to_i]
    logger.debug "   date: >#{value}<"

    DateTime.strptime( value, '%Y-%m-%d %H:%M' )
  end

end  # class DateFinderBase



class DateFinder < DateFinderBase

  include LogUtils::Logging


  def self.lang()        @@lang ||= 'en';  end    ## defaults to english (en)
  def self.lang=(value)  @@lang   = value; end


  def initialize( lang: self.class.lang )
    @lang    = lang.to_s
    ## fallback to english if lang not available
    ##  todo/fix: add/issue warning!!!!!
    @formats = FORMATS[ @lang ] || FORMATS['en']
  end

  def find!( line, start_at: )     ## todo/fix: change start_at to start only!!!
    # fix: use more lookahead for all required trailing spaces!!!!!
    # fix: use <name capturing group> for month,day,year etc.!!!

    #
    # fix: !!!!
    #   date in [] will become [[DATE.DE4]] - when getting removed will keep ]!!!!
    #   fix: change regex to \[[A-Z0-9.]\]  !!!!!!  plus add unit test too!!!
    #

    m = nil
    @formats.each do |format|
      tag     = format[0]
      pattern = format[1]
      m=pattern.match( line )
      if m
        date = parse_date_time( m, start: start_at )
        ## fix: use md[0] e.g. match for sub! instead of using regex again - why? why not???
        ## fix: use md.begin(0), md.end(0)
        line.sub!( m[0], tag )
        ## todo/fix: make sure match data will not get changed (e.g. using sub! before parse_date_time)
        return date
      end
      # no match; continue; try next pattern
    end

    return nil  # no match found
  end

end # class DateFinder



class RsssfDateFinder < DateFinderBase

  include LogUtils::Logging

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

  def find!( line, start_at: )     ## todo/fix: change start_at to start only!!!
    # fix: use more lookahead for all required trailing spaces!!!!!
    # fix: use <name capturing group> for month,day,year etc.!!!

    tag     = '[EN_MONTH_DD]'
    pattern = EN__MONTH_DD__DATE_RE
    m = pattern.match( line )
    if m
      date = parse_date_time( m, start: start_at )
      ## fix: use md[0] e.g. match for sub! instead of using regex again - why? why not???
      ## fix: use md.begin(0), md.end(0)
      line.sub!( m[0], tag )
      ## todo/fix: make sure match data will not get changed (e.g. using sub! before parse_date_time)
      return date
    end
    return nil  # no match found
  end
end  ## class RsssfDateFinder

end # module DateFormats
