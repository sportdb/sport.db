
## 3rd party gemss
require 'sportdb/sync'


###
# our own code
require 'sportdb/importers/version' # let version always go first
require 'sportdb/importers/event'
require 'sportdb/importers/match'


module SportDb
class Package
  ## (re)open class - note: adds more machinery; see sportdb-text for first/original/base definition

def read_csv( start: nil )
  ## start - season e.g. 1993/94 to start (skip older seasons)
  ## note: assume package holds country/national (club) league
  #  use for importing german bundesliga, english premier league, etc.

   each_csv { |entry| SportDb.handle_csv( entry, start: start ) }
end # method import

end  # class Package



############
#  add convenience shortcut helper
def self.read_csv( path )
  if File.directory?( path )          ## if directory assume "unzipped" package
    DirPackage.new( path ).read_csv
  elsif File.file?( path ) && File.extname( path ).downcase == '.zip'   ## check if file is a .zip (archive) file
    ZipPackage.new( path ).read_csv
  else                                ## no package; assume single (standalone) datafile
    ## assume single (free-standing) file
    handle_csv( path )
  end
end

##################
### helper
##    move handle_csv somewhere else - why? why not?
def self.handle_csv( source, start: nil )
  ## todo/fix:  (re)use a more generic filter instead of start for start of season only

  ##  todo/fix: use a "generic" filter_season helper for easy reuse
  ##     filter_season( clause, season_key )
  ##   or better filter = SeasonFilter.new( clause )
  ##             filter.skip? filter.include? ( season_sason_key )?
  ##             fiteer.before?( season_key )  etc.
  ##              find some good method names!!!!
  season_start = start ? Season.parse( start ) : nil

  if source.is_a?( Datafile::DirPackage::Entry) ||
     source.is_a?( Datafile::ZipPackage::Entry)
    entry = source

    basename = File.basename( entry.name, File.extname( entry.name ) )  ## get basename WITHOUT extension

    ## check if basename is all numbers (and _-) e.g. 2020.csv or 20.csv etc.
    ##   if yes, assume "mixed" match datafiles (with many/mixed leagues)
    if basename =~ /^[0-9_-]+$/
      pp [entry.name, basename]

      CsvMatchImporter.parse( entry.read )
    else  ## assume "classic" with season
      league_key = basename

      ## todo/fix: check if season_key is proper season - e.g. matches pattern !!!!
      season_q   = File.basename( File.dirname( entry.name ))
      season     = Season.parse( season_q )  ## normalize season
      season_key = season.key

      if season_start && season_start > season
        ## skip if start season before this season
      else
        pp [entry.name, season_key, league_key]

        event = CsvEventImporter.parse( entry.read, league:  league_key,
                                                    season:  season_key )

        puts "added #{event.name} - from source >#{entry.name}<"
        puts "  #{event.teams.size} teams"
        puts "  #{event.matches.size} matches"
        puts "  #{event.rounds.size} rounds"
      end
    end
  else  ## assume (string) filepath for now  - add more options later on!!!!
    ## assume single (free-standing) file
    path = source
    full_path = File.expand_path( path )   ## resolve/make path absolute
    ## 1) assume basename is the league key
    ## 2) assume last directory is the season key

    basename = File.basename( full_path, File.extname( full_path ) )  ## get basename WITHOUT extension
    if basename =~ /^[0-9_-]+$/
      pp [path, basename]
      CsvMatchImporter.read( full_path )
    else ## assume "classic" with season
      ## 1) assume basename is the league key
      ## 2) assume last directory is the season key
      league_key = basename

      season_q   = File.basename( File.dirname( full_path ) )
      season     = Season.parse( season_q )  ## normalize season
      season_key = season.key

      if season_start && season_start > season
        ## skip if start season before this season
      else
        ## todo/fix: check if season_key is proper season - e.g. matches pattern !!!!
        pp [path, season_key, league_key]

        event = CsvEventImporter.read( full_path, league: league_key,
                                                  season: season_key )

        puts "added #{event.name} - from source >#{path}<"
        puts "  #{event.teams.size} teams"
        puts "  #{event.matches.size} matches"
        puts "  #{event.rounds.size} rounds"
      end
    end
  end
end  # method self.handle_csv


end  # module SportDb




puts SportDb::Module::Importers.banner   # say hello
