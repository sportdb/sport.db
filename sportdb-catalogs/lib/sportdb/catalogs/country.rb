
module CatalogDb
module Metal

class Country  < Record
     self.tablename = 'countries'

     self.columns = ['key', 
                     'name', 
                     'code',
                     'tags',
                     'alt_names']

     def self.cache() @cache ||= Hash.new; end


     def self._record( key )  ## use _record! as name - why? why not?
        if (rec = cache[ key ])
          rec   ## return cached
        else  ## query and cache and return
        rows = execute( <<-SQL )
      SELECT #{self.columns.join(', ')}
      FROM countries 
      WHERE countries.key = '#{key}' 
SQL
 
          ## todo/fix: also assert for rows == 1 AND NOT MULTIPLE records - why? why not?
          if rows.empty? 
            raise ArgumentError, "country record with key #{key} not found" 
          else 
            _build_country( rows[0] )
          end
        end
     end

  
     def self._build_country( row )
        ## note: cache structs by key (do NOT rebuild duplicates; reuse)
        cache[ row[0] ] ||= begin
                              ## note: split tags & alt names (PLUS remove leading//trailing spaces)
                              tags      = row[3].split(',').map {|tag| tag.strip }
                              alt_names = row[4].split('|').map {|alt_name| alt_name.strip } 
                              country = Sports::Country.new(
                                 key: row[0],
                                 name: row[1],
                                 code: row[2],
                                 tags: tags   
                              )
                              country.alt_names = alt_names
                              country
                            end
     end                
                     

  ##  fix/todo: add  find_by (alias for find_by_name/find_by_code)
  def self.find_by_code( code )
   q = code.to_s.downcase   ## allow symbols (and always downcase e.g. AUT to aut etc.)
   
   rows = execute( <<-SQL )
   SELECT #{self.columns.join(', ')}
   FROM countries 
   INNER JOIN country_codes ON countries.key  = country_codes.key
   WHERE country_codes.code = '#{q}' 
SQL
   
     if rows.empty? 
        nil 
     else 
         _build_country( rows[0] )
     end
  end



 def self.find_by_name( name )
   q = normalize( unaccent( name.to_s ))  ## allow symbols too (e.g. use to.s first)
   
   rows = execute( <<-SQL )
   SELECT #{self.columns.join(', ')}
   FROM countries 
   INNER JOIN country_names ON countries.key  = country_names.key
   WHERE country_names.name = '#{q}' 
SQL

     if rows.empty? 
        nil 
     else 
         _build_country( rows[0] )
     end   
 end
end  # class Country
end  # module Metal
end  # module CatalogDb
 