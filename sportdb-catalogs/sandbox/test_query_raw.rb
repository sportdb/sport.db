##
## use "raw" sqlite
##
## see   https://github.com/sparklemotion/sqlite3-ruby
##
##  FAQ - https://github.com/sparklemotion/sqlite3-ruby/blob/main/FAQ.md
##  

require "sqlite3"

# Open a database
db = SQLite3::Database.new( '../catalog/catalog.db' )


pp db.execute( 'SELECT count(*) FROM countries' )
pp db.execute( 'SELECT count(*) FROM country_codes' )
pp db.execute( 'SELECT count(*) FROM country_names' )
pp db.execute( 'SELECT count(*) FROM clubs' )
pp db.execute( 'SELECT count(*) FROM club_names' )


def match_club_by_name( db, name )
    res = db.query( <<-SQL )
       SELECT * 
       FROM club_names 
       INNER JOIN clubs ON club_names.key = clubs.key
       WHERE club_names.name = '#{name}' 
SQL

   puts "meta:"
   pp res.columns
   pp res.types

   ## res.result
   res
end

pp match_club_by_name( db, 'arsenal' )
puts
pp match_club_by_name( db, 'liverpool' )


puts "bye"