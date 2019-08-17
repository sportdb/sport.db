# encoding: utf-8


## 3rd party gems
require 'sportdb/countries'


###
# our own code
require 'fifa/version' # let version always go first
require 'fifa/countries'


class Fifa
  def self.countries() country_index.countries; end   ## return all country (struct-like) records
  def self.[]( key )   country_index[ key ]; end

private
  def self.country_index
    @country_index ||= build_country_index
    @country_index
  end

  def self.build_country_index
    recs = SportDb::Import::CountryReader.read( "#{Fifa.data_dir}/countries.txt" )
    CountryIndex.new( recs )
  end
end # class Fifa


## add a convenience upcase alias
FIFA = Fifa



puts Fifa.banner   # say hello
