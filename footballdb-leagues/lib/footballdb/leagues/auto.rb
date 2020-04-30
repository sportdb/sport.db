## our own code (without "top-level" shortcuts e.g. "modular version")
require 'footballdb/leagues'


###
#  add convenience top-level shortcuts / aliases

module SportDb
  module Import

  class Catalog
    def build_country_index()  CountryIndex.new( Fifa.countries ); end
    def build_league_index()   FootballDb::Import.build_league_index; end

    def countries() @countries ||= build_country_index; end
    def leagues()   @leagues   ||= build_league_index; end
  end

  configure do |config|
     config.catalog = Catalog.new
  end

  end # module Import
end # module SportDb


### add top-level (global) convenience alias
League = SportDb::Import.catalog.leagues


