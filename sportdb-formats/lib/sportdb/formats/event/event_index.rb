module SportDb
module Import


class EventIndex

    def self.build( path )
      datafiles = Package.find_seasons( path )

      puts
      puts "#{datafiles.size} seasons datafile(s):"
      pp datafiles

      index = new
      datafiles.each do |datafile|
        recs = EventInfoReader.read( datafile )
        # pp recs

        index.add( recs )
      end

      index
    end


    attr_reader :events
    def initialize
      @events  = []
      @leagues = {}
    end

    def add( recs )
      @events += recs  ## add to "linear" records

      recs.each do |rec|
        league = rec.league
        season = rec.season

        seasons = @leagues[ league.key ] ||= {}
        seasons[season.key] = rec
      end
      ## build search index by leagues (and season)
    end

    def find_by( league:, season: )
      league_key = league.is_a?( String ) ? league : league.key
      season_key = season.is_a?( String ) ? season : season.key

      seasons = @leagues[ league_key ]
      if seasons
        seasons[ season_key ]
      else
        nil
      end
    end # method find_by
end  ## class EventIndex



class SeasonIndex
    def initialize( *args )
       @leagues = {}   ## use a league hash by years for now; change later

       if args.size == 1 && args[0].is_a?( EventIndex )
         ## convenience setup/hookup
         ##  (auto-)add all events from event index
         add( args[0].events )
       else
         pp args
         raise ArgumentError.new( 'unsupported arguments' )
       end
    end

    def add( recs )
      ## use a lookup index by year for now
      ##  todo - find something better/more generic for searching/matching date periods!!!
      recs.each do |rec|
        league = rec.league
        season = rec.season

        years = @leagues[ league.key ] ||= {}
        if season.year?
          years[season.start_year] ||= []
          years[season.start_year] << rec
        else
          years[season.start_year] ||= []
          years[season.end_year]   ||= []
          years[season.start_year] << rec
          years[season.end_year]   << rec
        end
      end
    end # method add

    def find_by( date:, league: )
       date = Date.strptime( date, '%Y-%m-%d' )   if date.is_a?( String )
       league_key = league.is_a?( String ) ? league : league.key

       years = @leagues[ league_key ]
       if years
           year = years[ date.year ]
           if year
               season_key = nil
               year.each do |event|
                 ##  todo/check: rename/use between? instead of include? - why? why not?
                 if event.include?( date )
                   season_key = event.season.key
                   break
                 end
               end
               if season_key.nil?
                 puts "!! WARN: date >#{date}< out-of-seasons for year #{date.year} in league #{league_key}:"
                 year.each do |event|
                   puts "  #{event.season.key} |  #{event.start_date} - #{event.end_date}"
                 end
                 ## retry again and pick season with "overflow" at the end (date is great end_date)
                 year.each do |event|
                   if date > event.end_date
                     diff_in_days = date.to_date.jd - event.end_date.to_date.jd
                     puts "    +#{diff_in_days} days - adding overflow to #{event.season.key} ending on #{event.end_date} ++ #{date}"
                     season_key = event.season.key
                     break
                   end
                 end
                 ## exit now for sure - if still empty!!!!
                 if season_key.nil?
                   puts "!! ERROR: CANNOT auto-fix / (auto-)append date at the end of an event; check season setup - sorry"
                   exit 1
                 end
               end
               season_key
           else
             nil   ## no year defined / found for league
           end
       else
          nil   ## no league defined / found
       end
   end  # method find

end # class SeasonIndex


end   # module Import
end   # module SportDb
