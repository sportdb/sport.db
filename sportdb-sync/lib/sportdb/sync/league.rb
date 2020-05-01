module SportDb
  module Importer
    class League

      def self.league( q )
        league = Import.catalog.leagues.find( q )
        if league.nil?
          puts "** !!! ERROR !!! unknown league for key >#{q}<; sorry - add to LEAGUES table"
          exit 1
        end
        league
      end

      def self.find!( q )
        league = league( q )
        Sync::League.find( league )
      end

      def self.find_or_create_builtin!( q )
        league = league( q )
        Sync::League.find_or_create( league )
      end

=begin
  fix/todo: move to attic? still used/referenced anywhere ???
      def self.find_or_create( key, name:, **more_attribs )
         key = key.to_s
         rec = SportDb::Model::League.find_by( key: key )
         if rec.nil?

           ## add convenience lookup for country  e.g. country: 'eng' or country: 'at', etc.
           if more_attribs[:country].is_a?( String )
             country_key = more_attribs.delete( :country )
             more_attribs[ :country_id ] = SportDb::Importer::Country.find_or_create_builtin!( country_key ).id
           end

           ## use title and not name - why? why not?
           ##  quick fix:  change name to title
           attribs = { key:   key,
                       title: name }.merge( more_attribs )
           rec = SportDb::Model::League.create!( attribs )
         end
         rec
      end
=end

    end  # class League
  end  # module Importer



  module Sync
    class League

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
         ## use title and not name - why? why not?
         ##  quick fix:  change name to title

         attribs = { key:   league.key,
                     title: league.name }
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

