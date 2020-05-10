# encoding: utf-8


class Fifa
## built-in countries for (quick starter) auto-add

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

      ## add codes lookups - key, fifa, ...
      if @countries[ rec.fifa ]
        puts "** !!! ERROR !!! country (fifa) code  >#{rec.fifa}< already exits!!"
        exit 1
      else
        @countries[ rec.fifa ] = rec
      end
    end
  end # method add
end   # class CountryIndex

end   # class Fifa
