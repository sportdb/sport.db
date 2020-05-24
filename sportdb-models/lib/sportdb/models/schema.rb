
module SportDb

class CreateDb

def up
  ActiveRecord::Schema.define do

create_table :teams do |t|
  t.string  :key,   null: false   # import/export key
  t.string  :name,  null: false   # "canonical" unique name

  t.string  :code       #  three letter code (short name)
  t.string  :alt_names  # comma separated list of alt names / synonyms

  t.references :country,   null: false, index: false
  t.references :city,                   index: false # note: city is optional (should be required for clubs e.g. non-national teams)
  t.references :district,               index: false # note: optional district (in city)

  ##  todo/check/fix: use team type or such e.g. club/national/etc. - why? why not?
  ###   or remove and add virtual attribute in model instead - why? why not?
  t.boolean  :club,     null: false, default: false  # is it a club (not a national team)?
  t.boolean  :national, null: false, default: false  # is it a national selection team (not a club)?

  ## todo/fix:  add team reference for a and b team!!!!


  t.integer :start_year     # founding year  -fix change to start_year / founded - why? why not?
  t.integer :end_year
  ## add more? - start_year2, end_year2 - why? why not?
  #  e.g. founded   = 1946, 2013 (refounded)
  #       dissolved = 1997

  t.string  :address
  t.string  :web

  ## todo/fix: change to gov / governing body or such!!!
  t.references :assoc,   index: false   # optional: national football assoc(iation), for example - used for national teams

  t.string      :comments

  t.timestamps
end

add_index :teams, :key, unique: true


###########
# check: use table (rename to) venues / stadiums - why? why not?
create_table :grounds do |t|
  t.string     :key,      null: false   # import/export key
  t.string     :name,     null: false
  t.string     :alt_names    # comma separated list of alt_names / synonyms

  t.references :country,  null: false,    index: false
  t.references :city,                     index: false # todo: make city required ???
  t.references :district,                 index: false # note: optional district (in city)

  t.integer :start_year     # founding year
  t.integer :capacity       # attentence capacity e.g. 10_000 or 50_000 etc.
  t.string  :address

  ### fix/todo: add since/founded/opened/build attrib  eg. 2011 or 1987
  ##   - add capacity e.g. 40_000
  ##  fix: add address !!!! etc

  ## add region ??? or just use region from city ??

  t.timestamps
end

add_index :grounds, :key, unique: true


# join table: person+match(team1+team2+event(season+league))
create_table :goals do |t|
  t.references  :person,   null: false,  index: false
  t.references  :match,    null: false,  index: false
  t.references  :team,     null: false,  index: false     ##  use integer instead w/ values 1 or 2  for team1 or team2 ?? why? why not?

  t.integer   :minute
  t.integer   :offset,  null: false, default: 0    # e.g. 45' +3 or 90' +2

  t.integer   :score1
  t.integer   :score2

  ## type of goal (penalty, owngoal)
  t.boolean   :penalty,   null: false, default: false
  t.boolean   :owngoal,   null: false, default: false  # de: Eigentor -> # todo: find better name?

  t.timestamps
end


# join table -> person+team+event(season+league)
create_table :lineups do |t|   # use squads as an alternative name? why? why not??
  t.references :person,  null: false,   index: false
  t.references :team,    null: false,   index: false
  t.references :event               ,   index: false # make required?
  t.integer    :num,     # optional - jersey (t-shirt) number

  t.timestamps
end


create_table :events do |t|
  t.string      :key,        null: false   # import/export key
  t.references  :league,     null: false, index: false
  t.references  :season,     null: false, index: false
  t.date        :start_date, null: false    # note: only use date (w/o time)
  t.date        :end_date                   # note: only use date (w/o time)

  t.integer     :num       ## optional series counter e.g. World Cup No. 2, Bundesliga No. 43 etc. etc.

  ## t.boolean     :team3,    null: false, default: true   ## e.g. Champions League has no 3rd place (only 1st and 2nd/final)
  ## todo: add league/cup flag/flags  or to league itself?
  ##   or add add a tournament type field  - why? why not?

  ## auto-added flag (e.g. start_at n end_at dates got calculated)
  ##  if auto-added flag is false - do NOT auto-update start_at, end_at etc.
  t.boolean    :auto, null: false, default: true


  #### track 1-n sources (from repos)  - # todo move to its own table later
  ## NB: relative to event.yml - use mapper to "resolve" to full path w/ repo; use league+season keys
  # t.string      :sources    #  e.g. cup or bl,bl_ii   # NB: for now store all in on string separated by comma
  # t.string      :config  # e.g. cup or bl #  e.g assumes cup.yml, bl.yml etc. for now


  t.timestamps
