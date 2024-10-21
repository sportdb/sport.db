module CatalogDb
module Metal

class League < Record
    self.tablename = 'leagues'

    self.columns = ['key',
                    'name',
                    'intl',  # international tournament?
                    'clubs', # clubs or national teams?
                    'country_key']


    def self.cache() @cache ||= Hash.new; end


     def self._record( key )  ## use _record! as name - why? why not?
        if (rec = cache[ key ])
          rec   ## return cached
        else  ## query and cache and return
        rows = execute( <<-SQL )
      SELECT #{self.columns.join(', ')}
      FROM leagues
      WHERE leagues.key = '#{key}'
SQL

          ## todo/fix: also assert for rows == 1 AND NOT MULTIPLE records - why? why not?
          if rows.empty?
            raise ArgumentError, "league record with key #{key} not found"
          else
            _build_league( rows[0] )
          end
        end
     end

     def self._build_league( row )
        ## note: cache structs by key (do NOT rebuild duplicates; reuse)
        cache[ row[0] ] ||= Sports::League.new(
                                key: row[0],
                                name: row[1],
                                intl: _to_bool( row[2] ),
                                clubs: _to_bool( row[3] ),
                                country: row[4] ? _to_country( row[4] ) : nil,
                             )
     end

      def self.match_by_code( code,
                               country: nil )
        ## note: match must for now always include name
        ###  todo/fix: allow special normalize formula for
        ##                 code - why? why not?
        ##              e.g. allow ö1 or ö or such - why? why not?
        code = normalize( code )

        rows = nil
        if country.nil?
            ## note: returns empty array if no match and NOT nil
             rows =  execute( <<-SQL )
        SELECT #{self.columns.join(', ')}
        FROM leagues
        INNER JOIN league_codes ON leagues.key  = league_codes.key
        WHERE league_codes.code = '#{code}'
SQL
        else  ## filter by country
          ## note: also skip international leagues & cups (e.g. champions league etc.) for now - why? why not?

          ## note: country assumes / allows the country key or fifa code for now
          ## note: allow passing in of country struct too
          country_rec = _country( country )

          rows = execute( <<-SQL )
          SELECT #{self.columns.join(', ')}
          FROM leagues
          INNER JOIN league_codes ON leagues.key  = league_codes.key
          WHERE league_codes.code = '#{code}' AND
                leagues.country_key = '#{country_rec.key}'

SQL
        end

         ## wrap results array into struct records
         rows.map {|row| _build_league( row )}
      end

      def self.match_by_name( name,
                               country: nil )
        ## note: match must for now always include name
        name = normalize( unaccent(name) )

        rows = nil
        if country.nil?
            ## note: returns empty array if no match and NOT nil
             rows =  execute( <<-SQL )
        SELECT #{self.columns.join(', ')}
        FROM leagues
        INNER JOIN league_names ON leagues.key  = league_names.key
        WHERE league_names.name = '#{name}'
SQL
        else  ## filter by country
          ## note: also skip international leagues & cups (e.g. champions league etc.) for now - why? why not?

          ## note: country assumes / allows the country key or fifa code for now
          ## note: allow passing in of country struct too
          country_rec = _country( country )

          rows = execute( <<-SQL )
          SELECT #{self.columns.join(', ')}
          FROM leagues
          INNER JOIN league_names ON leagues.key  = league_names.key
          WHERE league_names.name = '#{name}' AND
                leagues.country_key = '#{country_rec.key}'

SQL
        end

         ## wrap results array into struct records
         rows.map {|row| _build_league( row )}
      end

     def self.match_by_name_or_code( q,
                               country: nil )
        name = normalize( unaccent(q) )
        code = normalize( q )

        rows = nil
        if country.nil?
            ## note: returns empty array if no match and NOT nil
             rows =  execute( <<-SQL )
        SELECT #{self.columns.join(', ')}
        FROM leagues
        INNER JOIN league_names ON leagues.key  = league_names.key
        WHERE league_names.name = '#{name}'
        UNION
        SELECT #{self.columns.join(', ')}
        FROM leagues
        INNER JOIN league_codes ON leagues.key  = league_codes.key
        WHERE league_codes.code = '#{code}'
SQL
        else  ## filter by country
          ## note: also skip international leagues & cups (e.g. champions league etc.) for now - why? why not?

          ## note: country assumes / allows the country key or fifa code for now
          ## note: allow passing in of country struct too
          country_rec = _country( country )

          rows = execute( <<-SQL )
          SELECT #{self.columns.join(', ')}
          FROM leagues
          INNER JOIN league_names ON leagues.key  = league_names.key
          WHERE league_names.name = '#{name}' AND
                leagues.country_key = '#{country_rec.key}'
          UNION
          SELECT #{self.columns.join(', ')}
          FROM leagues
          INNER JOIN league_codes ON leagues.key  = league_codes.key
          WHERE league_codes.code = '#{code}' AND
                leagues.country_key = '#{country_rec.key}'
SQL
        end

         ## wrap results array into struct records
         rows.map {|row| _build_league( row )}
      end


end  # class League
end  # module Metal
end  # module CatalogDb


