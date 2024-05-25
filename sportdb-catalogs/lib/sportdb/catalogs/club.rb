module CatalogDb
module Metal

class Club < Record
    self.tablename = 'clubs'

    self.columns = ['key', 
                    'name', 
                    'code', 
                    'country_key']

    def self._build_club( row )
        ## note: cache structs by key (do NOT rebuild duplicates; reuse)
        @cache ||= Hash.new
        @cache[ row[0] ] ||= begin 
                                club = Sports::Club.new(
                                         key:  row[0],
                                         name: row[1],
                                         code: row[2] )
                                ## note: country for now NOT supported 
                                ##       via keyword on init!!!
                                ##    fix - why? why not?
                                club.country = row[3] ? _to_country( row[3] ) : nil
                                club 
                              end   
                                                   
    end                
 

    def self._find_by_name( name )
        rows = execute( <<-SQL )
        SELECT #{self.columns.join(', ')}
        FROM clubs 
        INNER JOIN club_names ON clubs.key  = club_names.key
        WHERE club_names.name = '#{name}' 
SQL
       rows 
    end

    def self._find_by_name_and_country( name, country )
      rows = execute( <<-SQL )
      SELECT #{self.columns.join(', ')}
      FROM clubs 
      INNER JOIN club_names ON clubs.key  = club_names.key
      WHERE club_names.name = '#{name}' AND 
            clubs.country_key = '#{country}'
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
    
    rows.map {|row| _build_club( row )}
  end
end  # class Club

end  # module Metal
end  # module CatalogDb

