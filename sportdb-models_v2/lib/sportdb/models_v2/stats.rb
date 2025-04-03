
module SportDbV2

  class Stats
    include Models

    def tables
      puts "todo - add table stats here"
=begin
      puts "  #{League.count} leagues  /  #{Season.count} seasons"
      puts "  #{Event.count} events (league+season recs)  /  #{Round.count} rounds  /  #{Group.count} groups  /  #{Stage.count} stages"
      puts "  #{Team.count} teams"
      puts "  #{Match.count} matches"
      puts "  #{Badge.count} badges"

      puts "  #{Lineup.count} lineups (person+team+event recs)"
      puts "  #{Goal.count} goals (person+match recs)"

      puts "  #{Assoc.count}  assocs|orgs"
      puts "  #{Ground.count}  grounds|stadiums"
=end
    end

  end  # class Stats

end  # module SportDbV2
