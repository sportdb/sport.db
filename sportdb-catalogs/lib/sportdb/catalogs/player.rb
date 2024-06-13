module CatalogDb
module Metal

class Player < PlayerRecord

    ## note - tablename is persons!! (NOT players or even people)
    self.tablename = 'persons'

    self.columns = ['id',           #0
                    'name',         #1
                    'alt_names',    #2
                    'nat',          #3
                    'height',       #4
                    'pos',          #5
                    'birthdate',    #6
                    'birthplace',   #7
                  ]


    ### todo/fix:
    ##   change sqlite config to return records as hash NOT array!!!!
    ##

    def self._build_player( row )
        ## note: cache structs by key (do NOT rebuild duplicates; reuse)
        @cache ||= Hash.new
        @cache[ row[0] ] ||= begin 
                                ## use Sports::Player.new  - why? why not?
                                player = Sports::Player.new(
                                           name:       row[1],
                                           nat:        row[3],
                                           height:     row[4],
                                           pos:        row[5],  ## make pos into an array??
                                           birthdate:  row[6],  ## todo/fix - convert to date??
                                           birthplace: row[7],
                                            )
                                
                                if row[2]
                                  alt_names = row[2].split( '|' )
                                  alt_names = alt_names.map { |name| name.strip }
                                  player.alt_names += alt_names 
                                end
                                player
                              end                                                     
    end                
 

    def self._find_by_name( name )
        rows = execute( <<-SQL )
        SELECT #{self.columns.join(', ')}
        FROM persons 
        INNER JOIN person_names ON persons.id  = person_names.person_id
        WHERE person_names.name = '#{name}' 
SQL
       rows 
    end

    def self._find_by_name_and_country( name, country )
      rows = execute( <<-SQL )
      SELECT #{self.columns.join(', ')}
      FROM persons 
      INNER JOIN person_names ON persons.id  = person_names.person_id
      WHERE person_names.name = '#{name}' AND 
            persons.nat = '#{country}'
SQL
      rows 
    end

    def self._find_by_name_and_year( name, year )
      ## check if there's a date function for year 
      ##  (using integer compare instead of string with qoutes???) 

      rows = execute( <<-SQL )
      SELECT #{self.columns.join(', ')}
      FROM persons 
      INNER JOIN person_names ON persons.id  = person_names.person_id
      WHERE person_names.name = '#{name}' AND 
            strftime('%Y',persons.birthdate) = '#{year}'
SQL
      rows 
    end



  ## match - always returns an array (with one or more matches)
  def self.match_by( name:, 
                     country: nil,
                     year:    nil )
    nameq = normalize( unaccent(name) )

    rows = if country && year.nil?
              country = _country( country )
              countryq = country.key
              _find_by_name_and_country( nameq, countryq )
           elsif year && country.nil?
              _find_by_name_and_year( nameq, year )
           elsif year.nil? && country.nil?
             _find_by_name( nameq )
           else
              raise ArgumentError, "unsupported year query params pairs; sorry"
           end
    
    rows.map {|row| _build_player( row )}
  end
end  # class Player

end  # module Metal
end  # module CatalogDb

