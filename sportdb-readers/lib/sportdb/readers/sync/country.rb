module SportDb
  module Sync
    class Country

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
