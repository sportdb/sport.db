### note: make sure to load latest sportdb/structs !!!  (allow key with numbers!)
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../catalog/lib' ))



require 'sportdb/indexers'


## do NOT use world.db records/references for city
##        use "vanilla" strings!!!
CatalogDb.config.city = false   
pp CatalogDb.config.city?


## set catalog db (required for world search api)
SportDb::Import.config.catalog_path = '../catalog/catalog.db'


COUNTRIES = SportDb::Import.world.countries

pp COUNTRIES.find_by_code( 'a' )
pp COUNTRIES.find_by_code( 'at' )



## use a simpler schema
require_relative 'schema'


module CatalogDb
module ClubDb
  def self.open( path='./clubs.db' )

    ### reuse connect here !!!
    ###   why? why not?

    config = {
        adapter:  'sqlite3',
        database: path,
    }

    ActiveRecord::Base.establish_connection( config )
    # ActiveRecord::Base.logger = Logger.new( STDOUT )

      ## try to speed up sqlite
      ##   see http://www.sqlite.org/pragma.html
      con = ActiveRecord::Base.connection
      con.execute( 'PRAGMA synchronous=OFF;' )
      con.execute( 'PRAGMA journal_mode=OFF;' )
      con.execute( 'PRAGMA temp_store=MEMORY;' )

    ##########################
    ### auto_migrate
    unless Model::Club.table_exists?
        CreateDb.new.up
    end
  end  # method open
end    # module ClubDb
end    # module CatalogDb





CatalogDb::ClubDb.open( './clubs.db' )


#  note: grounds before clubs (clubs may reference grounds!!)
CatalogDb::GroundIndexer.read( '../../../openfootball/clubs' )


CatalogDb::ClubIndexer.read( '../../../openfootball/clubs' )



puts "bye"

