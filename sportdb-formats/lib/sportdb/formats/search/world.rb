###
#  world search service api for countries and more
#
# core api is:
# -  world.countries.find_by_code
# -                 .find_by_name


class WorldSearch    

class CitySearch
  def initialize( service ) @service = service; end

  ###################
  ## core required delegates  - use delegate generator - why? why not?
  def match_by( name: )
    @service.match_by( name: name ) 
  end
end  # class CitySearch


class CountrySearch
  def initialize( service ) @service = service; end
  
    ###################
    ## core required delegates  - use delegate generator - why? why not?
    def find_by_code( code ) 
      puts "!! DEPRECATED - use CountrySearch#find_by( code: )"
      @service.find_by_code( code ) 
    end
    def find_by_name( name ) 
      puts "!! DEPRECATED - use CountrySearch#find_by( name: )"
      @service.find_by_name( name )
    end

    def find_by( code: nil, name: nil )
      ## todo/fix upstream - change to find_by( code:, name:, ) too               
      if code && name.nil?
        @service.find_by_code( code )
      elsif name && code.nil?
        @service.find_by_name( name )
      else
        raise ArgumentError, "CountrySearch#find_by - one (and only one arg) required - code: or name:"  
      end
    end


    ###############
    ### more deriv support functions / helpers
    def find( q )
       country = find_by( code: q )
       country = find_by( name: q )  if country.nil?     ## try lookup / find by (normalized) name
       country
    end
    alias_method :[], :find    ### keep shortcut - why? why not?
         
 ###
 ##   split/parse country line
 ##
 ##  split on bullet e.g.
 ##   split into name and code with regex - make code optional
 ##
 ##  Examples:
 ##    Österreich • Austria (at)
 ##    Österreich • Austria
 ##    Austria
 ##    Deutschland (de) • Germany
 ##
 ##   todo/check: support more formats - why? why not?
 ##       e.g.  Austria, AUT  (e.g. with comma - why? why not?)
 def parse( line )
   values = line.split( '•' )   ## use/support multi-lingual separator
   country = nil
   values.each do |value|
      value = value.strip
      ## check for trailing country code e.g. (at), (eng), etc
      ##   allow code 1 to 5 for now - northern cyprus(fifa) with 5 letters?.
      ##     add/allow  gb-eng, gb-wal (official iso2!!), in the future too - why? why not?
      if value =~ /[ ]+\((?<code>[A-Za-z]{1,5})\)$/  ## e.g. Austria (at)
        code =  $~[:code]
        name = value[0...(value.size-code.size-2)].strip  ## note: add -2 for brackets
        candidates = [ find_by( code: code ), find_by( name: name ) ]
        if candidates[0].nil?
          puts "** !!! ERROR Country.parse_heading - unknown code >#{code}< in line: #{line}"
          pp line
          exit 1
        end
        if candidates[1].nil?
          puts "** !!! ERROR Country.parse_heading - unknown name >#{code}< in line: #{line}"
          pp line
          exit 1
        end
        if candidates[0] != candidates[1]
          puts "** !!! ERROR Country.parse_heading - name and code do NOT match the same country:"
          pp line
          pp candidates
          exit 1
        end
        if country && country != candidates[0]
          puts "** !!! ERROR Country.parse_heading - names do NOT match the same country:"
          pp line
          pp country
          pp candidates
          exit 1
        end
        country = candidates[0]
      else
        ## just assume value is name or code
        candidate = find( value )
        if candidate.nil?
          puts "** !!! ERROR Country.parse_heading - unknown name or code >#{value}< in line: #{line}"
          pp line
          exit 1
        end
        if country && country != candidate
          puts "** !!! ERROR Country.parse_heading - names do NOT match the same country:"
          pp line
          pp country
          pp candidate
          exit 1
        end
        country = candidate
      end
   end
   country
 end # method parse
end  # class CountrySearch


    def initialize( countries:, cities: )
        ## change service to country_service or such - why? why not?
        ##  add city_service and such later
        @countries = CountrySearch.new( countries )
        @cities    = CitySearch.new( cities )
    end

    ####
    #  note: for now setup only for countries
    def countries() @countries;  end
    def cities()    @cities;  end
end  # class WorldSearch





class DummyCountrySearch
    def find_by_code( code ) 
        puts "[WARN] no world search configured; cannot find country by code"
        nil 
    end
    def find_by_name( name )
        puts "[WARN] no world search configured; cannot find country by name"
        nil
    end
end  # class DummyCountrySearch


