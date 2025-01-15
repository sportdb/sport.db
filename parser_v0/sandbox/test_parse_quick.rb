####
#  to run use:
#    $ ruby sandbox/test_parse_quick.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'




line = "21.00  Astur CF                 -  EDF Logroño"
pp line

line2 =  "EdF Logroño"
pp line2

pp "EDF Logroño" == "EDF Logroño"
name1 = "EDF Logroño"
name2 = "EDF Logroño"

puts
pp name1.size
pp name1.bytes
pp name2.size
pp name2.bytes
#=> 12
#=> [69, 68, 70, 32, 76, 111, 103, 114, 111, 110, 204, 131, 111]
#=> 11
#=> [69, 68, 70, 32, 76, 111, 103, 114, 111, 195, 177, 111]

pp "ñ"
pp "ñ".size
pp "ñ".bytes
# "ñ"
# 2
# [110, 204, 131]

norm = "ñ".unicode_normalize   #:nfc
pp norm
pp norm.size
pp norm.bytes
# "ñ"
# 1
# [195, 177]

puts "bye"