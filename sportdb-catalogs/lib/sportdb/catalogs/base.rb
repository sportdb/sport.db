module CatalogDb
module Metal

##
#   change BaseRecord to Record again
##    AND  PlayerRecord   to PlayerBase or PlayerDatabase ?
##    AND  (Catalog)Record to CatalogBase or CatalogDatabase  - why? why not?


class BaseRecord   ## or just use Base or such - why? why not?
 
      def self.execute( sql ) 
         ## puts "==> sql query [#{self.name}]"
         ## puts sql
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


   ##
   #  todo/check - make _country available to all dbs/records? why? why not?

   def self._country( country )
      if country.is_a?( String ) || country.is_a?( Symbol )
        # note: query/find country via catalog db
        rec = Country.find_by_code( country )
        rec = Country.find_by_name( country )  if rec.nil?  
        if rec.nil?
          puts "** !!! ERROR !!! - unknown country >#{country}< - no match found, sorry - add to world/countries.txt in config"
          exit 1
        end
        rec
      else
        country  ## (re)use country struct - no need to run lookup again
      end
   end
end  # class BaseRecord


class PlayerRecord  < BaseRecord
      def self.database
         ### note: only one database for all derived records/tables!!!
         ##   thus MUST use @@ and not @!!!!!
         @@db ||= SQLite3::Database.new( '../catalog/players.db' ) 
         @@db
      end
 
      def self.database=(path)
         puts "==> setting (internal) players db to: >#{path}<"
         @@db = SQLite3::Database.new( path )
         pp @@db
         @@db
      end 
end   # class PlayerRecord



##############
### todo (fix) / rename to CatalogRecord - why? why not?
class Record  < BaseRecord    
    ## add db alias why? why not?
     def self.database
        ### note: only one database for all derived records/tables!!!
        ##   thus MUST use @@ and not @!!!!!
        @@db ||= SQLite3::Database.new( '../catalog/catalog.db' ) 
        @@db
     end

     def self.database=(path)
        puts "==> setting (internal) catalog db to: >#{path}<"
        @@db = SQLite3::Database.new( path )
        pp @@db
        @@db
     end

###########
### share common methods for reuse

def self._to_league( key )
   League._record( key )
end

def self._to_country( key ) 
   # note: use cached record or (faster) key lookup on fallback
   Country._record( key )   
end

def self._to_city( key )   ### rename; use find_by_key / find_by( key: )
   # note: use cached record or (faster) key lookup on fallback
   City._record( key )   
end


def self._city( city )
   if city.is_a?( String ) || city.is_a?( Symbol )
     # note: query/find country via catalog db
     recs = City.match_by( name: city )
     if recs.empty?
       puts "** !!! ERROR !!! - unknown city >#{city}< - no match found, sorry"
       exit 1
     elsif recs.size > 1
       puts "** !!! ERROR !!! - city >#{city}< - too many matches found (#{recs.size}), sorry"
       pp recs
       exit 1
     end
     recs[0]
   else
     city  ## (re)use city struct - no need to run lookup again
   end
end
end  # class Record



end # module Metal
end # module CatalogDb
