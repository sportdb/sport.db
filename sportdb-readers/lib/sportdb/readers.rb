# encoding: utf-8


require 'sportdb/config'
require 'sportdb/models'   ## add sql database support
require 'sportdb/sync'


###
# our own code
require 'sportdb/readers/version' # let version always go first
require 'sportdb/readers/conf_reader'
require 'sportdb/readers/match_reader'
require 'sportdb/readers/package'




##
##  add convenience shortcut helpers
module SportDb
  def self.read_conf( path, season: nil )  ConfReaderV2.read( path, season: season ); end
  def self.parse_conf( txt, season: nil )  ConfReaderV2.parse( txt, season: season ); end

  ### todo/check: add alias read_matches - why? why not?
  def self.read_match( path, season: nil )  MatchReaderV2.read( path, season: season ); end
  def self.parse_match( txt, season: nil )  MatchReaderV2.parse( txt, season: season ); end

  def self.read_club_props( path )  Import::ClubPropsReader.read( path ); end
  def self.parse_club_props( txt )  Import::ClubPropsReader.parse( txt ); end

  def self.parse_leagues( txt ) recs = Import::LeagueReader.parse( txt ); Import::config.leagues.add( recs ); end
  def self.parse_clubs( txt )   recs = Import::ClubReader.parse( txt ); Import::config.clubs.add( recs ); end


  def self.read( path, season: nil )
    pack = if File.directory?( path )          ## if directory assume "unzipped" package
              DirPackage.new( path )
           elsif File.file?( path ) && Datafile.match_zip( path )  ## check if file is a .zip (archive) file
              ZipPackage.new( path )
           else                                ## no package; assume single (standalone) datafile
             nil
           end

    if pack
       pack.read( season: season )
    else
      if Datafile.match_conf( path )      ## check if datafile matches conf(iguration) naming (e.g. .conf.txt)
        read_conf( path, season: season )
      elsif Datafile.match_club_props( path )
        read_club_props( path )
      else                                ## assume "regular" match datafile
        read_match( path, season: season )
      end
    end
  end  # method read


end # module SportDb



puts SportDb::Readers.banner   # say hello
