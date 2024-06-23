###
#  sport search service api for leagues, clubs and more
#
# core api is:


class SportSearch

class Search    ## base search service - use/keep - why? why not? 
  def initialize( service ) @service = service; end
end  # class Search


class PlayerSearch < Search
  ###################
  ## core required delegates  - use delegate generator - why? why not?
  def match_by( name:, country: nil, year: nil )
    @service.match_by( name:    name, 
                       country: country,
                       year:    year ) 
  end

  ###############
  ### more deriv support functions / helpers
  def match( name ) match_by( name: name ); end
  ## add more here - why? why not? 
end   # class PlayerSearch


class LeagueSearch < Search
  ###################
  ## core required delegates  - use delegate generator - why? why not?
  def match_by( name:, country: nil ) 
    @service.match_by( name: name, 
                       country: country ) 
  end

  ###############
  ### more deriv support functions / helpers
  def match( name )   match_by( name: name ); end 

  def find!( name )
    league = find( name )
    if league.nil?
      puts "** !!! ERROR - no league match found for >#{name}<, add to leagues table; sorry"
      exit 1
    end
    league
  end

  def find( name )
    league = nil
    recs = match( name )
    # pp m

    if recs.empty?
      ## fall through/do nothing
    elsif recs.size > 1
      puts "** !!! ERROR - ambigious league name; too many leagues (#{recs.size}) found:"
      pp recs
      exit 1
    else
      league = recs[0]
    end

    league
  end
end # class LeagueSearch


class GroundSearch  < Search
  ###################
  ## core required delegates  - use delegate generator - why? why not?
  def match_by( name:, country: nil, city: nil )
    @service.match_by( name:    name, 
                       country: country,
                       city:    city ) 
  end

  ###############
  ### more deriv support functions / helpers
  def match( name ) match_by( name: name ); end
  ## add more here - why? why not? 
end  # class GroundSearch



class NationalTeamSearch  < Search
  ###################
  ## core required delegates  - use delegate generator - why? why not?

  ## changle core api to match( q ) only - why? why not?
  ##   and make find and find! derivs???
  def find( q )    @service.find( q ); end
  def find!( q )   @service.find!( q ); end
end # class NationalTeamSearch


class ClubSearch  < Search
  ###################
  ## core required delegates  - use delegate generator - why? why not?

  ## add mods here - why? why not?

  def match_by( name:, country: nil,
                       league:  nil,
                       mods:    nil )
    ## for now assume "global" mods  - checks only for name
    ##     
    if mods && mods[ name ]
      club = mods[ name ]
      return [club]   # note: wrap (single record) in array
    end   

    ## note: add "auto-magic" country calculation via league record
    ##            if league is a national league for football clubs
    if league
        raise ArgumentError, "match_by - league AND country NOT supported; sorry"  if country
### find countries via league        
###     support league.intl? too - why? why not?
###       or only nationa league
        raise ArgumentError, "match_by - league - only national club leagues supported (not int'l or national teams for now); sorry"   unless league.national? && league.clubs?
       
        ### calc countries
        ### uses "global" func in sports-catalogs for now
        ##   move code here - why? why not? 
        country = find_countries_for_league( league )
        @service.match_by( name:    name, 
                           country: country )
    else
        @service.match_by( name:    name, 
                           country: country )
    end 
  end


  ## todo/fix/check: use rename to find_canon  or find_canonical() or something??
  ##  remove (getting used?) - why? why not?
  # def []( name )    ## lookup by canoncial name only;  todo/fix: add find alias why? why not?
  #  puts "WARN!! do not use ClubIndex#[] for lookup >#{name}< - will get removed!!!"
  #  @clubs[ name ]
  # end


  ###############
  ### more deriv support functions / helpers
  def match( name ) match_by( name: name ); end
 
  ##########
  #  "legacy" finders - return zero or one club 
  ##    (if more than one match, exit/raise error/exception) 
  def find( name )   find_by( name: name ); end
  def find!( name )  find_by!( name: name ); end

  ## find - always returns a single record / match or nil
  ##   if there is more than one match than find aborts / fails
  def find_by!( name:, country: nil,
                       league:  nil )    ## todo/fix: add international or league flag?
    club = find_by( name:    name, 
                    country: country,
                    league:  league )

    if club.nil?
      puts "** !!! ERROR - no match for club >#{name}<"
      exit 1
    end

    club
  end


  def find_by( name:, country: nil,
                      league:  nil )    ## todo/fix: add international or league flag?
    ## note: allow passing in of country key too (auto-counvert)
    ##       and country struct too
    ##     - country assumes / allows the country key or fifa code for now
    recs = match_by( name:    name, 
                     country: country, 
                     league:  league )

    club = nil
    if recs.empty?
      ## puts "** !!! WARN !!! no match for club >#{name}<"
    elsif recs.size > 1
      puts "** !!! ERROR - too many matches (#{recs.size}) for club >#{name}<:"
      pp recs
      exit 1
    else   # bingo; match - assume size == 1
      club = recs[0]
    end

    club
  end


