# encoding: utf-8

module SportDb
  module Import

class Configuration

## built-in countries for (quick starter) auto-add

##
#  note: use our own (internal) country struct for now - why? why not?
#    - check that shape/structure/fields/attributes match
#      the Country struct in sportdb-text (in SportDb::Struct::Country)
##       and the ActiveRecord model !!!!
class Country
  ## note: is read-only/immutable for now - why? why not?
  ##          add cities (array/list) - why? why not?
  attr_reader :key, :name, :fifa
  def initialize( key, name, fifa )
    @key, @name, @fifa = key, name, fifa
  end
end  # class Country


class CountryIndex

  def initialize( recs )
    @countries         = []
    @countries_by_code = {}

    add( recs )
  end

  def add( recs )
    ###########################################
    ## auto-fill countries
    ## pp recs
    recs.each do |rec|
      ## rec e.g. { key:'af', fifa:'AFG', name:'Afghanistan'}

      key  = rec[:key]
      ## note: remove territory of marker e.g. (UK), (US), etc. from name
      ##    e.g. England (UK)     => England
      ##         Puerto Rico (US) => Puerto Rico
      name = rec[:name].sub( /\([A-Z]{2}\)/, '' ).strip
      fifa = rec[:fifa]

      country = Country.new( key, name, fifa )
      @countries << country

      ## add codes lookups - key, fifa, ...
      if @countries_by_code[ country.key ]
        puts "** !! ERROR !! country code (key) >#{country.key}< already exits!!"
        exit 1
      else
        @countries_by_code[ country.key ] = country
      end

      ## add fifa code (only) if different from key
      if country.key != country.fifa.downcase
        if @countries_by_code[ country.fifa.downcase ]
          puts "** !! ERROR !! country code (fifa) >#{country.fifa.downcase}< already exits!!"
          exit 1
        else
          @countries_by_code[ country.fifa.downcase ] = country
        end
      end
    end
  end # method initialize

  def []( key )
    key = key.to_s.downcase   ## allow symbols (and always downcase e.g. AUT to aut etc.)
    @countries_by_code[ key ]
  end
end # class CountryIndex


   ## todo/check:  rename to country_mappings/index - why? why not?
   ##    or countries_by_code or countries_by_key
  def countries
    @countries ||= build_country_index
    @countries
  end

  def build_country_index    ## todo/check: rename to setup_country_index or read_country_index - why? why not?
    recs = read_csv( "#{SportDb::Boot.data_dir}/world/countries.txt" )
    CountryIndex.new( recs )
  end

end   # class Configuration
end   # module Import
end   # module SportDb
