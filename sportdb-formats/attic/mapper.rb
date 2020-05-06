
  def debug_dump_teams( teams )
    puts "== #{teams.size} teams"
    teams.each do |team|
      print "#{team.key}, "
      print "#{team.title}, "
      print "#{team.synonyms.split('|').join(', ')}"
      puts
    end
  end

