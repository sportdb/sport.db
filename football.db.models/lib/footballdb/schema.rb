
module FootballDb

class CreateDb

def up
 ActiveRecord::Schema.define do

# The following stat tables are specific to football (soccer)
#  Sport-specific stats could be abstracted into their own
#  extensions.

create_table :team_stats do |t|
  t.references  :team,     null: false
  t.references  :game
  t.references  :event

  t.integer     :red_cards
  t.integer     :yellow_cards
  t.integer     :goals_for         # was total_goals
  t.integer     :goals_against     # was goals_conceded
  t.integer     :won               # was wins
  t.integer     :lost              # was losses
  t.integer     :drawn             # was draws

  t.timestamps
end

create_table :player_stats do |t|
  t.references  :person,   null: false
  t.references  :team
  t.references  :game
  t.references  :event

  t.integer     :red_cards
  t.integer     :yellow_cards
  t.integer     :goals_for        # was total_goals
  t.integer     :goals_against    # was goals_conceded
  t.integer     :won              # was wins
  t.integer     :lost             # was losses
  t.integer     :drawn            # was draws
  t.integer     :fouls_suffered
  t.integer     :fouls_committed
  t.integer     :goal_assists
  t.integer     :shots_on_target
  t.integer     :total_shots         ## todo/check - use shots ??
  t.integer     :total_goals            ## todo/check - duplicate ??
  t.integer     :sub_ins
  t.integer     :sub_outs
  t.integer     :starts
  t.integer     :saves
  t.integer     :minutes_played
  t.string      :position

  t.timestamps
end

  end  # Schema.define
end # method up


end # class CreateDb

end # module FootballDb

