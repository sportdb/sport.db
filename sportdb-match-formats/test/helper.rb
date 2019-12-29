## $:.unshift(File.dirname(__FILE__))

## minitest setup
require 'minitest/autorun'


## our own code
require 'sportdb/match-formats'


################
## helper

def parse_auto_conf( txt, lang: 'en' )
  lines = txt.split( /\n+/ )    # note: removes/strips empty lines
  pp lines

  start = Date.new( 2017, 7, 1 )

  DateFormats.lang  = lang  # e.g. 'en'
  SportDb.lang.lang = lang

  parser = SportDb::AutoConfParser.new( lines, start )
  clubs, rounds = parser.parse
  pp rounds
  pp clubs
  [clubs, rounds]
end
