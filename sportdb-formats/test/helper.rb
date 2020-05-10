## note: use the local version of gems
$LOAD_PATH.unshift( File.expand_path( '../date-formats/lib' ))


## minitest setup
require 'minitest/autorun'


## our own code
require 'sportdb/formats'



module SportDb
  module Import

class TestCatalog
  def build_country_index
    recs = CountryReader.read( "#{Test.data_dir}/world/countries.txt" )
    index = CountryIndex.new( recs )
    index
  end

  def build_league_index
    recs = SportDb::Import::LeagueReader.parse( <<TXT )
  = England =
  1       English Premier League
            | ENG PL | England Premier League | Premier League
  2       English Championship
            | ENG CS | England Championship | Championship
  3       English League One
            | England League One | League One
  4       English League Two
  5       English National League

  cup      EFL Cup
            | League Cup | Football League Cup
            | ENG LC | England Liga Cup

  = Scotland =
  1       Scottish Premiership
  2       Scottish Championship
  3       Scottish League One
  4       Scottish League Two
TXT

    leagues = SportDb::Import::LeagueIndex.new
    leagues.add( recs )
    leagues
  end

  def build_club_index
    recs = ClubReader.parse( <<TXT )
= England

Chelsea FC
Arsenal FC
Tottenham Hotspur
West Ham United
Crystal Palace
Manchester United
Manchester City
TXT

    index = ClubIndex.new
    index.add( recs )
    index
  end


  def countries() @countries ||= build_country_index; end
  def leagues()   @leagues   ||= build_league_index; end
  def clubs()     @clubs     ||= build_club_index; end
end

configure do |config|
  config.catalog = TestCatalog.new
end

end  # module Import
end  # module SportDb



################
## helper

def parse_auto_conf( txt, lang: 'en', start: nil )
  start = start ? start : Date.new( 2017, 7, 1 )

  SportDb::Import.config.lang = lang

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


def parse_json( str )
   ## note: allow empty string; fall back to empty hash
  if str.strip.empty?
    {}
  else
    JSON.parse( str )
  end
end

def read_test( path )
  blocks = read_blocks( "../football.txt/#{path}" )

  if blocks.size == 2
    [blocks[0], parse_json( blocks[1] )]
  elsif blocks.size == 3
    ## note: returned in different order
    ##         optional option block that comes first returned last!
    [blocks[1], parse_json( blocks[2] ), blocks[0]]
  else
    puts "!! ERROR: expected two or three text blocks in >#{path}<; got #{blocks.size}"
    exit 1
  end
end
