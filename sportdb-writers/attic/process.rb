

class Job     ## todo/check: use a module (NOT a class) - why? why not?
  ## note - source expected module/class e.g. Footballdata/Worldfootball e.g.
def self.download( datasets, source: )
  datasets.each_with_index do |dataset,i|
    league  = dataset[0]
    seasons = dataset[1]

    puts "downloading [#{i+1}/#{datasets.size}] #{league}..."
    seasons.each_with_index do |season,j|
      puts "  season [#{j+1}/#{season.size}] #{league} #{season}..."
      source.schedule( league: league,
                       season: season )
    end
  end
end

def self.convert( datasets, source: )
  datasets.each_with_index do |dataset,i|
    league  = dataset[0]
    seasons = dataset[1]

    puts "converting [#{i+1}/#{datasets.size}] #{league}..."
    seasons.each_with_index do |season,j|
      puts "  season [#{j+1}/#{season.size}] #{league} #{season}..."
      source.convert( league: league,
                      season: season )
    end
  end
end
end  # class Job
