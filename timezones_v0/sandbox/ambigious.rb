## check for ambigious times (CET)

$LOAD_PATH.unshift( './lib' )
require 'football/timezones'


# ambigous time
#    2024-10-27 02:00-02:59

#
#  Since 1996, European Summer Time has been observed
#  between 01:00 UTC (02:00 CET and 03:00 CEST)
#   on the last Sunday of March,
#   and 01:00 UTC on the last Sunday of October;
#   previously the rules were not uniform across the European Union.


str = '2024-10-27 02:00'
str = '2024-10-27 01:59'
format = '%Y-%m-%d %H:%M'

puts
pp cet = CET.strptime( '2024-10-27 01:59', format )
pp cet.utc

puts
pp cet = CET.strptime( '2024-10-27 02:00', format )
pp cet.utc

puts
pp CET.strptime( '2024-10-27 02:30', format )

puts
pp cet = CET.strptime( '2024-10-27 02:59', format )
pp cet.utc

puts
pp cet = CET.strptime( '2024-10-27 03:00', format )
pp cet.utc


## 2023
puts
pp cet = CET.strptime( '2023-10-29 01:59', format )
pp cet.utc
puts
pp cet = CET.strptime( '2023-10-29 02:00', format )
pp cet.utc
puts
pp cet = CET.strptime( '2023-10-29 02:30', format )
pp cet.utc
puts
pp cet = CET.strptime( '2023-10-29 03:00', format )
pp cet.utc



puts "bye"