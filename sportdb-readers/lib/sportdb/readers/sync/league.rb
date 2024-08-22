module SportDb
  module Sync
    class League

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

