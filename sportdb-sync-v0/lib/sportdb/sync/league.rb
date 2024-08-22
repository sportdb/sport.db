module SportDb
  module Sync
    class League

      def self.league( q )   ## todo/check: find a better or "generic" alias name e.g. convert/builtin/etc. - why? why not?
        Import.catalog.leagues.find!( q )     ## todo/fix: change find to search!!!
      end


      ################################
      #  searchers

      def self.search!( q )   ## note: use search for passing in string queries (and find for records/structs only)
        league = league( q )
        find( league )
      end

      def self.search_or_create!( q )
        league = league( q )
        find_or_create( league )
      end

      ###################################
      #   finders

    def self.find( league )
      Model::League.find_by( key: league.key )
    end

    def self.find!( league )
      rec = find( league )
      if rec.nil?
        puts "** !!!ERROR!!! db sync - no league match found for:"
        pp league
        exit 1
      end
      rec
    end

    def self.find_or_create( league )
      rec = find( league )
      if rec.nil?
         attribs = { key:   league.key,
                     name:  league.name }

        if league.country
           attribs[ :country_id ] = Sync::Country.find_or_create( league.country ).id
         end

         rec = Model::League.create!( attribs )
       end
       rec
    end

  end # class League
end   # module Sync
end   # module SportDb

