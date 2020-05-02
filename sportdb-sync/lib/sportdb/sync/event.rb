module SportDb
  module Importer
    class Event

def self.search_or_create_by!( league:, season: )

   league = league.is_a?( String ) ? Import::League.find_or_create_builtin!( league ) : league
   season = season_is_a?( String ) ? Import::Season.find_or_create_builtin( season )  : season

   Sync::Event.find_or_create_by( league: league, season: season )
end

    end  # class Event
  end  # module Importer


  module Sync

    class Event
      def league( league )
        ## if already ActiveRecord db model - pass through as is
        league.is_a?( String ) ? League.league( league ) : league
      end

      def season( season )
        ## todo/fix: add Import::Season too - why? why not?
        ## if already ActiveRecord db model - pass through as is
        season.is_a?( String ) ? Season.season( season ) : season
      end

      def self.search( q )
        ## add - why? why not?
      end

      def self.search_by( league:, season: )
        league = league( league )
        season = season( season )
        find_by( league: league, season: season )
      end

      def self.search_or_create_by( league:, season: )
        ## add - why? why not?
      end



      def self.find_by( league:, season: )
        ## note: allow passing in of activerecord db records too - why? why not?

        season_rec = season.is_a?( Import::Season) ||
                     season.is_a?( String )            ? Import::Season.find( season ) : season
        league_rec = league.is_a?( Import::League)     ? Import::League.find( league ) : league

        ##  auto-create league and season (db) records if missing? - why? why not?
        return nil    if season_rec.nil?  || league_rec.nil?

        Model::Event.find_by( league_id: league_rec.id,
                              season_id: season_rec.id )
      end

      def self.find_by!( league:, season: )
        rec = find_by( league: league, season: season )
        if rec.nil?
          puts "** !!!ERROR!!! db sync - no event match found for:"
          pp league
          pp season
          exit 1
        end
        rec
      end


      def self.find_or_create_by( league:, season: )
        ## note: allow passing in of activerecord db records too - why? why not?
        ## note:  auto-creates league and season (db) records if missing - why? why not?

        season_rec = season.is_a?( Import::Season ) ||
                     season.is_a?( String )            ? Import::Season.find_or_create( season ) : season
        league_rec = league.is_a?( Import::League)     ? Import::League.find_or_create( league ) : league

        rec = Model::Event.find_by( league_id: league_rec.id,
                                    season_id: season_rec.id )
        if rec.nil?
          ## quick hack/change later !!
          ##  todo/fix: check season  - if is length 4 (single year) use 2017, 1, 1
          ##                               otherwise use 2017, 7, 1
          ##  start_at use year and 7,1 e.g. Date.new( 2017, 7, 1 )
          ## hack:  fix/todo1!!
          ##   add "fake" start_at date for now
          if season_rec.key.size == '4'   ## e.g. assume 2018 etc.
            year = season_rec.key.to_i
            start_at = Date.new( year, 1, 1 )
          else  ## assume 2014/15 etc.
            year = season_rec.key[0..3].to_i
            start_at = Date.new( year, 7, 1 )
          end

          attribs = {
            league_id: league.id,
            season_id: season.id,
            start_at:  start_at  }

          rec = Model::Event.create!( attribs )
        end
        rec
      end
    end  # class Event

  end   # module Sync
end   # module SportDb

