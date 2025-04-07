
module SportDbV2

  class Stats
    include Models

    def tables
      puts "  #{League.count} leagues"
      puts "  #{Event.count} events (league+season recs)"
      puts "  #{Team.count} teams"
      puts "  #{Match.count} matches"
    end

  end  # class Stats

end  # module SportDbV2
