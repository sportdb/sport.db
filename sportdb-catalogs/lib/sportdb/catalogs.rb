### our own sportdb libs / gems
###  try min. dependencies  - change to structs only (NOT formats) - why? why not?
## require 'sportdb/structs'
require 'sportdb/formats'


require 'sqlite3'


###
# our own code
require_relative 'catalogs/version' # let version always go first

require_relative 'catalogs/base'       ## base record
require_relative 'catalogs/country'
require_relative 'catalogs/club'   
require_relative 'catalogs/national_team'
require_relative 'catalogs/league'
require_relative 'catalogs/event_info'
require_relative 'catalogs/ground'   



module SportDb
module Import

class Configuration
  ## note: add more configs (open class), see sportdb-structs for original config!!!

  ###   
  #  find a better name for setting - why? why not?
  #     how about catalogdb or ???
  attr_reader   :catalog_path 
  def catalog_path=(path)
      @catalog_path = path
      ######## 
      # reset database here to new path
      CatalogDb::Metal::Record.database = path

      ##  plus automagically set world search too (to use CatalogDb)
      self.world = WorldSearch.new( 
                          countries: CatalogDb::Metal::Country 
                        ) 

      @catalog_path
  end

  def catalog      
       @catalog ||= SportSearch.new( 
                           leagues:        CatalogDb::Metal::League,
                           national_teams: CatalogDb::Metal::NationalTeam,
                           clubs:          CatalogDb::Metal::Club,
                           grounds:        CatalogDb::Metal::Ground,
                           events:         CatalogDb::Metal::EventInfo,
                        )
  end
end # class Configuration

  ##  e.g. use config.catalog  -- keep Import.catalog as a shortcut (for "read-only" access)
  def self.catalog() config.catalog;  end
end   # module Import
end   # module SportDb




    

puts SportDb::Module::Catalogs.banner   # say hello
