module SportDb
  module Sync
    class Club

      ## auto-cache all clubs by find_or_create for later mapping / lookup
      def self.cache() @cache ||= {}; end


      def self.club( q, league: nil)   ## "internal" search helper using catalog
        ## note: league.country might return nil (e.g. for intl leagues)
        country = league ? league.country : nil
        club = Import.catalog.clubs.find_by( name: q, country: country )

        if club.nil?
           ## todo/check: exit if no match - why? why not?
           puts "!!! *** ERROR *** no matching club found for >#{q}< - add to clubs setup"
           exit 1
        end
        club
      end

      #############################
      #  searchers

      ## todo/fix - move array support for now to attic!!!

      def self.search_or_create_by!( name:, league: nil, season: nil )
        ## note: season is for now optional (and unused) - add/use in the future!!!

        ## note: allow search by single name/q
        ##   or  allow search by list/array of names/qs tooo!!!
        if name.is_a?( Array )
          ## assume batch search return array of mappings
          club_recs = []
          name.each do |q|
            club        = club( q, league: league )
            clubs_recs << find_or_create( club )
          end
          club_recs
        else
          ## assume single search
          q = name
          club = club( q, league: league )
          find_or_create( club )
        end
      end


      ##################################
      #  finders

      def self.find_or_create( club )
        ## note: assume "canonical uniquie" names/titles for now for clubs
        rec = Model::Team.find_by( title: club.name )
        if rec.nil?

          ## todo/fix:  move auto-key gen to structs for re(use)!!!!!!
          ## check if key is present otherwise generate e.g. remove all non-ascii a-z chars
          key  =  club.key || club.name.downcase.gsub( /[^a-z]/, '' )
          puts "add club: #{key}, #{club.name}, #{club.country.name} (#{club.country.key})"

          attribs = {
              key:        key,
              title:      club.name,
              country_id: Sync::Country.find_or_create( club.country ).id,
              club:       true,
              national:   false  ## check -is default anyway - use - why? why not?
              ## todo/fix: add city if present - why? why not?
          }

          attribs[:code] = club.code   if club.code   ## add code (abbreviation) if present

          if club.alt_names.empty? == false
            attribs[:synonyms] = club.alt_names.join('|')
          end

          rec = Model::Team.create!( attribs )
        end
        ## auto-add to cache
        cache[club.name] = rec

        rec
      end

    end # class Club
  end # module Sync
end # module SportDb
