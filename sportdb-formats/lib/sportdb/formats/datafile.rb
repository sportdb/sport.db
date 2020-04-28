# encoding: utf-8


module Datafile      # note: keep Datafile in its own top-level module/namespace for now - why? why not?

  def self.read( path )   ## todo/check: use as a shortcut helper - why? why not?
     ## note: always assume utf-8 for now!!!
     File.open( path, 'r:utf-8') {|f| f.read }
  end


  def self.find( path, pattern )
     datafiles = []

     ## check all txt files
     ## note: incl. files starting with dot (.)) as candidates (normally excluded with just *)
     candidates = Dir.glob( "#{path}/**/{*,.*}.txt" )
     pp candidates
     candidates.each do |candidate|
       datafiles << candidate    if pattern.match( candidate )
     end

     pp datafiles
     datafiles
  end


  CLUBS_RE = %r{  (?: ^|/ )               # beginning (^) or beginning of path (/)
                       (?: [a-z]{1,4}\. )?   # optional country code/key e.g. eng.clubs.txt
                       clubs\.txt$
                   }x

  CLUBS_WIKI_RE = %r{  (?:^|/)               # beginning (^) or beginning of path (/)
                           (?:[a-z]{1,4}\.)?   # optional country code/key e.g. eng.clubs.wiki.txt
                          clubs\.wiki\.txt$
                       }x

  CLUB_PROPS_RE = %r{  (?: ^|/ )               # beginning (^) or beginning of path (/)
                       (?: [a-z]{1,4}\. )?   # optional country code/key e.g. eng.clubs.props.txt
                      clubs\.props\.txt$
                   }x

  def self.find_clubs( path, pattern: CLUBS_RE )            find( path, pattern ); end
  def self.find_clubs_wiki( path, pattern: CLUBS_WIKI_RE )  find( path, pattern ); end

  def self.match_clubs( path )       CLUBS_RE.match( path ); end
  def self.match_clubs_wiki( path )  CLUBS_WIKI_RE.match( path ); end
  def self.match_club_props( path, pattern: CLUB_PROPS_RE ) pattern.match( path ); end
  class << self
    alias_method :match_clubs?, :match_clubs
    alias_method :clubs?,       :match_clubs

    alias_method :match_clubs_wiki?, :match_clubs_wiki
    alias_method :clubs_wiki?,       :match_clubs_wiki

    alias_method :match_club_props?, :match_club_props
    alias_method :club_props?,       :match_club_props
  end

  LEAGUES_RE = %r{  (?: ^|/ )               # beginning (^) or beginning of path (/)
                        (?: [a-z]{1,4}\. )?   # optional country code/key e.g. eng.clubs.wiki.txt
                     leagues\.txt$
                    }x

  def self.find_leagues( path, pattern: LEAGUES_RE )  find( path, pattern ); end
  def self.match_leagues( path )  LEAGUES_RE.match( path ); end
  class << self
    alias_method :match_leagues?, :match_leagues
    alias_method :leagues?,       :match_leagues
  end

  CONF_RE = %r{  (?: ^|/ )               # beginning (^) or beginning of path (/)
                     \.conf\.txt$
                 }x

  def self.find_conf( path, pattern: CONF_RE )  find( path, pattern ); end
  def self.match_conf( path )  CONF_RE.match( path ); end
  class << self
    alias_method :match_conf?, :match_conf
    alias_method :conf?,       :match_conf
  end



  def self.write_bundle( path, datafiles:, header: nil )
    File.open( path, 'w:utf-8' ) do |f|
      if header
        f.write( header )
        f.write( "\n\n" )
      end
      datafiles.each do |datafile|
        text = read( datafile )
        ## todo/fix/check:  move  sub __END__ to Datafile.read and turn it always on  -  why? why not?
        text = text.sub( /__END__.*/m, '' )    ## note: add/allow support for __END__; use m-multiline flag
        f.write( text )
      end
    end
  end

end # module Datafile
