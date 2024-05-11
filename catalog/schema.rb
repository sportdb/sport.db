
module CatalogDb
class CreateDb

def up
  ActiveRecord::Schema.define do

create_table :countries do |t|
  t.string :key,    null: false
  t.string :name,   null: false
  t.string :code,   null: false
  t.string :alt_names
  t.string :tags 

  t.timestamps  ## (auto)add - why? why not?
end


create_table :country_codes do |t|
  t.references :country
  ## note:  code must be unique (by default) - see index below
  t.string :code, null: false     ## normalized (lowercase)

  t.timestamps  ## (auto)add - why? why not?
end

add_index :country_codes, :code, unique: true




create_table :country_names do |t|
  t.references :country
  ## note:  name must be unique (by default) - see index below
  t.string :name, null: false     ## normalized (lowercase)!!!

  t.timestamps  ## (auto)add - why? why not?
end

add_index :country_names, :name, unique: true


  end  # Schema.define
end # method up

end # class CreateDb
end # module CatalogDb
