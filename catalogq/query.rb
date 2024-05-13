## note: use the local version of sportdb gems
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
require 'sportdb/structs'



require 'sqlite3'


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

     def self.columns=(names) 
        ## note: auto-add table name to qualify
        @columns = names.map {|name| "#{self.tablename}.#{name}" } 
        @columns
     end
     def self.columns() @columns; end


     def self.count
        sql = "SELECT count(*) FROM #{self.tablename}"
        rows = execute( sql )
        rows[0][0]    # e.g. returns [[241]]
     end
  end  # class Record
end # module Metal
end # module CatalogDb



require_relative 'country'
require_relative 'club'  



###
# compat with old catalog class/api

module SportDb
module Import
   def self.catalog() Catalog; end

  class Catalog
    def self.countries() CatalogDb::Metal::Country; end
  end # class Catalog
end # module Import
end # module SportDb


