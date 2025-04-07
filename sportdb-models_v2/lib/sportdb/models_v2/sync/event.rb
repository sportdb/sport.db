module SportDbV2
  module Sync

    class Event
      def self.find_or_create( league_rec:, season: )
        ## note: allow passing in of activerecord db records too - why? why not?
        ## raise ArgumentError, "league struct record expected; got #{league.class.name}"  unless league.is_a?( Model::League )
        raise ArgumentError, "season expected; got #{season.class.name}"  unless season.is_a?( Season )

        rec = Model::Event.find_by( league_id: league_rec.id,
                                    season:    season.to_key )
        if rec.nil?
          attribs = {
            league_id: league_rec.id,
            season:    season.to_key,
          }

          rec = Model::Event.create!( attribs )
        end
        rec
      end
    end  # class Event

  end   # module Sync
end   # module SportDbV2

