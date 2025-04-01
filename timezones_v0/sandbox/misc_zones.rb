###
#  test timezones

## note: use the  IANA tz database
##         see https://www.iana.org/time-zones
##
##  via ruby gem
##    https://tzinfo.github.io
##

##
## NOTE NOTE NOTE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## DateTime
## A subclass of Date that easily handles date, hour, minute, second, and offset.
##
## DateTime class is considered deprecated. Use Time class.
##
## DateTime does not consider any leap seconds,
##      does not track any summer time rules.
##
##  So when should you use DateTime in Ruby and
##   when should you use Time?
##  Almost certainly you'll want to use Time since your app is probably
##   dealing with current dates and times.
##  However, if you need to deal with dates and times in a historical context
##   you'll want to use DateTime to avoid making the same mistakes as UNESCO.
##  If you also have to deal with timezones then best of luck -
##   just bear in mind that you'll probably be dealing with local solar times,
##   since it wasn't until the 19th century that the introduction
##   of the railways necessitated the need for Standard Time
##  and eventually timezones.
##
##   see https://docs.ruby-lang.org/en/master/DateTime.html




require 'cocos'


## pp Time::VERSION


## check utc datetime (via time)

puts "utc:"
utc = Time.utc( 2024, 1, 1, 0, 0 )
pp utc
puts utc.inspect
pp utc.to_i
pp utc.utc_offset
pp utc.utc?
pp utc.zone
pp utc.dst?    ## should always be false
pp utc.utc
#=> 2024-01-01 00:00:00 UTC

puts
puts "local:"
## compare to "regular"
local  = Time.new( 2024, 1, 1, 0, 0 )
pp local
puts local.inspect
pp local.to_i
pp local.getutc       ## gets new time converted to
pp local.getutc.to_i  ## gets new time converted to
pp local.dst?    # daylight savings time?
pp local.utc_offset
pp local.utc?
pp local.zone
pp local.utc
#=> 2024-01-01 00:00:00 +0100
#=> 2023-12-31 23:00:00 UTC
#=> false

local  = Time.new( 2024, 8, 1, 0, 0 )   ## summer time in august (offset +2)!!!
pp local
pp local.utc_offset
pp local.to_i   ## epoch (since 1970)
pp local.dst?
pp local.utc   ## note - changes time in place!!!! (maybe only "attached" timezone??)
pp local.utc_offset
pp local.utc?
pp local.zone
pp local.to_i
pp local
#=> 2024-08-01 00:00:00 +0200
#=> true
#=> 2024-07-31 22:00:00 UTC
#=> 2024-07-31 22:00:00 UTC

## pp local.jd   ## julian day  (only available via date)
pp local.to_date.jd


####
## note 24:00 gets translated to 00:00 the NEXT day!!!!
pp Time.utc( 2024, 1, 1, 24, 0 )
#=> 2024-01-02 00:00:00 UTC   --02 (01+1d) !!!!
pp Time.utc( 2024, 1, 1, 23, 59 )

pp Time.utc( 2024, 1, 1,  0, 0 )
#=> 2024-01-01 00:00:00 UTC
pp Time.utc( 2024, 1, 2,  24, 0 )
##=> 2024-01-03 00:00:00 UTC   --- 03 (02+1d) !!!



####
#

date_str = "2024-08-01 08:00:00"
date =  Time.strptime( date_str, '%Y-%m-%d %H:%M:%S')
pp date
pp date.class.name
pp date.zone
#=> 2024-08-01 08:00:00 +0200
#=> "Time"
date =  DateTime.strptime( date_str, '%Y-%m-%d %H:%M:%S')
pp date
pp date.class.name
pp date.zone
pp date.offset   # note - returns rational number e.g. (0/1, 5/16 etc.)
#=> #<DateTime: 2024-08-01T08:00:00+00:00 ((2460524j,28800s,0n),+0s,2299161j)>
#=> "DateTime"

date =  Date.strptime( date_str, '%Y-%m-%d %H:%M:%S')
pp date
pp date.class.name

pp Date::ABBR_DAYNAMES
pp Date::DAYNAMES
pp Date::ABBR_MONTHNAMES
pp Date::MONTHNAMES



pp ENV['TZ']
pp Time.parse("2019/10/01 23:29:57")
pp Time.parse("2019/10/01 23:29:57" )
pp Time.strptime( "2019/10/01 23:29:57", "%Y/%m/%d", Time.now.utc )
pp Time.strptime( "2019/10/01 23:29:57", "%Y/%m/%d %H:%M:%S", Time.now.utc )
pp Time.now
pp Date.today
ENV['TZ'] = 'UTC'
pp ENV['TZ']
pp Time.parse("2019/10/01 23:29:57")
#=> 2019-10-01 23:29:57 +0000
pp Time.now
pp Date.today



puts "bye"