end

add_index :events, :key, unique: true


create_table :rounds do |t|
  t.references :event,    null: false, index: false  ## Note: do NOT auto-add index
  t.string     :name,     null: false
  t.integer    :pos,      null: false   ## use only for "internal" sort order (defaults to insertion order)

  t.integer    :num       ## optional match day/week number
  t.string     :key       ## optional match day/week number key (as string)

  ## add new table stage/stages for grouping rounds in group rounds and playoff rounds, for example???
  ## # "regular" season (group) matches or post-season (playoff) knockouts (k.o's)
  t.boolean    :knockout, null: false, default: false
  ## todo: add leg  (e.g. leg1, leg2, etc. why? why not?)
  t.date   :start_date   # note: only use date (w/o time)  - fix: change to start_date!!!
  t.date   :end_date     # note: only use date (w/o time)  - fix: change to end_date!!!
  t.date   :start_date2  # note: only use date (w/o time)  - fix: change to start_date!!!
  t.date   :end_date2    # note: only use date (w/o time)  - fix: change to end_date!!!

  ## add last_date/first-date(auto) - for "real" last and first dates - auto-added - why? why not?

  ## auto-added flag (e.g. start_at n end_at dates got calculated)
  ##  if auto-added flag is false - do NOT auto-update start_at, end_at etc.
  t.boolean    :auto, null: false, default: true

  t.timestamps
end

add_index :rounds, :event_id  # fk event_id index


create_table :groups do |t|     # Teamgruppe (zB Gruppe A, Gruppe B, etc.)
  t.references :event,    null: false, index: false    ## Note: do NOT auto-add index
  t.string     :name,     null: false
  t.integer    :pos,      null: false       ## use only for "internal" sort order (defaults to insertion order)

  t.string     :key       ## optional group key e.g. A, B, C or 1, 2, etc. - use why? why not?
  t.timestamps
end

add_index :groups, :event_id  # fk event_id index


create_table :stages do |t|     # e.g. regular season, champions round, etc.
  t.references :event,    null: false, index: false    ## Note: do NOT auto-add index
  t.string     :name,     null: false
  ## todo/check: add pos for use only for "internal" sort order (defaults to insertion order)??
  t.timestamps
end

add_index :stages, :event_id  # fk event_id index



create_table :matches do |t|
  t.string     :key          # import/export key
  t.references :event,    null: false, index: false
  t.integer    :pos,      null: false       ## note: use only for "internal" sort order (defaults to insertion order)
  t.integer    :num       ## optional - "event global" match number e.g. World Cup - Match 1, Match 2, etc.
  t.references :team1,    null: false, index: false   ## Note: do NOT auto-add index
  t.references :team2,    null: false, index: false   ## Note: do NOT auto-add index

  t.references :round,                 index: false   ## Note: do NOT auto-add index
  t.references :group,                 index: false   ## Note: do NOT auto-add index  -- group is optional
  t.references :stage,                 index: false     # optional - regular seasion / champions round etc.

  ## "inline" helper keys auto-populate for easier "no-join/single-table" queries
  t.string    :team1_key
  t.string    :team2_key
  t.string    :event_key
  t.string    :round_key
  t.integer   :round_num   ## e.g. 1,2,3 for match day/match week
  t.string    :group_key
  t.string    :stage_key


  t.date      :date      # optioanl play date  - todo/fix: split into play_date AND play_time!!!
  t.time      :time

  t.boolean    :postponed, null: false, default: false
  ## t.date   :date2   # optional old date (when postponed)
  ## t.date   :date3   # optional odl date (when postponed twice)

  t.references :ground, index: false    # optional - stadium (lets you get city,region,country,etc)
  t.references :city,   index: false    # optional - convenience for ground.city_id ???

  ## change home to neutral - why? why not?
  t.boolean    :home,     null: false, default: true    # is team1 play at home or neutral (that is, at its home stadium)
  t.boolean    :knockout, null: false, default: false

  t.integer    :score1
  t.integer    :score2
  t.integer    :score1et  # extratime - team 1 (opt)
  t.integer    :score2et  # extratime - team 2 (opt)
  t.integer    :score1p   # penalty  - team 1 (opt)
  t.integer    :score2p   # penalty  - team 2 (opt) elfmeter (opt)
  t.integer    :score1i   # half time / first third (opt)
  t.integer    :score2i   # half time - team 2
  t.integer    :score1ii  # second third (opt)
  t.integer    :score2ii  # second third - team2 (opt)
  t.references :next_match, index: false   ## Note: do NOT auto-add index  -- for hinspiel bei rueckspiel in knockout match
  t.references :prev_match, index: false   ## Note: do NOT auto-add index

  t.integer    :winner      # 1,2,0,nil  calculate on save  - "real" winner (after 90 or extra time or penalty, aggregated first+second leg?)
  t.integer    :winner90    # 1,2,0,nil  calculate on save  - winner after 90 mins (or regugular play time depending on sport - add alias or find  a better name!)

  t.string     :comments

  t.timestamps
