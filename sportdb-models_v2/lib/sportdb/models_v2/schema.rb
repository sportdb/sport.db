
##  check/todos:
#  for start/end_date 
#    use first/last_date for auto calculation - why? why not?
#


module SportDbV2

class CreateDb

def up
  ActiveRecord::Schema.define do


create_table :leagues do |t|  ## also for cups/conferences/tournaments/world series/etc.
  # t.string     :key,   null: false
  t.string     :name,  null: false     # e.g. Premier League, Deutsche Bundesliga, World Cup, Champions League, etc.
  ## t.string     :alt_names  # comma separated list of alt names / synonyms

  ## t.references :country,       index: false   ##  optional for now    ### todo: create "virtual" country for international leagues e.g. use int? or world (ww?)/europe (eu)/etc. similar? already taken??

  ## fix: rename to :clubs from :club - why? why not?
  ## fix: rename to :intl  from :international - why? why not? shorter? better?
  ## todo/check:  flip clup to league flag? why? why not?
  ## t.boolean    :clubs,    null: false, default: false  # club teams or national teams?
  ## t.boolean    :intl,     null: false, default: false  # national league or international?
  ## t.boolean    :cup,      null: false, default: false  ## or regular season league?? use a tournament type field with enums - why? why not?

  ## t.integer    :level       ## use tier?  e.g. level 1, level 2, etc.

  ## t.integer    :start_year
  ## t.integer    :end_year

  ## todo: add t.boolean  :national flag? for national teams?
  t.timestamps
end
add_index :leagues, :name, unique: true



create_table :teams do |t|
  ## for now only name required


  ## t.string  :key,   null: false   # import/export key
  t.string  :name,  null: false   # "canonical" unique name

  ## t.string  :code       #  three letter code (short name)
  ## t.string  :alt_names  # comma separated list of alt names / synonyms

  ## t.references :country,                index: false
  ## t.references :city,                   index: false # note: city is optional (should be required for clubs e.g. non-national teams)
  ## t.references :district,               index: false # note: optional district (in city)

  ##  todo/check/fix: use team type or such e.g. club/national/etc. - why? why not?
  ###   or remove and add virtual attribute in model instead - why? why not?
  ## t.boolean  :club,     null: false, default: false  # is it a club (not a national team)?
  ## t.boolean  :national, null: false, default: false  # is it a national selection team (not a club)?

  ## todo/fix:  add team reference for a and b team!!!!


  ## t.integer :start_year     # founding year  -fix change to start_year / founded - why? why not?
  ## t.integer :end_year
  ## add more? - start_year2, end_year2 - why? why not?
  #  e.g. founded   = 1946, 2013 (refounded)
  #       dissolved = 1997

  ## t.string  :address
  ## t.string  :web

  ## t.string      :comments

  t.timestamps
end
add_index :teams, :name, unique: true




create_table :events do |t|
  ## t.string      :key,        null: false   # import/export key
  t.references  :league,     null: false, index: false
  t.string      :season,     null: false   ## e.g. 2024/25 or 2024

  t.string      :name    ## ,       null: false   # league name for this season
  
  t.date        :start_date                 # note: only use date (w/o time)
  t.date        :end_date                   # note: only use date (w/o time)

  ## t.integer     :num       ## optional series counter e.g. World Cup No. 2, Bundesliga No. 43 etc. etc.

  ## t.boolean     :team3,    null: false, default: true   ## e.g. Champions League has no 3rd place (only 1st and 2nd/final)
  ## todo: add league/cup flag/flags  or to league itself?
  ##   or add add a tournament type field  - why? why not?

  ## auto-added flag (e.g. start_at n end_at dates got calculated)
  ##  if auto-added flag is false - do NOT auto-update start_at, end_at etc.
  ## t.boolean    :auto, null: false, default: true


  #### track 1-n sources (from repos)  - # todo move to its own table later
  ## NB: relative to event.yml - use mapper to "resolve" to full path w/ repo; use league+season keys
  # t.string      :sources    #  e.g. cup or bl,bl_ii   # NB: for now store all in on string separated by comma
  # t.string      :config  # e.g. cup or bl #  e.g assumes cup.yml, bl.yml etc. for now


  t.timestamps
end
add_index :events, [:league_id, :season], unique: true


## add_index :events, :key, unique: true

# todo: remove id from join table (without extra fields)? why?? why not??
create_table :event_teams do |t|
  t.references :event,  null: false, index: false    ## Note: do NOT auto-add index
  t.references :team,   null: false, index: false    ## Note: do NOT auto-add index
  t.string     :name   ##,   null: false     ## team name in use for this event (season)

  t.timestamps
end
add_index :event_teams, [:event_id, :team_id], unique: true


