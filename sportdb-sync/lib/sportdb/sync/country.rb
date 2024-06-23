module SportDb
  module Sync
    class Country

    ### todo/fix:
    ##  add ALTERNATE / ALTERNATIVE COUNTRY KEYS!!!!
    ##   e.g. d => de, a => at, en => eng, etc.
    ##   plus  add all fifa codes too   aut => at, etc.  - why? why not?

    def self.country( q )
       ## note: use built-in countries for mapping country keys/codes
       country = Import.world.countries.find( q )
       if country
        ## todo/check:  keep key mapping warning - useful? why? why not?
         if country.key != q.to_s
          puts "** note: mapping (normalizing) country key >#{q}< to >#{country.key}<"
         end
       else
         puts "** !!! ERROR !!! unknown / invalid country for key >#{q}<; sorry - add to COUNTRIES table"
         exit 1
       end
       country
    end

    ########################
    #  searchers
    #
    #  - fix!!!! - remove searchers - why? why not?
    #                check if used anywhere ????

    def self.search!( q )
      country = country( q )
      find!( country )
    end

    def self.search_or_create!( q )
      country = country( q )
      find_or_create( country )
    end

    #############################
    #  finders

      def self.find( country )
        WorldDb::Model::Country.find_by( key: country.key )
      end

      def self.find!( country )
        rec = find( country )
        if rec.nil?
            puts "** !!! ERROR !!! - country for key >#{country.key}< not found; sorry - add to COUNTRIES table"
            exit 1
        end
        rec
     end

     def self.find_or_create( country )
      rec = find( country )
      if rec.nil?
        attribs = {
          key:  country.key,
          name: country.name,
          code: country.code,  ## fix:  uses fifa code now (should be iso-alpha3 if available)
          ## fifa: country.fifa,
          area: 1,
          pop:  1
        }
        rec = WorldDb::Model::Country.create!( attribs )
      end
      rec
    end
    end # class Country

  end # module Sync
end # module SportDb
