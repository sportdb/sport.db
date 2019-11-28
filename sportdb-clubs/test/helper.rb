## $:.unshift(File.dirname(__FILE__))

## minitest setup
require 'minitest/autorun'


## our own code
require 'sportdb/clubs'



class Configuration
  def build_country_index
    recs = SportDb::Import::CountryReader.read( "#{SportDb::Test.data_dir}/world/countries.txt" )
    index = SportDb::Import::CountryIndex.new( recs )
    index
  end

  def build_club_index
    recs = SportDb::Import::ClubReader.parse( <<TXT )
= England

Chelsea FC
Arsenal FC
Tottenham Hotspur
West Ham United
Crystal Palace
Manchester United
Manchester City
TXT

    index = SportDb::Import::ClubIndex.new
    index.add( recs )
    index
  end

  def countries() @countries ||= build_country_index; end
  def clubs()     @clubs     ||= build_club_index; end
end


## todo/fix:   move config to shared/central/all-in-one-place  SportDb::Import::Club.config - why? why not?
config = Configuration.new
SportDb::Import::ClubReader.config = config
SportDb::Import::ClubIndex.config  = config
SportDb::Import::WikiReader.config  = config
