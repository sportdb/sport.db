#################
#  to run use:
#    $ ruby sandbox/hello.rb


$LOAD_PATH.unshift( './lib' )
require 'football/timezones'


puts "cet:"
pp CET.now
pp CET.today
d = CET.strptime( '2024-1-1', '%Y-%m-%d' )
pp d
pp d.utc
d = CET.strptime( '2024-8-1 15:30', '%Y-%m-%d %H:%M' )   ## (cest) summer time
pp d
pp d.dst?
pp d.utc

puts "utc:"
pp UTC.now
pp UTC.today
d = UTC.strptime( '2024-1-1', '%Y-%m-%d' )
pp d
pp d.utc
d = UTC.strptime( '2024-8-1 15:30', '%Y-%m-%d %H:%M' )
pp d
pp d.utc


zone = find_zone!( league: 'eng.1', season: '2024/25' )
pp zone

zone = find_zone!( league: 'at.cup', season: '2024/25' )
pp zone


puts "bye"

__END__

cet:
2024-09-11 10:24:46.6440531 +0200
#<Date: 2024-09-11 ((2460565j,0s,0n),+0s,2299161j)>
2024-01-01 00:00:00 +0100
2023-12-31 23:00:00 UTC
2024-08-01 15:30:00 +0200
2024-08-01 13:30:00 UTC

utc:
2024-09-11 08:24:46.6647069 UTC
#<Date: 2024-09-11 ((2460565j,0s,0n),+0s,2299161j)>
2024-01-01 00:00:00 UTC
2024-01-01 00:00:00 UTC
2024-08-01 15:30:00 UTC
2024-08-01 15:30:00 UTC

#<UTC::Timezone:0x0000018091206a80 @zone=#<TZInfo::DataTimezone: Europe/London>>
#<UTC::Timezone:0x0000018090cab680 @zone=#<TZInfo::DataTimezone: Europe/Vienna>>


