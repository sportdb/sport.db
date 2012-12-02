
module SportDB

class CreateDB   ## fix/todo: change to ActiveRecord::Migration why? why not?


## make models available in sportdb module by default with namespace
#  e.g. lets you use Team instead of Models::Team 
  include SportDB::Models


def self.up

  ActiveRecord::Schema.define do


create_table :teams do |t|
  t.string  :title, :null => false
  t.string  :title2
  t.string  :key,   :null => false   # import/export key
  t.string  :code     # make it not null?  - three letter code (short title)
  t.string  :synonyms  # comma separated list of synonyms
  t.references :country,   :null => false
  t.references :city     # NB: city is optional (should be required for clubs e.g. non-national teams)
  t.boolean  :club,     :null => false, :default => false  # is it a club (not a national team)?
  t.boolean  :national, :null => false, :default => false  # is it a national selection team (not a club)?
  t.timestamps
end

add_index :teams, :key, :unique => true


create_table :events do |t|
  t.string      :key,      :null => false   # import/export key
  t.references  :league,   :null => false
  t.references  :season,   :null => false
  t.datetime    :start_at, :null => false
  t.datetime    :end_at   # make it required???
  t.boolean     :team3,    :null => false, :default => true   ## e.g. Champions League has no 3rd place (only 1st and 2nd/final)
  t.timestamps
end

add_index :events, :key, :unique => true 


create_table :rounds do |t|
  t.references :event,    :null => false
  t.string     :title,    :null => false
  t.string     :title2
  t.integer    :pos,      :null => false
  ## add new table stage/stages for grouping rounds in group rounds and playoff rounds, for example???
  ## # "regular" season (group) games or post-season (playoff) knockouts (k.o's)
  t.boolean    :knockout, :null => false, :default => false
  t.datetime   :start_at, :null => false
  t.datetime   :end_at    # todo: make it required e.g. :null => false 
  t.timestamps
end

add_index :rounds, :event_id  # fk event_id index


create_table :groups do |t|     # Teamgruppe (zB Gruppe A, Gruppe B, etc.)
  t.references :event,    :null => false
  t.string     :title,    :null => false
  t.integer    :pos,      :null => false
  t.timestamps
end

add_index :groups, :event_id  # fk event_id index


create_table :games do |t|
  t.references :round,    :null => false
  t.integer    :pos,      :null => false
  t.references :group      # note: group is optional
  t.references :team1,    :null => false
  t.references :team2,    :null => false
  t.datetime   :play_at,  :null => false
  t.boolean    :knockout, :null => false, :default => false
  t.boolean    :home,     :null => false, :default => true    # is team1 play at home (that is, at its home stadium)
  t.integer    :score1
  t.integer    :score2
  t.integer    :score3    # verlaengerung (opt)
  t.integer    :score4
  t.integer    :score5    # elfmeter (opt)
  t.integer    :score6
  t.references :next_game  # for hinspiel bei rueckspiel in knockout game
  t.references :prev_game
  t.string     :toto12x      # 1,2,X,nil  calculate on save
  t.string     :key          # import/export key
  t.timestamps
end

add_index :games, :key, :unique => true 
add_index :games, :round_id      # fk round_id index
add_index :games, :group_id      # fk group_id index
add_index :games, :next_game_id  # fk next_game_id index
add_index :games, :prev_game_id  # fk next_game_id index



# todo: remove id from join table (without extra fields)? why?? why not??
create_table :events_teams do |t|
  t.references :event, :null => false
  t.references :team,  :null => false
  t.timestamps
end

add_index :events_teams, [:event_id,:team_id], :unique => true 
add_index :events_teams, :event_id


create_table :groups_teams do |t|
  t.references :group, :null => false
  t.references :team,  :null => false
  t.timestamps
end

add_index :groups_teams, [:group_id,:team_id], :unique => true 
add_index :groups_teams, :group_id
    
    
### todo: add models and some seed data

create_table :seasons do |t|  ## also used for years
  t.string :key,   :null => false
  t.string :title, :null => false   # e.g. 2011/12, 2012/13 ### what to do w/ 2012? for world cup etc?
  t.timestamps
end

create_table :leagues do |t|  ## also for cups/conferences/tournaments/world series/etc.
  t.string     :key,   :null => false
  t.string     :title, :null => false     # e.g. Premier League, Deutsche Bundesliga, World Cup, Champions League, etc.
  t.references :country   ##  optional for now ,   :null => false   ### todo: create "virtual" country for international leagues e.g. use int? or world (ww?)/europe (eu)/etc. similar? already taken??
  t.boolean    :club,          :null => false, :default => false  # club teams or national teams?
  ## todo: add t.boolean  :national flag? for national teams?
  ## t.boolean  :international, :null => false, :default => false  # national league or international?
  ## t.boolean  :cup     ## or regular season league??
  t.timestamps
end

create_table :badges do |t|
  t.references  :team,  :null => false
  ## todo/fix: use event insead of league+season ??
  ## t.references  :event, :null => false   # event => league+season
  t.references  :league, :null => false
  t.references  :season, :null => false
  t.string      :title, :null => false   # Meister, Weltmeister, Europameister, Cupsieger, Vize-Meister, Aufsteiger, Absteiger, etc.
  t.timestamps
end
       
  end # block Schema.define


  Prop.create!( key: 'db.schema.sport.version', value: SportDB::VERSION )

end # method up

end # class CreateDB

end # module SportDB