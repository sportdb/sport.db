# encoding: utf-8


require 'sportdb/config'
require 'sportdb/models'   ## add sql database support
require 'sportdb/sync'


###
# our own code
require 'sportdb/readers/version' # let version always go first
require 'sportdb/readers/league_outline_reader'
require 'sportdb/readers/conf_reader'
require 'sportdb/readers/conf_linter'
require 'sportdb/readers/match_reader'
require 'sportdb/readers/match_linter'
require 'sportdb/readers/package'




##
##  add convenience shortcut helpers
module SportDb

  ## note: sync is dry run (for lint checking)
  def self.read_conf( path, season: nil, sync: true )
    sync ? ConfReaderV2.read( path, season: season )
         : ConfLinter.read( path, season: season )
  end
  def self.parse_conf( txt, season: nil, sync: true )
    sync ? ConfReaderV2.parse( txt, season: season )
         : ConfLinter.parse( txt, season: season )
  end

  def self.read_match( path, season: nil, sync: true )  ### todo/check: add alias read_matches - why? why not?
    sync ? MatchReaderV2.read( path, season: season )
         : MatchLinter.read( path, season: season )
  end
  def self.parse_match( txt, season: nil, sync: true )  ### todo/check: add alias read_matches - why? why not?
    sync ? MatchReaderV2.parse( txt, season: season )
         : MatchLinter.parse( txt, season: season )
  end

  def self.read_club_props( path, sync: true )
    ## note: for now run only if sync (e.g. run with db updates)
    SportDb::Import::ClubPropsReader.read( path )   if sync
  end
  def self.parse_club_props( txt, sync: true )
    ## note: for now run only if sync (e.g. run with db updates)
    SportDb::Import::ClubPropsReader.parse( txt )   if sync
  end


  def self.parse_leagues( txt )
    recs = SportDb::Import::LeagueReader.parse( txt )
    Import::config.leagues.add( recs )
  end

  def self.parse_clubs( txt )
    recs = SportDb::Import::ClubReader.parse( txt )
    Import::config.clubs.add( recs )
  end


  def self.read( path, season: nil, sync: true )
    pack = if File.directory?( path )          ## if directory assume "unzipped" package
              DirPackage.new( path )
           elsif File.file?( path ) && Datafile.match_zip( path )  ## check if file is a .zip (archive) file
              ZipPackage.new( path )
           else                                ## no package; assume single (standalone) datafile
             nil
           end

    if pack
       pack.read( season: season, sync: sync )
    else
      if Datafile.match_conf( path )      ## check if datafile matches conf(iguration) naming (e.g. .conf.txt)
        read_conf( path, season: season, sync: sync )
      elsif Datafile.match_club_props( path )
        read_club_props( path, sync: sync )
      else                                ## assume "regular" match datafile
        read_match( path, season: season, sync: sync )
      end
    end
  end  # method read



  ## (more) convenience helpers for lint(ing)
  def self.lint( path, season: nil )        read( path, season: season, sync: false ); end
  def self.lint_conf( path, season: nil )   read_conf( path, season: season, sync: false ); end
  def self.lint_match( path, season: nil )  read_match( path, season: season, sync: false ); end

end # module SportDb



puts SportDb::Readers.banner   # say hello