end

add_index :matches, :key,  unique: true
add_index :matches, :event_id      # fk event_id index
add_index :matches, :round_id      # fk round_id index
add_index :matches, :group_id      # fk group_id index
add_index :matches, :next_match_id  # fk next_match_id index
add_index :matches, :prev_match_id  # fk next_match_id index
add_index :matches, :team1_id
add_index :matches, :team2_id


# todo: remove id from join table (without extra fields)? why?? why not??
create_table :events_teams do |t|
  t.references :event, null: false, index: false    ## Note: do NOT auto-add index
  t.references :team,  null: false, index: false    ## Note: do NOT auto-add index
  t.timestamps
end

add_index :events_teams, [:event_id, :team_id], unique: true
add_index :events_teams, :event_id


# todo: remove id from join table (without extra fields)? why?? why not??
create_table :stages_teams do |t|
  t.references :stage, null: false, index: false    ## Note: do NOT auto-add index
  t.references :team,  null: false, index: false    ## Note: do NOT auto-add index
  t.timestamps
end

add_index :stages_teams, [:stage_id, :team_id], unique: true
add_index :stages_teams, :stage_id



# todo: remove id from join table (without extra fields)? why?? why not??
create_table :events_grounds do |t|
  t.references :event,   null: false, index: false    ## Note: do NOT auto-add index
  t.references :ground,  null: false, index: false    ## Note: do NOT auto-add index
  t.timestamps
end

add_index :events_grounds, [:event_id, :ground_id], unique: true
add_index :events_grounds, :event_id



create_table :groups_teams do |t|
  t.references :group, null: false, index: false    ## Note: do NOT auto-add index
  t.references :team,  null: false, index: false    ## Note: do NOT auto-add index
  t.timestamps
end

add_index :groups_teams, [:group_id, :team_id], unique: true
add_index :groups_teams, :group_id


### todo: add models and some seed data

create_table :seasons do |t|  ## also used for years - add a boolean year true/false flag too - why? why not?
  t.string :key,   null: false
  t.string :name,  null: false   # e.g. 2011/12, 2012/13 ### what to do w/ 2012? for world cup etc?
  t.timestamps
end


create_table :leagues do |t|  ## also for cups/conferences/tournaments/world series/etc.
  t.string     :key,   null: false
  t.string     :name,  null: false     # e.g. Premier League, Deutsche Bundesliga, World Cup, Champions League, etc.
  t.string     :alt_names  # comma separated list of alt names / synonyms

  t.references :country,       index: false   ##  optional for now    ### todo: create "virtual" country for international leagues e.g. use int? or world (ww?)/europe (eu)/etc. similar? already taken??

  ## fix: rename to :clubs from :club - why? why not?
  ## fix: rename to :intl  from :international - why? why not? shorter? better?
  ## todo/check:  flip clup to league flag? why? why not?
  t.boolean    :clubs,    null: false, default: false  # club teams or national teams?
  t.boolean    :intl,     null: false, default: false  # national league or international?
  t.boolean    :cup,      null: false, default: false  ## or regular season league?? use a tournament type field with enums - why? why not?

  t.integer    :level       ## use tier?  e.g. level 1, level 2, etc.

  t.integer    :start_year
  t.integer    :end_year

  ## todo: add t.boolean  :national flag? for national teams?
  t.timestamps
end


