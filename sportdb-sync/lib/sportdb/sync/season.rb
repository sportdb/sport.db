module SportDb
  module Importer
    class Season
      ## todo/fix: remove builtin marker? - there are no "builtin" seasons like numbers all excepted for now
      def self.find_or_create_builtin( q )  ## e.g. '2017-18'
         Sync::Season.find_or_create( q )
      end
    end # class Season
  end  # module Importer


  module Sync
    class Season
      def self.norm_key( key )    ## helper for season key (rename to norm_key ???)
        season = Season.new( key )
        season.key
      end

      def self.find( key )
        key = norm_key( key )
        Model::Season.find_by( key: key )
      end

      def self.find!( key )
        rec = find( key )
        if rec.nil?
          puts "** !!!ERROR!!! db sync - no season match found for >#{norm_key(key)}<:"
          pp key
          exit 1
        end
        rec
      end

      def self.find_or_create( key )  ## e.g. key = '2017/18'
        rec = find( key )
        if rec.nil?
           key = norm_key( key )  ## note: do NOT forget to normalize key e.g. always use slash (2019/20) etc.
           attribs = { key:   key,
                       title: key  }
           rec = Model::Season.create!( attribs )
        end
        rec
      end
    end # class Season
  end   # module Sync
end   # module SportDb

