
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


## note - allow sames codes for leagues - why? why not?
##              e.g. en.1 (for premier league and first division??)
create_table :league_codes, id: false do |t|
  t.string :key,  null: false   ## was: ## t.references :country
  t.string :code, null: false     ## normalized (lowercase)

  # t.timestamps  ## (auto)add - why? why not?
end
add_index :league_codes, [:key,:code], unique: true



create_table :league_periods  do |t|
  t.string :key,      null: false    # was t.references :leagues
  t.string :tier_key, null: false     ## change to tier (eng.1, eng.cup, uefa.cl, etc.)
                                     ##    to more generic code

  t.string :name,  null: false
  t.string :qname, null: false   ## qualified name (with prefix/country)
                                 ##   English Premier Leauge etc.
  t.string :slug,  null: false    ## e.g. 1-premierleague

  ## keep optional prev(ious) name if rename/rebranding
  t.string :prev_name   ## e.g. Division 1 => Championship etc.

  t.string :start_season
  t.string :end_season
end


create_table :league_period_names, id: false do |t|
  t.integer :league_period_id, null: false

  t.string :name, null: false     ## normalized (lowercase)!!!

  ## e.g. encode 1998/99  to 199807 for start
  ##                      to 199906 for end !!!
  ##      encode 1998     to 199901 for start
  ##                      to 199912 for end !!!
  t.integer :start_yyyymm, null: false, default: 0     ## eg. 000000
  t.integer :end_yyyymm,   null: false, default: 999999
  # t.timestamps  ## (auto)add - why? why not?
  #  do NOT use; save space for now - auto-generated db is read-only
end


## note - allow sames codes for leagues - why? why not?
##              e.g. en.1 (for premier league and first division??)
create_table :league_period_codes, id: false do |t|
  t.integer :league_period_id, null: false

  t.string :code, null: false     ## normalized (lowercase)

  t.integer :start_yyyymm, null: false, default: 0     ## eg. 000000
  t.integer :end_yyyymm,   null: false, default: 999999

  # t.timestamps  ## (auto)add - why? why not?
end



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
