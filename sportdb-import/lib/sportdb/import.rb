# encoding: utf-8


## 3rd party gemss
require 'sportdb/text'
require 'sportdb/sync'


###
# our own code    - todo/fix/check: rename to sportdb-importer - why? why not?
require 'sportdb/import/version' # let version always go first
require 'sportdb/import/import'


class CsvPackage
  ## (re)open class - note: adds more machinery; see sportdb-text for first/original/base definition

def import( start: nil )
  ## start - season e.g. 1993/94 to start (skip older seasons)
  ## note: assume package holds country/national (club) league
  #  use for importing german bundesliga, english premier league, etc.

  entries = find_entries_by_season
  pp entries

  entries.each_with_index do |(season_key, datafiles),i|

    puts "season [#{i+1}] >#{season_key}<:"

    ##  todo/fix: use a "generic" filter_season helper for easy reuse
    ##     filter_season( clause, season_key )
    ##   or better filter = SeasonFilter.new( clause )
    ##             filter.skip? filter.include? ( season_sason_key )?
    ##             fiteer.before?( season_key )  etc.
    ##              find some good method names!!!!
    if start
      start_year        = start[0..3].to_i
      season_start_year = season_key[0..3].to_i
      if season_start_year < start_year
        puts "skip #{season_start_year} before #{start_year}"
        next
      end
    end

    datafiles.each do |datafile,j|
      path = expand_path( datafile )
      ## note: assume datafile basename (without extension) is the league key
      ##  e.g. eng.1, eng.3a, eng.3b, at.1, champs, world, etc.
      league_key = File.basename( datafile, File.extname( datafile ) )  ## get basename WITHOUT extension

      pp [path, season_key, league_key]

      event = CsvEventImporter.read( path, league:  league_key,
                                           season:  season_key )

      puts "added #{event.title}"
      puts "  #{event.teams.size} teams"
      puts "  #{event.rounds.size} rounds"
      puts "  #{event.games.size} games"
    end  # each datafile
  end # each season
end # method import

end  # class CsvPackage



puts SportDb::Import.banner   # say hello
