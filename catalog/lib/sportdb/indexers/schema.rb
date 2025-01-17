####
# note - to save space for now do NOT add timestamps
#

module CatalogDb
class CreateDb

def up
  ActiveRecord::Schema.define do



##############
# country tables
  ## note - use id as (alpha) string type (id == key!!!)
create_table :countries, id: false do |t|
  t.string :key,    null: false
  t.string :name,   null: false
  t.string :code,   null: false
  t.string :alt_names
  t.string :tags

  # t.timestamps  ## (auto)add - why? why not?
end

add_index :countries, :key, unique: true


## fix - make join table e.g. without id - why? why not?
create_table :country_codes, id: false do |t|
  t.string :key, null: false   ## was: ## t.references :country
  ## note:  code must be unique (by default) - see index below
  t.string :code, null: false     ## normalized (lowercase)

  # t.timestamps  ## (auto)add - why? why not?
end

add_index :country_codes, :code, unique: true


create_table :country_names, id: false do |t|
  t.string :key, null: false   # was t.references :country
  ## note:  name must be unique (by default) - see index below
  t.string :name, null: false     ## normalized (lowercase)!!!

  # t.timestamps  ## (auto)add - why? why not?
end

add_index :country_names, :name, unique: true


create_table :cities, id: false do |t|
  t.string :key,    null: false
  t.string :name,   null: false
  t.string :alt_names

  t.string :country_key, null: false

  # t.timestamps  ## (auto)add - why? why not?
end

add_index :cities, :key, unique: true

create_table :city_names, id: false do |t|
  t.string :key,  null: false
  t.string :name, null: false     ## normalized (lowercase)!!!

  # t.timestamps  ## (auto)add - why? why not?
end




####
# club tables
create_table :clubs, id: false do |t|
   t.string :key, null: false
   t.string :name, null: false
   t.string :alt_names
   t.string :code

   t.string :country_key, null: false   # note - required for now!!!

   t.string :city
   t.string :district
   t.string :address
   t.string :geos


   # t.timestamps  ## (auto)add - why? why not?
end
add_index :clubs, :key, unique: true
add_index :clubs, :name, unique: true  ## note: enforce unique canoncial names for now

create_table :club_names, id: false do |t|
  t.string :key,  null: false    # was t.references :club
  t.string :name, null: false     ## normalized (lowercase)!!!

  # t.timestamps  ## (auto)add - why? why not?
end
add_index :club_names, [:key,:name], unique: true




####
# national teams tables
create_table :national_teams, id: false do |t|
  t.string :key, null: false
  t.string :name, null: false
  t.string :code, null: false
  t.string :alt_names

  t.string :country_key
  # was t.references :country  ## optional - yes? no? why? why not?

  # t.timestamps  ## (auto)add - why? why not?
end
add_index :national_teams, :key, unique: true
add_index :national_teams, :name, unique: true  ## note: enforce unique canoncial names for now

create_table :national_team_names, id: false do |t|
  t.string :key,  null: false    # was t.references :national_team
  t.string :name, null: false     ## normalized (lowercase)!!!

  # t.timestamps  ## (auto)add - why? why not?
end

## note: national team names (plus codes) MUST be unique for now
##      (no duplicates like in leagues or clubs allowed)!!!
add_index :national_team_names, [:key,:name], unique: true


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
end
add_index :leagues, :key, unique: true


create_table :league_names, id: false do |t|
  t.string :key,  null: false    # was t.references :leagues
  t.string :name, null: false     ## normalized (lowercase)!!!

  # t.timestamps  ## (auto)add - why? why not?
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




create_table :league_periods do |t|
  t.string :key,      null: false    # was t.references :leagues
  t.string :tier_key, null: false     ## change to tier (eng.1, eng.cup, uefa.cl, etc.)
                                     ##    to more generic code

  t.string :name,  null: false
  t.string :qname, null: false   ## qualified name (with prefix/country)
                                 ##   English Premier Leauge etc.
  t.string :slug,  null: false    ## e.g. 1-premierleague

  ## keep optional prev(ious) name
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




################
# more/extra tables
create_table :event_infos, id: false do |t|
  t.string :league_key, null: false    # use t.references :leagues?
  t.string :season,     null: false

  # counts
  t.integer :teams
  t.integer :matches
  t.integer :goals
  # dates
  t.date       :start_date
  t.date       :end_date

  # t.timestamps  ## (auto)add - why? why not?
end
add_index :event_infos, [:league_key,:season], unique: true



####
# ground tables
create_table :grounds, id: false do |t|
  t.string :key,  null: false
  t.string :name, null: false
  t.string :alt_names

  t.string :country_key, null: false   # note - required for now!!!
  t.string :city_key,    null: false   # note - required for now!!!
  t.string :district    ## e.g. city district/neighborhood

  t.string :address     # address line
  t.string :geos        # geo "tree/hierarchy"   Bayern > Oberbayern etc.


  # t.timestamps  ## (auto)add - why? why not?
end
add_index :grounds, :key, unique: true
## add_index :grounds, :name, unique: true  ## note: enforce unique canoncial names for now

create_table :ground_names, id: false do |t|
 t.string :key,  null: false    # was t.references :club
 t.string :name, null: false     ## normalized (lowercase)!!!

 # t.timestamps  ## (auto)add - why? why not?
end
add_index :ground_names, [:key,:name], unique: true


  end  # Schema.define
end # method up

end # class CreateDb
end # module CatalogDb
