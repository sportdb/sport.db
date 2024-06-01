module CatalogDb
module Metal

class City < Record
    self.tablename = 'cities'

    self.columns = ['key', 
                    'name', 
                    'alt_names', 
                    'country_key',  #3
                  ]

    def self.cache() @cache ||= Hash.new; end

    def self._record( key )  ## use _record! as name - why? why not?
        if (rec = cache[ key ])
          rec   ## return cached
        else  ## query and cache and return
        rows = execute( <<-SQL )
      SELECT #{self.columns.join(', ')}
      FROM cities 
      WHERE cities.key = '#{key}' 
SQL
 
          ## todo/fix: also assert for rows == 1 AND NOT MULTIPLE records - why? why not?
          if rows.empty? 
            raise ArgumentError, "city record with key #{key} not found" 
          else 
            _build_city( rows[0] )
          end
        end
    end

    def self._build_city( row )
        ## note: cache structs by key (do NOT rebuild duplicates; reuse)
        cache[ row[0] ] ||= begin 
                                city = Sports::City.new(
                                         key:     row[0],
                                         name:    row[1],
                                         ## fix - add alt_names here too 
                                         country: _to_country( row[3] ) 
                                       )
                                city
                              end                                                    
    end                
 

    def self._find_by_name( name )
        rows = execute( <<-SQL )
        SELECT #{self.columns.join(', ')}
        FROM cities 
        INNER JOIN city_names ON cities.key  = city_names.key
        WHERE city_names.name = '#{name}' 
SQL
       rows 
    end


  ## match - always returns an array (with one or more matches)
  def self.match_by( name:  )
    ## note: allow passing in of country key too (auto-counvert)
    ##       and country struct too
    ##     - country assumes / allows the country key or fifa code for now

    ##  note: ALWAYS unaccent 1st in normalize  
    ##            - add upstream - why? why not?
    # note: returns empty array (e.g. []) if no match and NOT nil
    nameq = normalize( unaccent(name) )

    rows = _find_by_name( nameq )
           
    rows.map {|row| _build_city( row )}
  end
end  # class City

end  # module Metal
end  # module CatalogDb

