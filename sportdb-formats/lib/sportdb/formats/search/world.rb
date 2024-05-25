###
#  world search service api for countries and more
#
# core api is:
# -  world.countries.find_by_code
# -                 .find_by_name


class WorldSearch    

class CountrySearch
  def initialize( service ) @service = service; end
  
    ###################
    ## core required delegates  - use delegate generator - why? why not?
    def find_by_code( code ) @service.find_by_code( code ); end
    def find_by_name( name ) @service.find_by_name( name ); end


    ###############
    ### more deriv support functions / helpers
    def find( q )
       country = find_by_code( q )
       country = find_by_name( q )  if country.nil?     ## try lookup / find by (normalized) name
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
      ## check for trailing country code e.g. (at), (eng), etc.
      if value =~ /[ ]+\((?<code>[a-z]{1,4})\)$/  ## e.g. Austria (at)
        code =  $~[:code]
        name = value[0...(value.size-code.size-2)].strip  ## note: add -2 for brackets
        candidates = [ find_by_code( code ), find_by_name( name ) ]
        if candidates[0].nil?
          puts "** !!! ERROR !!! country - unknown code >#{code}< in line: #{line}"
          pp line
          exit 1
        end
        if candidates[1].nil?
          puts "** !!! ERROR !!! country - unknown name >#{code}< in line: #{line}"
          pp line
          exit 1
        end
        if candidates[0] != candidates[1]
          puts "** !!! ERROR !!! country - name and code do NOT match the same country:"
          pp line
          pp candidates
          exit 1
        end
        if country && country != candidates[0]
          puts "** !!! ERROR !!! country - names do NOT match the same country:"
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
          puts "** !!! ERROR !!! country - unknown name or code >#{value}< in line: #{line}"
          pp line
          exit 1
        end
        if country && country != candidate
          puts "** !!! ERROR !!! country - names do NOT match the same country:"
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


    def initialize( countries: )
        ## change service to country_service or such - why? why not?
        ##  add city_service and such later
        @countries = CountrySearch.new( countries )
    end

    ####
    #  note: for now setup only for countries
    def countries() @countries; end
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


