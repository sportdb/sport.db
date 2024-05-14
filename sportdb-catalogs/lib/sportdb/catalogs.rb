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



###
# compat with old catalog class/api
module SportDb
module Import       
      class Catalog
        def countries()      CatalogDb::Metal::Country; end
        def national_teams() CatalogDb::Metal::NationalTeam; end
        def leagues()        CatalogDb::Metal::League; end
        def clubs()          CatalogDb::Metal::Club; end
      end # class Catalog
end # module Import
end # module SportDb
    
    

puts SportDb::Module::Catalogs.banner   # say hello
