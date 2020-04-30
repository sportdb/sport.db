
## our own code (without "top-level" shortcuts e.g. "modular version")
require 'footballdb/clubs'


###
#  add convenience top-level shortcuts / aliases

module SportDb
  module Import

  class Catalog
    def build_country_index()  CountryIndex.new( Fifa.countries ); end
    def build_club_index()     FootballDb::Import.build_club_index; end

    def countries() @countries ||= build_country_index; end
    def clubs()     @clubs     ||= build_club_index; end
  end

  configure do |config|
    config.catalog = Catalog.new
  end

  end # module Import
end # module SportDb


### add top-level (global) convenience alias
Club = SportDb::Import.catalog.clubs
