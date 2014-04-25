# encoding: utf-8

module SportDb

class DateFinder

  include LogUtils::Logging

  # todo: make more generic for reuse
  MONTH_EN = 'Jan|Feb|March|Mar|April|Apr|May|June|Jun|July|Jul|Aug|Sept|Sep|Oct|Nov|Dec'
  MONTH_EN_TO_MM = {
        'Jan' => '1',
        'Feb' => '2',
        'Mar' => '3', 'March' => '3',
        'Apr' => '4', 'April' => '4',
        'May' => '5',
        'Jun' => '6', 'June' => '6',
        'Jul' => '7', 'July' => '7',
        'Aug' => '8',
        'Sep' => '9', 'Sept' => '9',
        'Oct' => '10',
        'Nov' => '11',
        'Dec' => '12' }

  MONTH_ES = 'Enero|Ene|Feb|Marzo|Mar|Abril|Abr|Mayo|May|Junio|Jun|Julio|Jul|Agosto|Ago|Sept|Set|Sep|Oct|Nov|Dic'
  MONTH_ES_TO_MM  = {
        'Ene' => '1', 'Enero' => '1',
        'Feb' => '2',
        'Mar' => '3', 'Marzo' => '3',
        'Abr' => '4', 'Abril' => '4',
        'May' => '5', 'Mayo' => '5',
        'Jun' => '6', 'Junio' => '6',
        'Jul' => '7', 'Julio' => '7',
        'Ago' => '8', 'Agosto' => '8',
        'Sep' => '9', 'Set' => '9', 'Sept' => '9',
        'Oct' => '10',
        'Nov' => '11',
        'Dic' => '12' }

  # todo/fix - add de and es too!!
  # note: in Austria - Jänner - in Deutschland Januar allow both ??
  # MONTH_DE = 'J[aä]n|Feb|Mär|Apr|Mai|Jun|Jul|Aug|Sep|Okt|Nov|Dez'


  # e.g. 2012-09-14 20:30   => YYYY-MM-DD HH:MM
  #  nb: allow 2012-9-3 7:30 e.g. no leading zero required
  # regex_db
  DB__DATE_TIME_REGEX = /\b
                 (?<year>\d{4})
                   -
                 (?<month>\d{1,2})
                   -
                 (?<day>\d{1,2})
                  \s+
                 (?<hours>\d{1,2})
                   :
                 (?<minutes>\d{2})
                  \b/x

  # e.g. 2012-09-14  w/ implied hours (set to 12:00)
  #  nb: allow 2012-9-3 e.g. no leading zero required
  # regex_db2
  DB__DATE_REGEX = /\b
                    (?<year>\d{4})
                       -
                    (?<month>\d{1,2})
                       -
                    (?<day>\d{1,2})
                     \b/x

  # e.g. 14.09.2012 20:30   => DD.MM.YYYY HH:MM
  #  nb: allow 2.3.2012 e.g. no leading zero required
  #  nb: allow hour as 20.30
  # regex_de
  DD_MM_YYYY__DATE_TIME_REGEX = /\b
                          (?<day>\d{1,2})
                            \.
                          (?<month>\d{1,2})
                            \.
                          (?<year>\d{4})
                            \s+
                          (?<hours>\d{1,2})
                            [:.]
                          (?<minutes>\d{2})
                            \b/x

  # e.g. 14.09. 20:30  => DD.MM. HH:MM
  #  nb: allow 2.3.2012 e.g. no leading zero required
  #  nb: allow hour as 20.30  or 3.30 instead of 03.30
  # regex_de2
  DD_MM__DATE_TIME_REGEX = /\b
                        (?<day>\d{1,2})
                           \.
                        (?<month>\d{1,2})
                           \.
                           \s+
                        (?<hours>\d{1,2})
                           [:.]
                        (?<minutes>\d{2})
                          \b/x

  # e.g. 14.09.2012  => DD.MM.YYYY w/ implied hours (set to 12:00)
  # regex_de3
  DD_MM_YYYY__DATE_REGEX = /\b
                    (?<day>\d{1,2})
                      \.
                    (?<month>\d{1,2})
                      \.
                    (?<year>\d{4})
                      \b/x

  # e.g. 14.09.  => DD.MM. w/ implied year and implied hours (set to 12:00)
  #  note: allow end delimiter ] e.g. [Sa 12.01.] or end-of-string ($) too
  #  note: we use a lookahead for last part e.g. (?:\s+|$|[\]]) - do NOT cosume
  # regex_de4
  DD_MM__DATE_REGEX = /\b
                     (?<day>\d{1,2})
                        \.
                     (?<month>\d{1,2})
                        \.
                     (?=\s+|$|[\]])/x  ## note: allow end-of-string/line too


  # e.g. 12 May 2013 14:00  => D|DD.MMM.YYYY H|HH:MM
  EN__DD_MONTH_YYYY__DATE_TIME_REGEX = /\b
                (?<day>\d{1,2})
                   \s
                (?<month_en>#{MONTH_EN})
                   \s
                (?<year>\d{4})
                   \s+
                (?<hours>\d{1,2})
                  :
                (?<minutes>\d{2})
                  \b/x

  # e.g.  Jun/12 14:00  w/ implied year H|HH:MM
  EN__MONTH_DD__DATE_TIME_REGEX = /\b
                   (?<month_en>#{MONTH_EN})
                     \/
                   (?<day>\d{1,2})
                     \s+
                   (?<hours>\d{1,2})
                     :
                   (?<minutes>\d{2})
                     \b/x

  # e.g. Jun/12 2013  w/ implied hours (set to 12:00)
  EN__MONTH_DD_YYYY__DATE_REGEX = /\b
                (?<month_en>#{MONTH_EN})
                   \/
                (?<day>\d{1,2})
                   \s
                (?<year>\d{4})
                  \b/x

  # e.g.  Jun/12  w/ implied year and implied hours (set to 12:00)
  EN__MONTH_DD__DATE_REGEX = /\b
                   (?<month_en>#{MONTH_EN})
                      \/
                   (?<day>\d{1,2})
                     \b/x


  # e.g.  12 Ene  w/ implied year and implied hours (set to 12:00)
  ES__DD_MONTH__DATE_REGEX = /\b
                   (?<day>\d{1,2})
                     \s
                   (?<month_es>#{MONTH_ES})
                     \b/x



  # map table - 1) tag, 2) regex - note: order matters; first come-first matched/served
  FORMATS = [
    [ '[YYYY_MM_DD_hh_mm]',        DB__DATE_TIME_REGEX         ],
    [ '[YYYY_MM_DD]',              DB__DATE_REGEX              ],
    [ '[DD_MM_YYYY_hh_mm]',        DD_MM_YYYY__DATE_TIME_REGEX ],
    [ '[DD_MM_hh_mm]',             DD_MM__DATE_TIME_REGEX ],
    [ '[DD_MM_YYYY]',              DD_MM_YYYY__DATE_REGEX ],
    [ '[DD_MM]',                   DD_MM__DATE_REGEX ],
    [ '[EN_DD_MONTH_YYYY_hh_mm]',  EN__DD_MONTH_YYYY__DATE_TIME_REGEX ],
    [ '[EN_MONTH_DD_hh_mm]',       EN__MONTH_DD__DATE_TIME_REGEX ],
    [ '[EN_MONTH_DD_YYYY]',        EN__MONTH_DD_YYYY__DATE_REGEX ],
    [ '[EN_MONTH_DD]',             EN__MONTH_DD__DATE_REGEX ],
    [ '[ES_DD_MONTH]',             ES__DD_MONTH__DATE_REGEX ]
  ]



  def initialize
    # nothing here for now
  end

  def find!( line, opts={} )
    # fix: use more lookahead for all required trailing spaces!!!!!
    # fix: use <name capturing group> for month,day,year etc.!!!

    #
    # fix: !!!!
    #   date in [] will become [[DATE.DE4]] - when getting removed will keep ]!!!!
    #   fix: change regex to \[[A-Z0-9.]\]  !!!!!!  plus add unit test too!!!
    #
 
    md = nil
    FORMATS.each do |format|
      tag     = format[0]
      pattern = format[1]
      md=pattern.match( line )
      if md
        date = parse_date_time( md, opts )
        ## fix: use md[0] e.g. match for sub! instead of using regex again - why? why not???
        ## fix: use md.begin(0), md.end(0)
        line.sub!( md[0], tag )
        ## todo/fix: make sure match data will not get changed (e.g. using sub! before parse_date_time)
        return date
      end
      # no match; continue; try next pattern
    end

    return nil  # no match found
  end

private
  def calc_year( month, day, opts )
    start_at = opts[:start_at]

    logger.debug "   [calc_year] ????-#{month}-#{day} -- start_at: #{start_at}"

    if month >= start_at.month
      # assume same year as start_at event (e.g. 2013 for 2013/14 season)
      start_at.year
    else
      # assume year+1 as start_at event (e.g. 2014 for 2013/14 season)
      start_at.year+1
    end
  end

  def parse_date_time( match_data, opts={} )
    
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

    month   = h[:month]
    day     = h[:day]
    year    = h[:year]     || calc_year( month.to_i, day.to_i, opts ).to_s

    hours   = h[:hours]    || '12'   # default to 12:00 for HH:MM (hours:minutes)
    minutes = h[:minutes]  || '00'

    value = '%d-%02d-%02d %02d:%02d' % [year.to_i, month.to_i, day.to_i, hours.to_i, minutes.to_i]
    logger.debug "   date: >#{value}<"

    DateTime.strptime( value, '%Y-%m-%d %H:%M' )
  end


end # class DateFinder


end # module SportDb
