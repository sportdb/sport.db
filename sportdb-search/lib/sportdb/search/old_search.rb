###
#  sport search service api for leagues, clubs and more
#
# core api is:

###################################
## todo/fix - move to attic!!!!
###################################


class SportSearch

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
end  # class SportSearch




