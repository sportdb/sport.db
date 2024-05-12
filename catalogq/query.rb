require "sqlite3"


module CatalogDb
module Metal

  class Record
    ## add db alias why? why not?
     def self.database
        @db ||= SQLite3::Database.new( '../catalog/catalog.db' ) 
        @db
     end

     def self.execute( sql ) 
        puts "==> sql query [#{self.name}]"
        puts sql
        database.execute( sql ) 
     end

     def self.tablename=(name) @tablename = name; end
     def self.tablename() @tablename; end

     def self.columns=(name) @columns = name; end
     def self.columns() @columns; end

     def self.count
        sql = "SELECT count(*) FROM #{self.tablename}"
        rows = execute( sql )
        rows[0][0]    # e.g. returns [[241]]
     end
  end  # class Record


  class Country  < Record
     self.tablename = 'countries'

     self.columns = ['countries.key', 
                     'countries.name', 
                     'countries.code',
                     'countries.tags',
                     'countries.alt_names']

      def self.find_by_name( name )
        rows = execute( <<-SQL )
        SELECT #{self.columns.join(', ')}
        FROM countries 
        INNER JOIN country_names ON countries.key  = country_names.key
        WHERE country_names.name = '#{name}' 
SQL
       rows 
      end          
  end  # class Country


  class Club < Record
    self.tablename = 'clubs'

    self.columns = ['clubs.key', 
                    'clubs.name', 
                    'clubs.code', 
                    'clubs.country_key']


    def self.match_by_name( name )
        rows = execute( <<-SQL )
        SELECT #{self.columns.join(', ')}
        FROM clubs 
        INNER JOIN club_names ON clubs.key  = club_names.key
        WHERE club_names.name = '#{name}' 
SQL
       rows 
    end
  end  # class Club


end # module Metal
end # module CatalogDb


Country = CatalogDb::Metal::Country
Club    = CatalogDb::Metal::Club



pp Country.count
pp Club.count

pp Club.match_by_name( 'arsenal' )
pp Club.match_by_name( 'xxx' )
pp Club.match_by_name( 'liverpool' )

pp Club.match_by_name( 'az' )
pp Club.match_by_name( 'bayern' )


pp Country.find_by_name( 'austria' )
pp Country.find_by_name( 'deutschland' )
pp Country.find_by_name( 'iran' )


puts "bye"


