## note: use the local version of gems
$LOAD_PATH.unshift( File.expand_path( '../date-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-langs/lib' ))


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
Tottenham Hotspur
West Ham United
Crystal Palace

### note add move entires for testing club name history
Manchester United FC
  | Manchester United
  | Newton Heath FC

Manchester City FC
  | Ardwick FC

Arsenal FC
  | The Arsenal FC
  | Woolwich Arsenal FC
  | Royal Arsenal FC

Gateshead FC
  | South Shields FC

Sheffield Wednesday
  | The Wednesday FC

Port Vale FC
  | Burslem Port Vale FC

Chesterfield FC
  | Chesterfield Town FC

Birmingham FC
  | Small Heath FC

Burton Swifts FC
Burton Wanderers FC
Burton United FC

Blackpool FC
South Shore FC

Glossop FC
  | Glossop North End FC

Walsall FC
  | Walsall Town Swifts FC


Newcastle West End FC
Newcastle East End FC
Newcastle United FC
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



