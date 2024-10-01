module Sports

class EventInfo
  def self._search() CatalogDb::Metal::EventInfo; end

  def self.find_by( league:, season: )
        _search.find_by( league: league,
                         season: season )
  end

  def self.seasons( league )
        _search.seasons( league )
  end
end # class EventInfo

end  # module Sports


__END__


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




