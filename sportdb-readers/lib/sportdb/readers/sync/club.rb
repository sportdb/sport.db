module SportDb
  module Sync
    class Club

      ## auto-cache all clubs by find_or_create for later mapping / lookup
      def self.cache() @cache ||= {}; end


      ##################################
      #  finders

      def self.find_or_create( club )
        ## note: assume "canonical unique" names for now for clubs
        rec = Model::Team.find_by( name: club.name )
        if rec.nil?

          ## todo/fix:  move auto-key gen to structs for re(use)!!!!!!
          ## check if key is present otherwise generate e.g. remove all non-ascii a-z chars
          key  =  club.key || club.name.downcase.gsub( /[^a-z]/, '' )
          puts "add club: #{key}, #{club.name}, #{club.country.name} (#{club.country.key})"

          attribs = {
              key:        key,
              name:       club.name,
              country_id: Sync::Country.find_or_create( club.country ).id,
              club:       true,
              national:   false  ## check -is default anyway - use - why? why not?
              ## todo/fix: add city if present - why? why not?
          }

          attribs[:code] = club.code   if club.code   ## add code (abbreviation) if present

          if club.alt_names.empty? == false
            attribs[:alt_names] = club.alt_names.join('|')
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
