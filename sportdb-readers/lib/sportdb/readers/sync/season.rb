module SportDb
  module Sync
    class Season

      ################
      #  finders

      def self.find( season )
        season = Season( season )     ## auto-convert for now (for old compat) - why? why not?
        Model::Season.find_by( key: season.key )
      end

      def self.find!( season )
        season = Season( season )     ## auto-convert for now (for old compat) - why? why not?
        rec = find( season )
        if rec.nil?
          puts "** !!!ERROR!!! db sync - no season match found for >#{season.key}<:"
          exit 1
        end
        rec
      end

      def self.find_or_create( season )
        season = Season( season )    ## auto-convert for now (for old compat) - why? why not?
        rec = find( season )
        if rec.nil?
           attribs = { key:   season.key,
                       name:  season.name  }
           rec = Model::Season.create!( attribs )
        end
        rec
      end
    end # class Season
  end   # module Sync
end   # module SportDb