#######
# more support methods
  def build_mods( mods )
    ## e.g.
    ##  { 'Arsenal   | Arsenal FC'    => 'Arsenal, ENG',
    ##    'Liverpool | Liverpool FC'  => 'Liverpool, ENG',
    ##    'Barcelona'                 => 'Barcelona, ESP',
    ##    'Valencia'                  => 'Valencia, ESP' }

    mods.reduce({}) do |h,(club_names, club_line)|

      values = club_line.split( ',' )
      values = values.map { |value| value.strip }  ## strip all spaces

      ## todo/fix: make sure country is present !!!!
      club_name, country_name = values
      club = find_by!( name: club_name, country: country_name )

      values = club_names.split( '|' )
      values = values.map { |value| value.strip }  ## strip all spaces

      values.each do |club_name|
        h[club_name] = club
      end
      h
    end
  end
end # class ClubSearch



## todo/check - change to EventInfoSearch - why? why not?
class EventSearch < Search
  ##
  ## todo - eventinfo search still open / up for change

  ###################
  ## core required delegates  - use delegate generator - why? why not?
  def seasons( league )
      @service.seasons( league )
  end
  def find_by( league:, season: )
      @service.find_by( league: league,
                        season: season )
  end
end # class EventSearch


####
## virtual table for season lookup
##   note - use EventSeaon  to avoid name conflict with (global) Season class 
##      find a better name SeasonInfo or SeasonFinder or SeasonStore 
##                       or SeasonQ or ??
class EventSeasonSearch
    def initialize( events: ) 
        @events = events 
    end

  ###############
  ## todo/fix:  find a better algo to guess season for date!!!
  ##
  def find_by( date:, league: )
    date = Date.strptime( date, '%Y-%m-%d' )   if date.is_a?( String )
  
    infos = @events.seasons( league )

    infos.each do |info|
       return info.season   if info.include?( date )
    end
    nil
  end
end # class EventSeasonSearch
  

######
### add virtual team search ( clubs + national teams)
##   note: no record base!!!!!
class TeamSearch
    ## note: "virtual" index lets you search clubs and/or national_teams (don't care)
  
  def initialize( clubs:, national_teams: ) 
    @clubs          = clubs
    @national_teams = national_teams 
  end

    ## todo/check: rename to/use map_by! for array version - why? why not?
    def find_by!( name:, league:, mods: nil )
      if name.is_a?( Array )
        recs = []
        name.each do |q|
          recs << _find_by!( name: q, league: league, mods: mods )
        end
        recs
      else  ## assume single name
        _find_by!( name: name, league: league, mods: mods )
      end
    end
  
  
    def _find_by!( name:, league:, mods: nil )
      if mods && mods[ league.key ] && mods[ league.key ][ name ]
        mods[ league.key ][ name ]
      else
        if league.clubs?
          if league.intl?    ## todo/fix: add intl? to ActiveRecord league!!!
            @clubs.find!( name )
          else  ## assume clubs in domestic/national league tournament
             ## note - search by league countries (may incl. more than one country 
             ##             e.g. us incl. ca, fr incl. mc, ch incl. li, etc.
            @clubs.find_by!( name: name, league: league )
          end
        else   ## assume national teams (not clubs)
          @national_teams.find!( name )
        end
      end
    end # method _find_by!
  end  # class TeamSearch
  
  

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

    def countries
        puts
        puts "[WARN] do NOT use catalog.countries, deprecated!!!"
        puts "   please, switch to new world.countries search service"
        puts
        exit 1
    end

 def leagues()        @leagues; end
 def national_teams() @national_teams; end
 def clubs()          @clubs; end
 def events()         @events; end
 def grounds()         @grounds; end

 def players()        @players; end
 
 def teams()          @teams; end         ## note - virtual table
 def seasons()        @event_seasons; end ## note - virtual table
end  # class SportSearch
