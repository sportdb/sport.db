## note: use the local version of sportdb gems
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-countries/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-leagues/lib' ))


## minitest setup
require 'minitest/autorun'


## our own code
require 'sportdb/clubs'



module SportDb
  module Import

class TestCatalog
  def build_country_index
    recs = CountryReader.read( "#{Test.data_dir}/world/countries.txt" )
    index = CountryIndex.new( recs )
    index
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
  def clubs()     @clubs     ||= build_club_index; end
end

def self.catalog() @catalog ||= TestCatalog.new;  end

end  # module Import
end  # module SportDb

