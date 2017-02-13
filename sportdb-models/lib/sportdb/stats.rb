
module SportDb
  
  class Stats
    include Models

    def tables
      puts "  #{League.count} leagues  /  #{Season.count} seasons"
      puts "  #{Event.count} events (league+season recs)  /  #{Round.count} rounds  /  #{Group.count} groups"
      puts "  #{Team.count} teams"
      puts "  #{Game.count} games"
      puts "  #{Badge.count} badges"

      puts "  #{Roster.count} rosters (person+team+event recs)"
      puts "  #{Goal.count} goals (person+game recs)"

      puts "  #{Assoc.count}  assocs|orgs"
      puts "  #{Ground.count}  grounds|stadiums"

## note: moved to racing.db  -- remove/delete!!
##      puts "  #{Track.count} tracks / #{Race.count} races (track+event recs) / #{Run.count} runs"
##      puts "  #{Record.count} records (race|run+person recs)"
    end

  end  # class Stats

end  # module SportDb
