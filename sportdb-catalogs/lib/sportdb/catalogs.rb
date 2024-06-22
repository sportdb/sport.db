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
require_relative 'catalogs/city'

require_relative 'catalogs/club'   
require_relative 'catalogs/national_team'
require_relative 'catalogs/league'
require_relative 'catalogs/event_info'
require_relative 'catalogs/ground'   

## more
require_relative 'catalogs/player'



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
                          countries: CatalogDb::Metal::Country,
                          cities:    CatalogDb::Metal::City, 
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
                           players:        CatalogDb::Metal::Player,    # note - via players.db !!!
                        )
  end

  ###   
  #  find a better name for setting - why? why not?
  #     how about playersdb or ???
  attr_reader   :players_path 
  def players_path=(path)
      @players_path = path
      ######## 
      # reset database here to new path
      CatalogDb::Metal::PlayerRecord.database = path

      @players_path
  end
end # class Configuration


  ##  e.g. use config.catalog  -- keep Import.catalog as a shortcut (for "read-only" access)
  def self.catalog() config.catalog;  end
end   # module Import
end   # module SportDb





###
# add status
module CatalogDb
module Metal

def self.tables

  puts "==> table stats"
  catalog_path = SportDb::Import.config.catalog_path 
  if catalog_path
    puts "  #{File.basename(catalog_path)} in (#{File.dirname(catalog_path)})"
    puts "    #{Country.count} countries / #{City.count} cities" 
    puts "    #{NationalTeam.count} national teams"
    puts "    #{League.count} leagues"
    puts "    #{Club.count} clubs"
    puts "    #{Ground.count} grounds"
      ## add more

  else
    puts "  - no catalog.db set - "
  end

  ## todo/fix:
  ##   check if players_path configured???
  players_path = SportDb::Import.config.players_path 
  if players_path
    puts "  #{File.basename(players_path)} in (#{File.dirname(players_path)})"
    puts "    #{Player.count} players"
  else
    puts " - no players.db set -"
  end
end

end # module Metal
end # module CatalogDb
        


###
# global helpers
#    find a better name/place in module(s) or such
##
##  what name to use?
##    find_countries_for_league_clubs or such
##     find_countries_for_league  - why? why not?
##     note -  returns array of countries OR single country 

def find_countries_for_league( league )
    ## todo/fix: assert league is a League with country record/struct !!!!! 

    countries = [] 
    countries << league.country   ### assume league.country is already db record/struct - why? why not?
    ## check for 2nd countries for known leagues 
    ## (re)try with second country - quick hacks for known leagues
    ##  e.g. Swanse, cardiff  in premier league
    ##       san mariono in serie a (italy)
    ##       monaco  in ligue 1 (france)
    ##       etc.
    ##   add  andorra to spanish la liga (e.g. andorra fc???)
 
    case league.country.key
    when 'eng' then countries << CatalogDb::Metal::Country._record('wal') 
    when 'sco' then countries << CatalogDb::Metal::Country._record('eng')
    when 'ie'  then countries << CatalogDb::Metal::Country._record('nir')   
    when 'fr'  then countries << CatalogDb::Metal::Country._record('mc') 
    when 'es'  then countries << CatalogDb::Metal::Country._record('ad') 
    when 'it'  then countries << CatalogDb::Metal::Country._record('sm')
    when 'ch'  then countries << CatalogDb::Metal::Country._record('li') 
    when 'us'  then countries << CatalogDb::Metal::Country._record('ca')
    when 'au'  then countries << CatalogDb::Metal::Country._record('nz')
    end 

    ## use single ("unwrapped") item for one country 
    ##    otherwise use array
    country =  countries.size == 1 ? countries[0] : countries
    country
end






require 'footballdb/data'   ## pull in catalog.db (built-in/default data/db)

###
## add default/built-in catalog here - why? why not?
##  todo/fix  - set catalog_path on demand 
##   note:  for now required for world search setup etc.
SportDb::Import.config.catalog_path = "#{FootballDb::Data.data_dir}/catalog.db"



puts SportDb::Module::Catalogs.banner   # say hello
