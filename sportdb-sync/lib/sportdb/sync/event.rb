module SportDb
  module Sync

    class Event
      def self.league( q ) League.league( q ); end
      def self.season( q ) Season.season( q ); end

      ############################################
      #  searchers

      def self.search_by!( league:, season: )
        raise ArgumentError.new( "league query string expected; got #{league.class.name}" ) unless league.is_a?( String )
        raise ArgumentError.new( "season query string expected; got #{season.class.name}" ) unless season.is_a?( String )

        league = league( league )
        season = season( season )

        find_by( league: league, season: season )
      end

      def self.search_or_create_by!( league:, season: )
        raise ArgumentError.new( "league query string expected; got #{league.class.name}" ) unless league.is_a?( String )
        raise ArgumentError.new( "season query string expected; got #{season.class.name}" ) unless season.is_a?( String )

        league = league( league )
        season = season( season )

        find_or_create_by( league: league, season: season )
     end

      ##################################################
      #  finders

      def self.find_by( league:, season: )
        ## note: allow passing in of activerecord db records too - why? why not?
        raise ArgumentError.new( "league struct record expected; got #{league.class.name}" ) unless league.is_a?( Import::League )
        raise ArgumentError.new( "season struct record expected; got #{season.class.name}" ) unless season.is_a?( Import::Season )

        ##  auto-create league and season (db) records if missing? - why? why not?
        season_rec = Season.find( season )
        league_rec = League.find( league )

        rec = nil
        rec = Model::Event.find_by( league_id: league_rec.id,
                                    season_id: season_rec.id )  if season_rec && league_rec
        rec
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
        raise ArgumentError.new( "league struct record expected; got #{league.class.name}" ) unless league.is_a?( Import::League )
        raise ArgumentError.new( "season struct record expected; got #{season.class.name}" ) unless season.is_a?( Import::Season )

        ## note: auto-creates league and season (db) records if missing - why? why not?
        season_rec = Season.find_or_create( season )
        league_rec = League.find_or_create( league )

        rec = Model::Event.find_by( league_id: league_rec.id,
                                    season_id: season_rec.id )
        if rec.nil?
          attribs = {
            league_id: league_rec.id,
            season_id: season_rec.id,
          }

          ## quick hack/change later !!
          ##  todo/fix: check season  - if is length 4 (single year) use 2017, 1, 1
          ##                               otherwise use 2017, 7, 1
          ##  start_at use year and 7,1 e.g. Date.new( 2017, 7, 1 )
          ## hack:  fix/todo1!!
          ##   add "fake" start_at date for now
          attribs[:start_at]  = if season.year?  ## e.g. assume 2018 etc.
                                   Date.new( season.start_year, 1, 1 )
                                else  ## assume 2014/15 etc.
                                   Date.new( season.start_year, 7, 1 )
                                end

          rec = Model::Event.create!( attribs )
        end
        rec
      end
    end  # class Event

  end   # module Sync
end   # module SportDb

