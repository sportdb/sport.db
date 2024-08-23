require 'sportdb/structs'

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



###
# add status
module CatalogDb
module Metal

def self.tables

  puts "==> table stats"
  if Record.database?
    db = Record.database
    filename = db.filename
    if filename  # note - nil for memory or tempary db?
      puts "  #{File.basename(filename)} in (#{File.dirname(filename)})"
    else
      puts  "no filename; memory or temporary db?"
    end

    ## pp Record.database
    ## puts
    puts "    #{Country.count} countries / #{City.count} cities"
    puts "    #{NationalTeam.count} national teams"
    puts "    #{League.count} leagues"
    puts "    #{Club.count} clubs"
    puts "    #{Ground.count} grounds"
      ## add more
  else
    puts "  - no catalog.db set - "
  end


  if PlayerRecord.database?
    db = PlayerRecord.database
    filename = db.filename
    if filename  # note - nil for memory or tempary db?
      puts "  #{File.basename(filename)} in (#{File.dirname(filename)})"
    else
      puts  "no filename; memory or temporary db?"
    end

    ## pp PlayerRecord.database
    ## puts
    puts "    #{Player.count} players"
  else
    puts "  - no players.db set -"
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



puts SportDb::Module::Catalogs.banner   # say hello
