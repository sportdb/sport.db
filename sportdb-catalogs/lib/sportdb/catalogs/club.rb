module CatalogDb
module Metal

class Club < Record
    self.tablename = 'clubs'

    self.columns = ['key', 
                    'name', 
                    'code', 
                    'city',   #3 
                    'district', #4
                    'country_key',  #5
                  ]

    def self._build_club( row )
        ## note: cache structs by key (do NOT rebuild duplicates; reuse)
        @cache ||= Hash.new
        @cache[ row[0] ] ||= begin 
                                club = Sports::Club.new(
                                         key:  row[0],
                                         name: row[1],
                                         code: row[2] )

                                club.city     = row[3]  ## might be nil
                                club.district = row[4]  
                                ## note: country for now NOT supported 
                                ##       via keyword on init!!!
                                ##    fix - why? why not?
                                club.country = row[5] ? _to_country( row[5] ) : nil
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


    def self._find_by_name_and_country( name, country_or_countries )
          sql = <<-SQL
      SELECT #{self.columns.join(', ')}
      FROM clubs 
      INNER JOIN club_names ON clubs.key  = club_names.key
      WHERE club_names.name = '#{name}' AND 
SQL
       
        ## check if single country or n countries         
         if country_or_countries.is_a?(Array) 
          countries = country_or_countries
          ## add (single) quotes and join with comma 
          ##       e.g.  'at','de'  
          country_list = countries.map {|country| %Q<'#{country}'>}.join(',')
          sql <<  "clubs.country_key in (#{country_list})\n"
         else ## assume string/symbol (single country key)
          country = country_or_countries
          sql <<  "clubs.country_key = '#{country}'\n"
         end
          
      rows = execute( sql )
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

    ## todo - check for empty array passed in?
    rows = if country    
              ### always wrap country in array
              countries =  country.is_a?(Array) ? country : [country]
              country_keys = countries.map {|country| _country( country ).key }
              ## unwrap key if array with single country key
              countryq = country_keys.size == 1 ? country_keys[0] : country_keys

              _find_by_name_and_country( nameq, countryq )
           else
              _find_by_name( nameq )
           end
    
    rows.map {|row| _build_club( row )}
  end
end  # class Club

end  # module Metal
end  # module CatalogDb

