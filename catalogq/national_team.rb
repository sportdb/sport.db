module CatalogDb
module Metal

class NationalTeam < Record
    self.tablename = 'national_teams'

    self.columns = ['key', 
                    'name', 
                    'code', 
                    'country_key']

     def self._build_national_team( row )
        ## note: cache structs by key (do NOT rebuild duplicates; reuse)
        @cache ||= Hash.new
        @cache[ row[0] ] ||= Sports::NationalTeam.new(
                                key: row[0],
                                name: row[1],
                                code: row[2]   
                             )
     end                

    

  def self.find( q )
    q = normalize( q.to_s )  ## allow symbols too (e.g. use to.s first)
   
    rows = execute( <<-SQL )
    SELECT #{self.columns.join(', ')}
    FROM national_teams 
    INNER JOIN national_team_names ON national_teams.key  = national_team_names.key
    WHERE national_team_names.name = '#{q}' 
 SQL
   rows 
 
      if rows.empty? 
         nil 
      else 
          _build_national_team( rows[0] )
      end   
  end


  def self.find!( q )
    team = find( q )
    if team.nil?
      puts "** !!! ERROR - no match for national team >#{q}< found"
      exit 1
    end
    team
  end
end  # class NationalTeam

end  # module Metal
end  # module CatalogDb
