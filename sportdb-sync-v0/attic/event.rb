
##  fix/todo: move to attic? still used/referenced anywhere ???

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
