# encoding: utf-8


## 3rd party gemss
require 'sportdb/text'
require 'sportdb/sync'


###
# our own code
require 'sportdb/importers/version' # let version always go first
require 'sportdb/importers/import'


module SportDb
class Package
  ## (re)open class - note: adds more machinery; see sportdb-text for first/original/base definition

def read_csv( start: nil )    ### todo/fix - rename to read_csv !!!!!!
  ## start - season e.g. 1993/94 to start (skip older seasons)
  ## note: assume package holds country/national (club) league
  #  use for importing german bundesliga, english premier league, etc.

  match_by_season( format: 'csv', start: start ).each_with_index do |(season_key, entries),i|
    puts "season [#{i+1}] >#{season_key}<:"

    entries.each do |entry,j|
      ## note: assume datafile basename (without extension) is the league key
      ##  e.g. eng.1, eng.3a, eng.3b, at.1, champs, world, etc.
      league_key = File.basename( entry.name, File.extname( entry.name ) )  ## get basename WITHOUT extension

      pp [entry.name, season_key, league_key]

      event = CsvEventImporter.parse( entry.read, league:  league_key,
                                                  season:  season_key )

      puts "added #{event.title} - from source >#{entry.name}<"
      puts "  #{event.teams.size} teams"
      puts "  #{event.rounds.size} rounds"
      puts "  #{event.games.size} games"
    end  # each datafile
  end # each season
end # method import

end  # class ackage


############
#  add convenience shortcut helper
def self.read_csv( path )
  Package.new( path ).read_csv
end

end  # module SportDb





puts SportDb::Module::Importers.banner   # say hello
