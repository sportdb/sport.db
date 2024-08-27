## note: sportdb/catalogs pulls in sportdb/structs and footballdb/data
require 'sportdb/catalogs'



## move to base?
###  shared basics for search
class SportSearch
  class Search    ## base search service - use/keep - why? why not?
    attr_reader :service
    def initialize( service ) @service = service; end
  end  # class Search
end




## our own code
require_relative 'search/version'
require_relative 'search/sport'


########
###  setup sport search apis
class SportSearch
   def initialize( leagues:,
                   national_teams:,
                   clubs:,
                   grounds:,
                   events:,
                   players:
                   )
       @leagues        = LeagueSearch.new( leagues )
       @national_teams = NationalTeamSearch.new( national_teams )
       @clubs          = ClubSearch.new( clubs )
       @events         = EventSearch.new( events )

       @grounds        = GroundSearch.new( grounds )

       @players        = PlayerSearch.new( players )

       ## virtual deriv ("composite") search services
       @teams          = TeamSearch.new( clubs:          @clubs,
                                         national_teams: @national_teams )
       @event_seasons  = EventSeasonSearch.new( events: @events )

   end

 def leagues()        @leagues; end
 def national_teams() @national_teams; end
 def clubs()          @clubs; end
 def events()         @events; end
 def grounds()         @grounds; end

 def players()        @players; end

 def teams()          @teams; end         ## note - virtual table
 def seasons()        @event_seasons; end ## note - virtual table

 def countries
    puts
    puts "[WARN] do NOT use catalog.countries, deprecated!!!"
    puts "   please, switch to new world.countries search service"
    puts
    exit 1
 end
end # class SportSearch


class WorldSearch
    def initialize( countries:, cities: )
        ## change service to country_service or such - why? why not?
        ##  add city_service and such later

        @countries =  countries
        @cities    =  cities
    end

    ####
    #  note: for now setup only for countries & cities
    def countries() @countries;  end
    def cities()    @cities;  end
end  # class WorldSearch


#######
## add configuration

module SportDb
module Import
class Configuration
  def world
    @world ||= WorldSearch.new(
                      countries: CatalogDb::Metal::Country,
                      cities:    CatalogDb::Metal::City,
                   )
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
  #     how about catalogdb or ???
  attr_reader   :catalog_path
  def catalog_path=(path)
      @catalog_path = path
      ########
      # reset database here to new path
      CatalogDb::Metal::Record.database = path
      @catalog_path
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
    def self.world()   config.world;    end
    def self.catalog() config.catalog;  end

      ## lets you use
      ##   SportDb::Import.configure do |config|
      ##      config.catalog_path = './catalog.db'
      ##   end
    def self.configure()  yield( config ); end
    def self.config()  @config ||= Configuration.new;  end
end   # module Import
end   # module SportDb


module Sports
    ## note: just forward to SportDb::Import configuration!!!!!
    ##  keep Sports module / namespace "clean" - why? why not?
    ##    that is, only include data structures (e.g. Match,League,etc) for now - why? why not?
    def self.configure()  yield( config ); end
    def self.config()  SportDb::Import.config; end
end   # module Sports





###
##   add/augment core classes with search services
require_relative 'search/structs'
require_relative 'search/structs_world'



module SportDb
  module Import
    class Team
      ## add convenience lookup helper / method for name by season for now
      ##   use clubs history - for now kept separate from struct - why? why not?
      def name_by_season( season )
        ## note: returns / fallback to "regular" name if no records found in history
        SportDb::Import.catalog.clubs_history.find_name_by( name: name, season: season ) || name
      end
    end  # class Team
  end   # module Import
end     # module SportDb


###
## add default/built-in catalog here - why? why not?
##  todo/fix  - set catalog_path on demand
##   note:  for now required for world search setup etc.
## SportDb::Import.config.catalog_path = "#{FootballDb::Data.data_dir}/catalog.db"
##
##  note - for now set as default upstream in sportdb-catalogs!!!


puts SportDb::Module::Search.banner   # say hello

