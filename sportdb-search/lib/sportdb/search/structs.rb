###
#  note - extend all structs for with search api
#
#  todo - add more helpers!!!!
#
#
#  todo - fix - move all non-core search functionality/machinery
#                  over here - why? why not?



module Sports
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
    def self.match( q, country: nil )
        _search.match( q, country: country )
    end

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
       _search.build_mods( mods )
    end
  end # class Club


  class Team
    def self._search
        SportDb::Import.catalog.teams
    end

    ## todo/check: rename to/use map_by! for array version - why? why not?
    def self.find_by!( name:, league:, mods: nil )
        _search.find_by!( name: name,
                          league: league,
                          mods: mods )
    end
  end # class Team


  class EventInfo
    def self._search
        SportDb::Import.catalog.events
    end

    def self.find_by( league:, season: )
        _search.find_by( league: league,
                         season: season )
    end
  end # class EventInfo



  class Ground
    def self._search
        SportDb::Import.catalog.grounds
    end

    def self.match_by( name:, country: nil, city: nil )
      _search.match_by( name:    name,
                        country: country,
                        city:    city )
    end
  end # class Ground
end   # module Sports
