
module SportDb

  class Stats
    include Models

    def tables
      puts "  #{League.count} leagues  /  #{Season.count} seasons"
      puts "  #{Event.count} events (league+season recs)  /  #{Round.count} rounds  /  #{Group.count} groups  /  #{Stage.count} stages"
      puts "  #{Team.count} teams"
      puts "  #{Match.count} matches"
      puts "  #{Badge.count} badges"

      puts "  #{Lineup.count} lineups (person+team+event recs)"
      puts "  #{Goal.count} goals (person+match recs)"

      puts "  #{Assoc.count}  assocs|orgs"
      puts "  #{Ground.count}  grounds|stadiums"
    end

  end  # class Stats

end  # module SportDb