create_table :badges do |t|
  t.references  :team,  null: false,    index: false
  ## todo/fix: use event insead of league+season ??
  ## t.references  :event, :null => false   # event => league+season
  t.references  :league, null: false,   index: false
  t.references  :season, null: false,   index: false
  t.string      :name,   null: false   # Meister, Weltmeister, Europameister, Cupsieger, Vize-Meister, Aufsteiger, Absteiger, etc.
  t.timestamps
end


create_table :assocs do |t|
  t.string     :key,   null: false
  t.string     :name,  null: false     # e.g. Premier League, Deutsche Bundesliga, World Cup, Champions League, etc.

  t.integer    :start_year     # founding year
  t.string     :web

  ### if national assoc - has (optional) country ref
  t.references :country,       index: false   # note: optional - only used/set (required) for national assocs (or subnational too?)
  t.boolean    :national,    null: false, default: false

  ## add :world flag for FIFA? - just check if parent is null? for root assoc(s)? why? why not?
  ## add :regional flag for continental subdivision?
  ##  todo: shorten to contl and intercontl  - why? why not?
  t.boolean :continental,      null: false, default: false
  t.boolean :intercontinental, null: false, default: false  # e.g. arab football league (africa+western asia/middle east)
  t.timestamps
end

add_index :assocs, :key, unique: true



create_table :assocs_assocs do |t|
  t.references :assoc1, null: false, index: false   ## Note: do NOT auto-add index  -- parent assoc
  t.references :assoc2, null: false, index: false   ## Note: do NOT auto-add index  -- child assoc is_member_of parent assoc
  t.timestamps
end

add_index :assocs_assocs, [:assoc1_id,:assoc2_id], unique: true
add_index :assocs_assocs, :assoc1_id
add_index :assocs_assocs, :assoc2_id



############################################
# stats tables

# use tables for standings e.g group_tables? - why? why not?
#
# todo: add group_standings per round with pos diffs e.g +1,+2, -3 etc.

create_table :group_standings do |t|
  t.references  :group,    null: false,  index: false
  t.timestamps
end

### use items or lines instead of entries - why (shorter! simple plural e.g. just add s)
##  use group_table_lines/stats  - why? why not?

create_table :group_standing_entries do |t|
  t.references  :group_standing,  null: false, index: false
  t.references  :team,            null: false, index: false
  t.integer     :pos       # check/todo: use rank? -- keep/use pos only for "internal" insertation order only - why? why not?
  t.integer     :played   ## p/pld
  t.integer     :won      ## w
  t.integer     :lost     ## l
  t.integer     :drawn    ## d  or t/tied ??
  t.integer     :goals_for             # todo: find a short name - gf? why? why not?
  t.integer     :goals_against         # todo: find a shorter name - ga? why? why not?
  t.integer     :pts
  t.string      :comments
  t.timestamps
end


create_table :event_standings do |t|
  t.references  :event,   null: false, index: false
  t.timestamps
end

create_table :event_standing_entries do |t|
  t.references  :event_standing,  null: false, index: false
  t.references  :team,            null: false, index: false
  t.integer     :pos
  t.integer     :played
  t.integer     :won
  t.integer     :lost
  t.integer     :drawn
  t.integer     :goals_for             # todo: find a short name - gf? or for? why? why not?
  t.integer     :goals_against         # todo: find a shorter name - ga? or against? why? why not?
  t.integer     :pts
  t.string      :comments
  t.timestamps
end


## flex (free-style/form) standings table - lets you add as many events as you like (not bound to single event/season/etc.)
##  -use (find a better) a different name? why? why not?
create_table :alltime_standings do |t|
  t.string    :key,   null: false
  t.string    :name,  null: false
  t.timestamps
end

create_table :alltime_standing_entries do |t|
  t.references  :alltime_standing,  null: false, index: false
  t.references  :team,              null: false, index: false
  t.integer     :pos
  t.integer     :played    # todo: use a different name - why? why not?
  t.integer     :won
  t.integer     :lost
  t.integer     :drawn
  t.integer     :goals_for             # todo: find a short name - gf? why? why not?
  t.integer     :goals_against         # todo: find a shorter name - ga? why? why not?
  t.integer     :pts
  t.integer     :recs               # note: specific to alltime - stats records counter (e.g. appearance counter) - find a better name - why? why not?
  t.string      :comments
  t.timestamps
end


  end  # Schema.define
end # method up


end # class CreateDb

end # module SportDb
