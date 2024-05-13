module CatalogDb
module Metal

class Club < Record
    self.tablename = 'clubs'

    self.columns = ['key', 
                    'name', 
                    'code', 
                    'country_key']


    def self.match_by_name( name )
        rows = execute( <<-SQL )
        SELECT #{self.columns.join(', ')}
        FROM clubs 
        INNER JOIN club_names ON clubs.key  = club_names.key
        WHERE club_names.name = '#{name}' 
SQL
       rows 
    end

end  # class Club
end  # module Metal
end  # module CatalogDb