create_table :event_rounds do |t|
  t.references :event,    null: false, index: false  ## Note: do NOT auto-add index
  t.string     :name,     null: false
  ## t.integer    :pos,      null: false   ## use only for "internal" sort order (defaults to insertion order)

  ## t.integer    :num       ## optional match day/week number
  ## t.string     :key       ## optional match day/week number key (as string)

  ## add new table stage/stages for grouping rounds in group rounds and playoff rounds, for example???
  ## # "regular" season (group) matches or post-season (playoff) knockouts (k.o's)
  ## t.boolean    :knockout, null: false, default: false
  ## todo: add leg  (e.g. leg1, leg2, etc. why? why not?)
  t.date   :start_date   # note: only use date (w/o time)  - fix: change to start_date!!!
  t.date   :end_date     # note: only use date (w/o time)  - fix: change to end_date!!!
  ## t.date   :start_date2  # note: only use date (w/o time)  - fix: change to start_date!!!
  ## t.date   :end_date2    # note: only use date (w/o time)  - fix: change to end_date!!!

  ## add last_date/first-date(auto) - for "real" last and first dates - auto-added - why? why not?

  ## auto-added flag (e.g. start_at n end_at dates got calculated)
  ##  if auto-added flag is false - do NOT auto-update start_at, end_at etc.
  ## t.boolean    :auto, null: false, default: true

  t.timestamps
end
add_index :event_rounds, [:event_id, :name],  unique: true




create_table :matches do |t|
  ## t.string     :key          # import/export key
  t.references :league,   null: false, index: false
  t.string     :season,   null: false


  ## t.integer    :pos,      null: false       ## note: use only for "internal" sort order (defaults to insertion order)
  ## t.integer    :num       ## optional - "event global" match number e.g. World Cup - Match 1, Match 2, etc.

 
  t.references :team1,    null: false, index: false   ## Note: do NOT auto-add index
  t.references :team2,    null: false, index: false   ## Note: do NOT auto-add index

  ## add team1_name and team2_name - for alternative name - why? why not?

  ## event same as league+season - keep - why? why not?
  ##  todo/fix -- use composite key in event ("upstream")!!!! 
  ##                  do NOT duplicate - why? why not? 
  ## t.references :event,    null: false, index: false
  t.references :event_round,      index: false   ## Note: do NOT auto-add index
  
  ## t.references :group,                 index: false   ## Note: do NOT auto-add index  -- group is optional
  ## t.references :stage,                 index: false     # optional - regular seasion / champions round etc.

  ## "inline" helper keys auto-populate for easier "no-join/single-table" queries
  ## t.string    :team1_key
  ## t.string    :team2_key
  ## t.string    :event_key
  ## t.string    :round_key
  ## t.integer   :round_num   ## e.g. 1,2,3 for match day/match week
  ## t.string    :group_key
  ## t.string    :stage_key


  t.date      :date      # optional play date  - todo/fix: split into play_date AND play_time!!!
  ## note:  activerecord(rails) will auto-add date (2000-01-01) to hours/time!!!
  ##   work around - save a string type!!!!
  ##  e.g.  19:00 etc.
  ## t.time      :time
  t.string    :time


  ## t.boolean    :postponed, null: false, default: false
  ## t.date   :date2   # optional old date (when postponed)
  ## t.date   :date3   # optional old date (when postponed twice)

  t.string    :status     ## optional match status  - note: uses UPCASE string constants for now
                          ## e.g. CANCELLED / ABANDONED / REPLAY / AWARDED / POSTPONED / etc.


  ## t.references :ground, index: false    # optional - stadium (lets you get city,region,country,etc)
  ## t.references :city,   index: false    # optional - convenience for ground.city_id ???

  ## change home to neutral - why? why not?
  ## t.boolean    :home,     null: false, default: true    # is team1 play at home or neutral (that is, at its home stadium)
  ## t.boolean    :knockout, null: false, default: false

  t.integer    :score1      ## "generic" score
  t.integer    :score2      ## "generic" score - undetermined - might be a.e.t or full time

  ## add score1_agg  ??
  ##     score2_agg
  t.integer    :score1ht   # half time (45min)
  t.integer    :score2ht  # half time 
  t.integer    :score1ft  # full time (90min)
  t.integer    :score2ft  # full time 

  ## add flag for aet?  (or after sudden death goal/golden goal or such?)
  ##   add score_note or such - why? why not?
  t.integer    :score1et  # extratime (120min) - team 1 
  t.integer    :score2et  # extratime         - team 2 
  t.integer    :score1p   # penalty  - team 1 (opt)
  t.integer    :score2p   # penalty  - team 2 (opt) elfmeter (opt)
  
  ## t.references :next_match, index: false   ## Note: do NOT auto-add index  -- for hinspiel bei rueckspiel in knockout match
  ## t.references :prev_match, index: false   ## Note: do NOT auto-add index

  ## t.integer    :winner      # 1,2,0,nil  calculate on save  - "real" winner (after 90 or extra time or penalty, aggregated first+second leg?)
  ## t.integer    :winner90    # 1,2,0,nil  calculate on save  - winner after 90 mins (or regugular play time depending on sport - add alias or find  a better name!)

  ## t.string     :comments

  t.timestamps
end

=begin
add_index :matches, :key,  unique: true
add_index :matches, :event_id      # fk event_id index
add_index :matches, :round_id      # fk round_id index
add_index :matches, :group_id      # fk group_id index
add_index :matches, :next_match_id  # fk next_match_id index
add_index :matches, :prev_match_id  # fk next_match_id index
add_index :matches, :team1_id
add_index :matches, :team2_id
=end


  end  # Schema.define
end # method up


end # class CreateDb

end # module SportDbV2
