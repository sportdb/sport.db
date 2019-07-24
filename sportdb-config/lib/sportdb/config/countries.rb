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


   ## todo/check:  rename to country_mappings - why? why not?
   ##    or countries_by_code or countries_by_key
  def countries
    ## note: convertcountry data to "proper" struct
    @countries ||= COUNTRIES.each.reduce({}) do |h,(key,value)|
      ## note: convert key (e.g. :eng to string e.g. 'eng')
      h[key] = Country.new( key.to_s, value[0], value[1] )
      h
    end
    @countries
  end

end   # class Configuration
end   # module Import
end   # module SportDb
