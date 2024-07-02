###
#  note - extend all structs for with search api
#
#  todo - add more helpers!!!!
#
#
#  todo - fix - move all non-core search functionality/machinery
#                  over here - why? why not?



module Sports

class Country
    def self._search #### use service/api or such - why? why not?
        SportDb::Import.world.countries
    end
   def self.find_by( code: nil, 
                     name: nil )
      ## todo/fix upstream - change to find_by( code:, name:, ) too               
      if code && name.nil?
          _search.find_by_code( code )
      elsif name && code.nil?
          _search.find_by_name( name )
      else
        raise ArgumentError, "find_by - one (and only one arg) required - code: or name:"  
      end
   end 

   def self.find( q )   ## find by code (first) or name (second) 
       _search.find( q )
   end
   class << self
     alias_method :[], :find    ### keep shortcut - why? why not?
   end


# open questoin - what name to use build or  parse_line or ?
#                              or   parse_recs for CountryReader?
#          remove CountryReader helper methods - why? why not?   
#
#   def self.parse( line )  or build( line ) ??
#      SportDb::Import.world.countries.find( q )    
#   end
#
# !!!! note - conflict with 
#     def self.read( path )  CountryReader.read( path ); end
#     def self.parse( txt )  CountryReader.parse( txt ); end
#
end # class Country


###
## todo/fix - add find_by( code: ), find_by( name: ) 
##                   split - why? why not?


class League
    def self._search #### use service/api or such - why? why not?
        SportDb::Import.catalog.leagues
    end
    def self.match_by( name:, country: nil )
       _search.match_by( name: name,
                         country: country ) 
    end
    def self.match( name ) match_by( name: name ); end 
  
    def self.find!( name ) _search.find!( name ); end  
    def self.find( name )  _search_find( name ); end
end # class League
  

class NationalTeam
    def self._search #### use service/api or such - why? why not?
        SportDb::Import.catalog.national_teams
    end

    def self.find( q )   _search.find( q ); end
    def self.find!( q )  _search_find!( q ); end
end # class NationalTeam
  
  
class Club
    def self._search #### use service/api or such - why? why not?
        SportDb::Import.catalog.clubs
    end

    def self.match_by( name:, country: nil,
                         league:  nil,
                         mods:    nil )
        _search.match_by( name: name, country: country,
                          league: league, mods: mods )
    end
    def self.match( name ) match_by( name: name ); end
   
    def self.find( name )   _search.find_by( name: name ); end
    def self.find!( name )  _search.find_by!( name: name ); end
  
    def self.find_by!( name:, country: nil,
                              league:  nil )  
       _search.find_by!( name: name, country: country,
                                     league: league )
    end
    def self.find_by( name:, country: nil,
                             league:  nil )  
       _search.find_by( name: name, country: country,
                                    league: league )                      
    end
    
   def self.build_mods( mods )
       _search_build_mods( mods )
    end
  end # class Club
end   # module Sports
