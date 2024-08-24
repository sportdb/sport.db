module CatalogDb
module Metal

class EventInfo < Record
    self.tablename = 'event_infos'

    self.columns = ['league_key',
                    'season',
                    'teams',
                    'matches',
                    'goals',
                    'start_date',
                    'end_date']


     def self._build_event_info( row )
        ## note: cache structs by key (do NOT rebuild duplicates; reuse)
        @cache ||= Hash.new
        ## note cache key MUST be unique!
        ##   use league PLUS season   (row[0] season only will NOT work)
        key = "#{row[0]}_#{row[1]}"
        @cache[ key ] ||= Sports::EventInfo.new(
                                league: _to_league( row[0] ),
                                season: Season.parse(row[1]),
                                teams: row[2],
                                matches: row[3],
                                goals: row[4],
                                start_date: row[5] ? Date.strptime( row[5], '%Y-%m-%d' ) : nil,
                                end_date: row[6]   ? Date.strptime( row[6], '%Y-%m-%d' ) : nil,
                              )
     end


    def self.seasons( league )
      league_key = _league( league ).key

             rows =  execute( <<-SQL )
        SELECT #{self.columns.join(', ')}
        FROM event_infos
        WHERE event_infos.league_key = '#{league_key}'
SQL

         rows.map {|row| _build_event_info( row ) }
    end


    def self.find_by( league:, season: )
      league_key = _league( league ).key
      season_key = season.is_a?( String ) ? Season.parse(season).key
                                          : season.key

             rows =  execute( <<-SQL )
        SELECT #{self.columns.join(', ')}
        FROM event_infos
        WHERE event_infos.league_key = '#{league_key}' AND
              event_infos.season     = '#{season_key}'
SQL

      if rows.empty?
           nil
      elsif rows.size > 1  ## not possible in theory
       puts "** !!! ERROR - expected zero or one rows; got (#{rows.size}):"
       pp rows
       exit 1
      else
         _build_event_info( rows[0] )
      end
    end

end  # class EventInfo
end  # module Metal
end  # module CatalogDb


