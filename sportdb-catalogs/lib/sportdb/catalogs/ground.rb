module CatalogDb
module Metal

class Ground < Record
    self.tablename = 'grounds'

    self.columns = ['key', 
                    'name', 
                    'alt_names',    #2
                    'city_key',     #3
                    'country_key',  #4
                    'district',     #5
                    'address',      #6
                  ]


    def self._build_ground( row )
        ## note: cache structs by key (do NOT rebuild duplicates; reuse)
        @cache ||= Hash.new
        @cache[ row[0] ] ||= begin 
                                ground = Sports::Ground.new(
                                         key:  row[0],
                                         name: row[1] )
                                
                                if row[2]
                                  alt_names = row[2].split( '|' )
                                  alt_names = alt_names.map { |name| name.strip }
                                  ground.alt_names += alt_names 
                                end
                                ground.city     =  _to_city( row[3] )
                                ground.country  =  _to_country( row[4] )
                                ground.district =  row[5]
                                ground.address  =  row[6]
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

    def self._find_by_name_and_city( name, city )
      rows = execute( <<-SQL )
      SELECT #{self.columns.join(', ')}
      FROM grounds 
      INNER JOIN ground_names ON grounds.key  = ground_names.key
      WHERE ground_names.name = '#{name}' AND 
            grounds.city_key = '#{city}'
SQL
      rows 
    end



  ## match - always returns an array (with one or more matches)
  def self.match_by( name:, 
                     country: nil,
                     city:    nil )
    ## note: allow passing in of country key too (auto-counvert)
    ##       and country struct too
    ##     - country assumes / allows the country key or fifa code for now

    ##  note: ALWAYS unaccent 1st in normalize  
    ##            - add upstream - why? why not?
    # note: returns empty array (e.g. []) if no match and NOT nil
    nameq = normalize( unaccent(name) )

    rows = if country && city.nil?
              country = _country( country )
              countryq = country.key
              _find_by_name_and_country( nameq, countryq )
           elsif city && country.nil?
              city    = _city( city )
              cityq   = city.key 
              _find_by_name_and_city( nameq, cityq )
           elsif city.nil? && country.nil?
             _find_by_name( nameq )
           else
              raise ArgumentError, "unsupported city query params pairs; sorry"
           end
    
    rows.map {|row| _build_ground( row )}
  end
end  # class Ground

end  # module Metal
end  # module CatalogDb

