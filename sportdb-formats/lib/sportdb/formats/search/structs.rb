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
   def self.find_by( code: nil, name: nil )
        _search.find_by( code: code, name: name )
   end

   def self.find( q )   ## find by code (first) or name (second)
       _search.find( q )
   end

   def self.parse_heading( line )
      ## fix - move parse code here from search - why? why not?
      _search.parse( line )
   end

   ## add alternate names/aliases
   class << self
    alias_method :[],      :find    ### keep shortcut - why? why not?
    alias_method :heading, :parse_heading
   end


# open question - what name to use build or  parse_line or ?
#                              or   parse_recs for CountryReader?
#          remove CountryReader helper methods - why? why not?
#   use parse_heading/heading for now !!!
#
#   def self.parse( line )  or build( line ) ??
#      SportDb::Import.world.countries.parse( line )
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
    def self.match_by( name: nil, code: nil,
                        country: nil )
       _search.match_by( name: name, code: code,
                         country: country )
    end
    def self.match( q ) _search.match( q ); end

    def self.find!( q ) _search.find!( q ); end
    def self.find( q )  _search_find( q ); end
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
