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
require 'sportdb/readers/match_parser'
require 'sportdb/readers/match_reader'
require 'sportdb/readers/match_linter'



##
##  add convenience shortcut helpers
module SportDb

  def self.read_conf( path, sync: true, season: nil )    ## note: sync is dry run (for lint checking)
    sync ? ConfReaderV2.read( path, season: season )
         : ConfLinter.read( path, season: season )
  end

  ### todo: add alias read_matches - why? why not?
  def self.read_match( path, sync: true, season: nil )     ## note: sync is dry run (for lint checking)
    sync ? MatchReaderV2.read( path, season: season )
         : MatchLinter.read( path, season: season )
  end

  def self.lint_conf( path, season: nil )   read_conf( path, sync: false, season: season ); end
  def self.lint_match( path, season: nil )  read_match( path, sync: false, season: season ); end


  def self.read( path, sync: true, season: nil )
    ## step 1: collect all datafiles
    if File.directory?( path )   ## if directory read complete package
      datafiles_conf = Datafile.find_conf( path )
      datafiles      = Datafile.find( path, %r{/\d{4}-\d{2}    ## season folder e.g. /2019-20
                                               /[a-z0-9_-]+\.txt$    ## txt e.g /1-premierleague.txt
                                              }x )

      datafiles_conf.each { |datafile| read_conf( datafile, sync: sync, season: season ) }
      datafiles.each { |datafile| read_match( datafile, sync: sync, season: season ) }
    else
      ## check if datafile matches conf(iguration) naming (e.g. .conf.txt)
      if Datafile.match_conf( path )
        read_conf( path, sync: sync, season: season )
      else   ## assume "regular" match datafile
        read_match( path, sync: sync, season: season )
      end
    end
  end  # method read

  def self.lint( path, season: nil )  read( path, sync: false, season: season ); end

end # module SportDb



puts SportDb::Readers.banner   # say hello
