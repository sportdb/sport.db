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


## note: json always returns hash tables with string keys (not symbols),
##        thus, always stringify keys before comparing!!!!
class Object
  def deep_stringify_keys
    if self.is_a? Hash
      self.reduce({}) {|memo,(k,v)| memo[k.to_s] = v.deep_stringify_keys; memo }
    elsif self.is_a? Array
      self.reduce([]) {|memo,v    | memo           << v.deep_stringify_keys; memo }
    else
      self
    end
  end
end


def read_blocks( path )
  txt = File.open( path, 'r:utf-8' ).read

  blocks = []
  buf    = String.new('')
  txt.each_line do |line|
    if line =~ /^[ ]*
              ([>]{3,} |
               [<]{3,})
              [ ]*
             $/x   ## three or more markers
      blocks << buf
      buf = String.new('')
    else
      buf << line
    end
  end
  blocks << buf
  blocks
end


def read_test( path )
  blocks = read_blocks( "../football.txt/#{path}" )

  if blocks.size == 2
    [blocks[0], JSON.parse( blocks[1] )]
  elsif blocks.size == 3
    ## note: returned in different order
    ##         optional option block that comes first returned last!
    ## todo/fix: convert options from YAML!!!!! with symbolize keys!!!
    [blocks[1], JSON.parse( blocks[2] ), blocks[0]]
  else
    puts "!! ERROR: expected two or three text blocks in >#{path}<; got #{blocks.size}"
    exit 1
  end
end

