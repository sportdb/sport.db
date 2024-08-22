require 'sportdb/formats'
require 'sportdb/catalogs'
require 'sportdb/models'


###
# our own code
require_relative 'readers/version' # let version always go first

## add sync stuff
require_relative 'readers/sync/country'
require_relative 'readers/sync/league'
require_relative 'readers/sync/season'
require_relative 'readers/sync/event'
require_relative 'readers/sync/club'
require_relative 'readers/sync/more'
require_relative 'readers/sync/match'  ## note  - let match sync go last

## add readers & friends
require_relative 'readers/conf_reader'
require_relative 'readers/match_reader'
require_relative 'readers/package'




##
##  add convenience shortcut helpers
module SportDb
  def self.read_conf( path, season: nil )  ConfReader.read( path, season: season ); end
  def self.parse_conf( txt, season: nil )  ConfReader.parse( txt, season: season ); end

  ### todo/check: add alias read_matches - why? why not?
  def self.read_match( path, season: nil )  MatchReader.read( path, season: season ); end
  def self.parse_match( txt, season: nil )  MatchReader.parse( txt, season: season ); end

  def self.read_club_props( path )  Import::ClubPropsReader.read( path ); end
  def self.parse_club_props( txt )  Import::ClubPropsReader.parse( txt ); end

  def self.parse_leagues( txt ) recs = Import::LeagueReader.parse( txt ); Import.catalog.leagues.add( recs ); end
  def self.parse_clubs( txt )   recs = Import::ClubReader.parse( txt );   Import.catalog.clubs.add( recs ); end


  def self.read( path, season: nil )
    pack = if File.directory?( path )          ## if directory assume "unzipped" package
              DirPackage.new( path )
           elsif File.file?( path ) && File.extname( path ) == '.zip'   ## check if file is a .zip (archive) file
              ZipPackage.new( path )
           else                                ## no package; assume single (standalone) datafile
             nil
           end

    if pack
       pack.read( season: season )
    else
      if Package.conf?( path )      ## check if datafile matches conf(iguration) naming (e.g. .conf.txt)
        read_conf( path, season: season )
      elsif Package.club_props?( path )
        read_club_props( path )
      else                                ## assume "regular" match datafile
        read_match( path, season: season )
      end
    end
  end  # method read


end # module SportDb



puts SportDb::Module::Readers.banner   # say hello
