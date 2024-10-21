module CatalogDb
module Metal

class LeaguePeriod < Record
    self.tablename = 'league_periods'

    self.columns = ['id',
                    'key',   ## league foreign refkey!!!
                    'tier_key',   ## change to code - why? why not?
                    'name',
                    'qname',
                    'slug',
                    'start_season',
                    'end_season']


    def self.cache() @cache ||= Hash.new; end


     def self._record( id )  ## use _record! as name - why? why not?
        if (rec = cache[ id ])
          rec   ## return cached
        else  ## query and cache and return
        rows = execute( <<-SQL )
      SELECT #{self.columns.join(', ')}
      FROM league_periods
      WHERE leagues_periods.id = #{id}
SQL

          ## todo/fix: also assert for rows == 1 AND NOT MULTIPLE records - why? why not?
          if rows.empty?
            raise ArgumentError, "league period record with id #{id} not found"
          else
            _build_league_period( rows[0] )
          end
        end
     end


     def self._build_league_period( row )
        ## get league record by ky
        ## league = League._record( row[1] )

        ## note: cache structs by key (do NOT rebuild duplicates; reuse)
        cache[ row[0] ] ||= Sports::LeaguePeriod.new(
                                key: row[2],  ## tier key
                                name: row[3],
                                qname: row[4],
                                slug: row[5],
                                start_season: row[6] ? Season.parse( row[6]) : nil,
                                end_season:   row[7] ? Season.parse( row[7]) : nil
                             )
     end


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


      def self.match_by_code( code, season: )
        code = normalize( code )

        season = Season( season )
        start_yyyymm, end_yyyymm = _calc_yyyymm( season )

        rows = nil
            ## note: returns empty array if no match and NOT nil
             rows =  execute( <<-SQL )
        SELECT #{self.columns.join(', ')}
        FROM league_periods
        INNER JOIN league_period_codes ON league_periods.id  = league_period_codes.league_period_id
        WHERE league_period_codes.code = '#{code}' AND
              league_period_codes.start_yyyymm <=  #{start_yyyymm} AND
              league_period_codes.end_yyyymm  >= #{end_yyyymm}
SQL

         ## wrap results array into struct records
         rows.map {|row| _build_league_period( row )}
      end


      def self.match_by_name( name, season: )
        ## note: match must for now always include name
        name = normalize( unaccent(name) )

        season = Season( season )
        start_yyyymm, end_yyyymm = _calc_yyyymm( season )

        rows = nil
            ## note: returns empty array if no match and NOT nil
             rows =  execute( <<-SQL )
        SELECT #{self.columns.join(', ')}
        FROM league_periods
        INNER JOIN league_period_names ON league_periods.id  = league_period_names.league_period_id
        WHERE league_period_names.name = '#{name}'  AND
              league_period_names.start_yyyymm <=  #{start_yyyymm} AND
              league_period_names.end_yyyymm  >= #{end_yyyymm}
SQL

         ## wrap results array into struct records
         rows.map {|row| _build_league_period( row )}
      end


     def self.match_by_name_or_code( q, season: )
        name = normalize( unaccent(q) )
        code = normalize( q )

        season = Season( season )
        start_yyyymm, end_yyyymm = _calc_yyyymm( season )

        rows = nil
            ## note: returns empty array if no match and NOT nil
             rows =  execute( <<-SQL )
        SELECT #{self.columns.join(', ')}
        FROM league_periods
        INNER JOIN league_period_names ON league_periods.id  = league_period_names.league_period_id
        WHERE league_period_names.name = '#{name}'  AND
              league_period_names.start_yyyymm <=  #{start_yyyymm} AND
              league_period_names.end_yyyymm  >= #{end_yyyymm}
        UNION
        SELECT #{self.columns.join(', ')}
        FROM league_periods
        INNER JOIN league_period_codes ON league_periods.id  = league_period_codes.league_period_id
        WHERE league_period_codes.code = '#{code}' AND
              league_period_codes.start_yyyymm <=  #{start_yyyymm} AND
              league_period_codes.end_yyyymm  >= #{end_yyyymm}
SQL

         ## wrap results array into struct records
         rows.map {|row| _build_league_period( row )}
      end

end  # class LeaguePeriod
end  # module Metal
end  # module CatalogDb


