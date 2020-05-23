
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
    end

  end  # class Stats

end  # module SportDb
