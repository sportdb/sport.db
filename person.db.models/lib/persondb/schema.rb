# encoding: UTF-8

module PersonDb

class CreateDb

def up
  ActiveRecord::Schema.define do

###########
# use people ? instead of persons (person/persons makes it easier?)

create_table :persons do |t|
  t.string      :key,      null: false   # import/export key
  t.string      :name,     null: false
  t.string      :synonyms  # comma separated list of synonyms
  ### fix: change to alt_names

  t.string      :code       # three letter code (short title)  e.g used for formula1 driver etc.


  ## todo: add gender flag (male/female -man/lady  how?)
  t.date        :born_at     # optional date of birth (birthday)
  ## todo: add country of birth  might not be the same as nationality

  t.references  :city
  t.references  :state
  t.references  :country      ## ,  null: false

  t.references  :nationality  ## , null: false  # by default assume same as country of birth (see above)
## fix: add nationality2 n nationality3 too

  t.timestamps
end


  end  # Schema.define
end # method up

end # class CreateDb

end # module PersonDb



=begin
# old (original) sportdb persons table
create_table :persons do |t|    # use people ? instead of persons (person/persons makes it easier?)
  t.string      :key,      null: false   # import/export key
  t.string      :name,     null: false
  t.string      :synonyms  # comma separated list of synonyms
  t.string      :code       # three letter code (short title)

  ## todo: add gender flag (male/female -man/lady  how?)
  t.date        :born_at     # optional date of birth (birthday)
  ## todo: add country of birth  might not be the same as nationality

  t.references  :city
  t.references  :region
  t.references  :country,   null: false

  t.references  :nationality, null: false  # by default assume same as country of birth (see above)

  t.timestamps
end
=end
