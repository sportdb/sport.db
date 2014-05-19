
module SportDb
  
  class Stats
    include SportDb::Models

    def tables
      puts "  #{League.count} leagues  /  #{Season.count} seasons"
      puts "  #{Event.count} events (league+season recs)  /  #{Round.count} rounds  /  #{Group.count} groups"
      puts "  #{Team.count} teams"
      puts "  #{Game.count} games"
      puts "  #{Badge.count} badges"

      puts "  #{Track.count} tracks / #{Race.count} races (track+event recs) / #{Run.count} runs"
      puts "  #{Record.count} records (race|run+person recs)"
      puts "  #{Roster.count} rosters (person+team+event recs)"
      puts "  #{Goal.count} goals (person+game recs)"

      puts "  #{Ground.count}  grounds|stadiums"
    end
    
    ## fix/chek:
    #  move to Prop gem / reuse code from Prop gem
    def props
      puts "Props:"
      Prop.order( 'created_at asc' ).all.each do |prop|
        puts "  #{prop.key} / #{prop.value} || #{prop.created_at}"
      end
    end
  
  end  # class Stats

end  # module SportDb