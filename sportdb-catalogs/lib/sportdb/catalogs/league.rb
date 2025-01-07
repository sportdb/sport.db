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


     def self._query_by_code( code: )
      execute( <<-SQL )
      SELECT #{self.columns.join(', ')}
      FROM leagues
      INNER JOIN league_codes ON leagues.key  = league_codes.key
      WHERE league_codes.code = '#{code}'
SQL
     end

     def self._query_by_code_and_country( code:, country: )
      execute( <<-SQL )
      SELECT #{self.columns.join(', ')}
      FROM leagues
      INNER JOIN league_codes ON leagues.key  = league_codes.key
      WHERE league_codes.code = '#{code}' AND
            leagues.country_key = '#{country}'                     
SQL
     end

     def self._query_by_code_and_season( code:, start_yyyymm:,
                                                end_yyyymm: )
       execute( <<-SQL )
       SELECT #{self.columns.join(', ')}
       FROM leagues
       WHERE leagues.key IN 
       (SELECT league_periods.key
        FROM league_periods
        INNER JOIN league_period_codes ON league_periods.id = league_period_codes.league_period_id
        WHERE league_period_codes.code = '#{code}' AND
              league_period_codes.start_yyyymm <=  #{start_yyyymm} AND
              league_period_codes.end_yyyymm  >= #{end_yyyymm}
       )
 SQL
     end 



      def self.match_by_code( code,
                               country: nil,
                               season:  nil )
        ## note: match must for now always include name
        ###  todo/fix: allow special normalize formula for
        ##                 code - why? why not?
        ##              e.g. allow ö1 or ö or such - why? why not?
        code = normalize( code )

   
        rows = if country.nil? && season.nil?
                 ## note: returns empty array if no match and NOT nil
                 _query_by_code( code: code )
               elsif country && season.nil?   ## filter by country
                 ## note: also skip international leagues & cups (e.g. champions league etc.) for now - why? why not?

                  ## note: country assumes / allows the country key or fifa code for now
                  ## note: allow passing in of country struct too
                  country_rec = _country( country )
                  _query_by_code_and_country( code: code, country: country_rec.key )
               elsif season && country.nil?               
                  season = Season( season )
                  start_yyyymm, end_yyyymm = _calc_yyyymm( season )
                  _query_by_code_and_season( code: code, start_yyyymm: start_yyyymm,
                                                         end_yyyymm: end_yyyymm )
               else
                   raise ArgumentError, "match_by_code - code and optional country or season expected"
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



##############################################
#   try match by code and seaons (via league_periods)
##     todo/fix - move up for reuse (duplicated in league_period etc) - why? why not?

     def self._calc_yyyymm( season )
        start_yyyymm =     if season.calendar?
                              "#{season.start_year}01".to_i
                           else
                              "#{season.start_year}07".to_i
                           end

        end_yyyymm   =     if season.calendar?
                              "#{season.end_year}12".to_i
                           else
                              "#{season.end_year}06".to_i
                           end

      [start_yyyymm, end_yyyymm]
      end


end  # class League
end  # module Metal
end  # module CatalogDb


