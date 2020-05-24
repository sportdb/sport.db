module SportDb
  module Sync
    class Season
      def self.season( q )    ## helper for season key (rename to norm_key ???)
        Import::Season.new( q )
      end


      ###########
      #  searchers

      def self.search( q )   ## e.g. '2017/18'
        season = season( q )
        find( season )
      end

      ## todo/fix: remove builtin marker? - there are no "builtin" seasons like numbers all excepted for now
      def self.search_or_create( q )  ## e.g. '2017-18'
        season = season( q )
        find_or_create( season )
      end

      ################
      #  finders

      def self.find( season )
        season = season( season )  if season.is_a?( String )   ## auto-convert for now (for old compat) - why? why not?
        Model::Season.find_by( key: season.key )
      end

      def self.find!( season )
        season = season( season )  if season.is_a?( String )   ## auto-convert for now (for old compat) - why? why not?
        rec = find( season )
        if rec.nil?
          puts "** !!!ERROR!!! db sync - no season match found for >#{season.key}<:"
          exit 1
        end
        rec
      end

      def self.find_or_create( season )
        season = season( season )  if season.is_a?( String )   ## auto-convert for now (for old compat) - why? why not?
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

