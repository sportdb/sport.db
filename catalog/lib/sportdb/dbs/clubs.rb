#############
#
# what's different ?
#   uses string for city (no city table)
#      (not city_key)
#    for clubs & grounds


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


class CreateDb

def up
  ActiveRecord::Schema.define do


####
# club tables
create_table :clubs, id: false do |t|
   t.string :key, null: false
   t.string :name, null: false
   t.string :alt_names
#   t.string :code   -- use code why? why not?

  ##
  ## change country_key to country - why? why not?
  ##   check for confusion in activerecord relation "magic"
  ##    club.country.name  Club.new( country: ) working?
  ##              expecting string or activerecord  record??
  ##
  ## yes, NOT possible results in error/exception
  ##  `raise_on_type_mismatch!': City(#1180) expected,
  ##   got "Marrakesh" which is an instance of String(#140)
  ##   (ActiveRecord::AssociationTypeMismatch)

   t.string :country_key, null: false   # note - required for now!!!

   ## todo/check - how to avoid switch city_key/city_name???
   ##                      find one name - possible? 
   ##                       (sorry, city not working/possible - name of association!!)
   ##   maybe deactive relation with config option
   ##       or use own models -- why? why not?
   t.string :city   ## fix: change to city_name too like in grounds!!!  

   t.string :district
   t.string :address
   t.string :geos
  
   # t.timestamps  ## (auto)add - why? why not?
   #  do NOT use; save space for now - auto-generated db is read-only
end
add_index :clubs, :key,  unique: true  
add_index :clubs, :name, unique: true  ## note: enforce unique canoncial names for now

create_table :club_names, id: false do |t|
  t.string :key,  null: false    # was t.references :club
  t.string :name, null: false     ## normalized (lowercase)!!!

   # t.timestamps  ## (auto)add - why? why not?
   #  do NOT use; save space for now - auto-generated db is read-only
end
add_index :club_names, [:key,:name], unique: true  


####
# ground tables
create_table :grounds, id: false do |t|
  t.string :key,  null: false
  t.string :name, null: false
  t.string :alt_names

  ## change to country ???
  t.string :country_key, null: false   # note - required for now!!!
  t.string :city_name,   null: false   # note - required for now!!!
  t.string :district    ## e.g. city district/neighborhood

  t.string :address     # address line
  t.string :geos        # geo "tree/hierarchy"   Bayern > Oberbayern etc.

  # t.timestamps  ## (auto)add - why? why not?
   #  do NOT use; save space for now - auto-generated db is read-only
end
add_index :grounds, :key, unique: true  
## add_index :grounds, :name, unique: true  ## note: enforce unique canoncial names for now

create_table :ground_names, id: false do |t|
 t.string :key,  null: false    # was t.references :club
 t.string :name, null: false     ## normalized (lowercase)!!!

  # t.timestamps  ## (auto)add - why? why not?
   #  do NOT use; save space for now - auto-generated db is read-only
  end
add_index :ground_names, [:key,:name], unique: true  


  end  # Schema.define
end # method up


end # module ClubDb
end # class CreateDb
end # module CatalogDb
