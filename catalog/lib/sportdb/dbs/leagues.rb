
module CatalogDb
  module LeagueDb
    def self.open( path='./leagues.db' )

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
      unless Model::League.table_exists?
          CreateDb.new.up
      end
    end  # method open


class CreateDb


  
def up
  ActiveRecord::Schema.define do

####
# league tables
create_table :leagues, id: false do |t|
  t.string :key, null: false
  t.string :name, null: false
  t.string :alt_names

  t.boolean :intl,  null: false, default: false
  t.boolean :clubs, null: false, default: true  

  t.string :country_key

  # t.timestamps  ## (auto)add - why? why not?
  #  do NOT use; save space for now - auto-generated db is read-only
end
add_index :leagues, :key, unique: true  


create_table :league_names, id: false do |t|
  t.string :key,  null: false    # was t.references :leagues
  t.string :name, null: false     ## normalized (lowercase)!!!

  # t.timestamps  ## (auto)add - why? why not?
  #  do NOT use; save space for now - auto-generated db is read-only
end
add_index :league_names, [:key,:name], unique: true  

=begin
################
# more/extra tables
#  todo - add later
create_table :league_seasons, id: false do |t|
  t.string :league_key, null: false    # use t.references :leagues?
  t.string :season,     null: false

  ## add (optinal) stage   
  ## for apertura/clausura-style (opening/closing) "double" seasons
  ##   and make "recursive"
  ##      that is, league_season record may have sub records


  # counts
  t.integer :teams       # e.g. 24 teams
  t.integer :matches     
  t.integer :goals
  # dates
  t.date       :start_date  
  t.date       :end_date    

  #  do NOT use; save space for now - auto-generated db is read-only
  # t.timestamps  ## (auto)add - why? why not?
end
add_index :league_seasons, [:league_key,:season], unique: true  
=end


  end  # Schema.define
end # method up


end # class CreateDb
end # module LeagueDb
end # module CatalogDb
