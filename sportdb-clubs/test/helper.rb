## $:.unshift(File.dirname(__FILE__))

## minitest setup

require 'minitest/autorun'


## our own code

require 'sportdb/clubs'




class Configuration
  def initialize
    ## fix/todo: use (shared)  test data / world / countries.txt !!! - why? why not?
    recs      = SportDb::Import::CountryReader.read( "#{SportDb::Countries.test_data_dir}/countries.txt" )
    @countries = SportDb::Import::CountryIndex.new( recs )
  end

  def countries() @countries; end
end

config = Configuration.new
SportDb::Import::ClubReader.config = config
SportDb::Import::ClubIndex.config  = config
