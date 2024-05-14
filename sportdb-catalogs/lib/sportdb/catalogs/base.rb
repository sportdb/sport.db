module CatalogDb
module Metal

  class Record
    ## add db alias why? why not?
     def self.database
        @db ||= SQLite3::Database.new( '../catalog/catalog.db' ) 
        @db
     end

     def self.database=(path)
        @db = SQLite3::Database.new( path )
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


###########
### share common methods for reuse

  ## helpers from country - use a helper module for includes (share with clubs etc.) - why? why not?
  # include NameHelper
  extend SportDb::NameHelper
  ## incl. strip_year( name )
  ##       has_year?( name)
  ##       strip_lang( name )
  ##       normalize( name )

def self._to_bool( value )
   if value == 0
       false
   elsif value == 1
       true
   else
       ## use TypeError - why? why not? or if exits ValueError?
       raise ArgumentError, "0 or 1 expected for bool in sqlite; got #{value}"
   end
end             

def self._to_country( key ) 
   # note: use cached record or (faster) key lookup on fallback
   Country._record( key )   
end

def self._country( country )
   if country.is_a?( String ) || country.is_a?( Symbol )
     # note: query/find country via catalog db
     rec = Country.find( country.to_s )  
     if rec.nil?
       puts "** !!! ERROR !!! - unknown country >#{country}< - no match found, sorry - add to world/countries.txt in config"
       exit 1
     end
     rec
   else
     country  ## (re)use country struct - no need to run lookup again
   end
end


  end  # class Record
end # module Metal
end # module CatalogDb
