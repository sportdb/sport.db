# encoding: utf-8


## 3rd party gemss
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

      puts "added #{event.name} - from source >#{entry.name}<"
      puts "  #{event.teams.size} teams"
      puts "  #{event.matches.size} matches"
      puts "  #{event.rounds.size} rounds"
    end  # each datafile
  end # each season
end # method import

end  # class Package



############
#  add convenience shortcut helper
def self.read_csv( path )
  if File.directory?( path )          ## if directory assume "unzipped" package
    DirPackage.new( path ).read_csv
  elsif File.file?( path ) && File.extname( path ) == '.zip'   ## check if file is a .zip (archive) file
    ZipPackage.new( path ).read_csv
  else                                ## no package; assume single (standalone) datafile
    ## assume single (free-standing) file
    full_path = File.expand_path( path )   ## resolve/make path absolute
    ## 1) assume basename is the league key
    ## 2) assume last directory is the season key
    league_key = File.basename( full_path, File.extname( full_path ) )  ## get basename WITHOUT extension
    season_key = File.basename( File.dirname( full_path ) )

    event = CsvEventImporter.read( full_path, league: league_key,
                                              season: season_key )

    puts "added #{event.name} - from source >#{path}<"
    puts "  #{event.teams.size} teams"
    puts "  #{event.matches.size} matches"
    puts "  #{event.rounds.size} rounds"
  end
end
end  # module SportDb




puts SportDb::Module::Importers.banner   # say hello
