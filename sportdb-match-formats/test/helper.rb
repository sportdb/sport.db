## note: use the local version of sportdb gems
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-countries/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-leagues/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-clubs/lib' ))


## minitest setup
require 'minitest/autorun'


## our own code
require 'sportdb/match-formats'


################
## helper

def parse_auto_conf( txt, lang: 'en' )
  start = Date.new( 2017, 7, 1 )

  DateFormats.lang  = lang  # e.g. 'en'
  SportDb.lang.lang = lang

  parser = SportDb::AutoConfParser.new( txt, start )
  parser.parse
end

def parse_conf( txt )
  parser = SportDb::ConfParser.new( txt )
  parser.parse
end
