
module SportDb
  
  class Stats
    include SportDb::Models

    def tables
      puts "Stats:"
      puts "  #{Event.count} events  /  #{Round.count} rounds  /  #{Group.count} groups"
      puts "  #{League.count} leagues  /  #{Season.count} seasons"
      puts "  #{Country.count} countries / #{Region.count} regions / #{City.count} cities"
      puts "  #{Team.count} teams"
      puts "  #{Game.count} games"
      puts "  #{Badge.count} badges"
      
      ## todo: add tags / taggings from worlddb
    end
    
    def props
      puts "Props:"
      Prop.order( 'created_at asc' ).all.each do |prop|
        puts "  #{prop.key} / #{prop.value} || #{prop.created_at}"
      end
    end
  
  end  # class Stats

end  # module SportDb