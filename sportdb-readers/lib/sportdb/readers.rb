# encoding: UTF-8


require 'sportdb/config'
require 'sportdb/models'   ## add sql database support



###
# our own code
require 'sportdb/readers/version' # let version always go first
require 'sportdb/readers/sync'
require 'sportdb/readers/outline_reader'
require 'sportdb/readers/event_reader'
require 'sportdb/readers/match_parser'
require 'sportdb/readers/match_reader'


##
##  add convenience shortcut helpers
module SportDb

  def self.read( path )
    ## step 1: collect all datafiles
    if File.directory?( path )   ## if directory read complete package
      datafiles_conf = Datafile.find_conf( path )
      datafiles      = Datafile.find( path, %r{/\d{4}-\d{2}    ## season folder e.g. /2019-20
                                               /[a-z0-9_-]+\.txt$    ## txt e.g /1-premierleague.txt
                                              }x )

      datafiles_conf.each { |datafile| EventReaderV2.read( datafile ) }
      datafiles.each { |datafile| MatchReaderV2.read( datafile ) }
    else
      ## check if datafile matches configuration naming (e.g. .conf.txt)
      if Datafile.match_conf( path )
        EventReaderV2.read( path )
      else   ## assume "regular" match datafile
        MatchReaderV2.read( path )
      end
    end
  end  # method read

  ########################################
  ##  more convenience alias
  ConfReaderV2 = EventReaderV2    ## add why? why not?
end # module SportDb



puts SportDb::Readers.banner   # say hello
