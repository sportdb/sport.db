
module RacingDb

class CreateDb

def up
  ActiveRecord::Schema.define do


create_table :tracks do |t|    # e.g. Formula 1 circuits or Apline Ski resorts/slops/pistes
  t.string      :key,       null: false   # import/export key
  t.string      :title,     null: false
  t.string      :synonyms   # comma separated list of synonyms
  t.string      :code       # three letter code (short title)

  t.references  :city
  t.references  :region
  t.references  :country,   null: false
  t.timestamps
end


# join table -> event(season+league)+track
create_table :races do |t|     # e.g. Formula 1 race (Grand Prix Monaco) or Alpine Ski race (Downhill Lake Louise)
  t.references :track,    null: false
  t.references :event,    null: false
  t.integer    :pos,      null: false   # Race #1,#2,#3,#4 etc.

  ## todo: add auto-created key (for import/export) e.g.

  t.datetime   :start_at
  t.timestamps
end

create_table :runs do |t|
  t.references :race,     null: false
  t.integer    :pos,      null: false

  t.datetime   :start_at
  t.timestamps
end

# join table -> race+person or run+person
create_table :records do |t|   # use TimeRecord? instead of simple record
 t.references :race  # optional either race or run references
 t.references :run
 t.references :person,  null: false
 t.integer    :pos      # 1,2,3, etc or 0
 t.boolean    :completed,  null: false, default: true    # completed race - find better name?
 t.string     :state   # find a better name? e.g. retired, e.g.
 t.string     :comment  #   find a better name ?  e.g.  collision damage (if ret) for formula 1
 t.time       :time
 t.string     :timeline   # e.g. + 0:45.343   or +1 lap
 t.integer    :laps      # laps counter for formula1

 t.timestamps
end


  end  # Schema.define
end # method up


end # class CreateDb

end # module RacingDb
