# encoding: utf-8


class Fifa
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
    @countries = {}   ## countries by fifa code

    add( recs )
  end

  def countries  ## all country records
    @countries.values
  end

  def []( key )
    key = key.to_s.upcase   ## allow symbols (and always upcase e.g. aut to AUT etc.)
    @countries[ key ]
  end

private
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

      ## add codes lookups - key, fifa, ...
      if @countries[ country.fifa ]
        puts "** !!! ERROR !!! country (fifa) code  >#{country.fifa}< already exits!!"
        exit 1
      else
        @countries[ country.fifa ] = country
      end
    end
  end # method add
end   # class CountryIndex

end   # class Fifa
