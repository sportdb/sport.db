### our own sportdb libs / gems
###  try min. dependencies
require 'sportdb/structs'


###
# our own code
require_relative 'catalogs/version' # let version always go first



module SportDb
module Import

class Configuration
  ## note: add more configs (open class), see sportdb-formats for original config!!!

  ##
  ##  todo: allow configure of countries_dir like clubs_dir
  ##         "fallback" and use a default built-in world/countries.txt

  ####
  #  todo/check:  find a better way to configure club / team datasets - why? why not?
  attr_accessor   :clubs_dir
  ## def clubs_dir()      @clubs_dir; end   ### note: return nil if NOT set on purpose for now - why? why not?

  attr_accessor   :leagues_dir
  ## def leagues_dir()    @leagues_dir; end

  ## FIX!!! 
  ##   warning: method redefined; discarding old catalog 
  ##       check where defined first!!!!!
  def catalog()      @catalog ||= Catalog.new;  end
end # class Configuration
end   # module Import
end   # module SportDb





require 'sqlite3'

require_relative 'catalogs/base'       ## base record
require_relative 'catalogs/country'
require_relative 'catalogs/club'   
require_relative 'catalogs/national_team'
require_relative 'catalogs/league'



module CatalogDb
module Metal
class Event < Record
   def self.find_by( season:, league: ) 
      nil   ## always return nil for now; not found 
   end
end

######
### add virtual team table ( clubs + national teams)
##   note: no record base!!!!!
class Team
  ## note: "virtual" index lets you search clubs and/or national_teams (don't care)

  ## todo/check: rename to/use map_by! for array version - why? why not?
  def self.find_by!( name:, league:, mods: nil )
    if name.is_a?( Array )
      recs = []
      name.each do |q|
        recs << __find_by!( name: q, league: league, mods: mods )
      end
      recs
    else  ## assume single name
      __find_by!( name: name, league: league, mods: mods )
    end
  end


  def self.__find_by!( name:, league:, mods: nil )
    if mods && mods[ league.key ] && mods[ league.key ][ name ]
      mods[ league.key ][ name ]
    else
      if league.clubs?
        if league.intl?    ## todo/fix: add intl? to ActiveRecord league!!!
          Club.find!( name )
        else  ## assume clubs in domestic/national league tournament
          Club.find_by!( name: name, country: league.country )
        end
      else   ## assume national teams (not clubs)
        NationalTeam.find!( name )
      end
    end
  end # method __find_by!
end  # class Team
end # module Metal
end # module CatalogDb
  


###
# compat with old catalog class/api
module SportDb
module Import       
      class Catalog
        def countries()      CatalogDb::Metal::Country; end
        def leagues()        CatalogDb::Metal::League; end
        def national_teams() CatalogDb::Metal::NationalTeam; end
        def clubs()          CatalogDb::Metal::Club; end
        def teams()          CatalogDb::Metal::Team; end

        def events()         CatalogDb::Metal::Event; end
      end # class Catalog
end # module Import
end # module SportDb
    
    

puts SportDb::Module::Catalogs.banner   # say hello
