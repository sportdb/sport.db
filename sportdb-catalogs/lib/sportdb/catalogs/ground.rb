module CatalogDb
module Metal

class Ground < Record
    self.tablename = 'grounds'

    self.columns = ['key', 
                    'name', 
                    'city', 
                    'country_key']

    def self._build_ground( row )
        ## note: cache structs by key (do NOT rebuild duplicates; reuse)
        @cache ||= Hash.new
        @cache[ row[0] ] ||= begin 
                                ground = Sports::Ground.new(
                                         key:  row[0],
                                         name: row[1],
                                         city: row[2] )
                                ## note: country for now NOT supported 
                                ##       via keyword on init!!!
                                ##    fix - why? why not?
                                ground.country = row[3] ? _to_country( row[3] ) : nil
                                ground
                              end                                                     
    end                
 

    def self._find_by_name( name )
        rows = execute( <<-SQL )
        SELECT #{self.columns.join(', ')}
        FROM grounds 
        INNER JOIN ground_names ON grounds.key  = ground_names.key
        WHERE ground_names.name = '#{name}' 
SQL
       rows 
    end

    def self._find_by_name_and_country( name, country )
      rows = execute( <<-SQL )
      SELECT #{self.columns.join(', ')}
      FROM grounds 
      INNER JOIN ground_names ON grounds.key  = ground_names.key
      WHERE ground_names.name = '#{name}' AND 
            grounds.country_key = '#{country}'
SQL
      rows 
    end



  ## match - always returns an array (with one or more matches)
  def self.match_by( name:, 
                     country: nil )
    ## note: allow passing in of country key too (auto-counvert)
    ##       and country struct too
    ##     - country assumes / allows the country key or fifa code for now

    ##  note: ALWAYS unaccent 1st in normalize  
    ##            - add upstream - why? why not?
    # note: returns empty array (e.g. []) if no match and NOT nil
    nameq = normalize( unaccent(name) )

    rows = if country
              country = _country( country )
              countryq = country.key
              _find_by_name_and_country( nameq, countryq )
           else
              _find_by_name( nameq )
           end
    
    rows.map {|row| _build_ground( row )}
  end
end  # class Ground

end  # module Metal
end  # module CatalogDb

