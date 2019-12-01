# encoding: utf-8


module Datafile      # note: keep Datafile in its own top-level module/namespace for now - why? why not?

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



  CLUBS_REGEX = %r{  (?:^|/)               # beginning (^) or beginning of path (/)
                       (?:[a-z]{1,4}\.)?   # optional country code/key e.g. eng.clubs.txt
                       clubs\.txt$
                   }x

  CLUBS_WIKI_REGEX = %r{  (?:^|/)               # beginning (^) or beginning of path (/)
                           (?:[a-z]{1,4}\.)?   # optional country code/key e.g. eng.clubs.wiki.txt
                          clubs\.wiki\.txt$
                       }x

  def self.find_clubs( path, pattern: CLUBS_REGEX )            find( path, pattern ); end
  def self.find_clubs_wiki( path, pattern: CLUBS_WIKI_REGEX )  find( path, pattern ); end

  def self.match_clubs( path )       CLUBS_REGEX.match( path ); end
  def self.match_clubs_wiki( path )  CLUBS_WIKI_REGEX.match( path ); end



  LEAGUES_REGEX = %r{  (?:^|/)               # beginning (^) or beginning of path (/)
                        (?:[a-z]{1,4}\.)?   # optional country code/key e.g. eng.clubs.wiki.txt
                     leagues\.txt$
                    }x

  def self.find_leagues( path, pattern: LEAGUES_REGEX )  find( path, pattern ); end
  def self.match_leagues( path )  LEAGUES_REGEX.match( path ); end


  CONF_REGEX = %r{  (?:^|/)               # beginning (^) or beginning of path (/)
                     \.conf\.txt$
                 }x

  def self.find_conf( path, pattern: CONF_REGEX )  find( path, pattern ); end
  def self.match_conf( path )  CONF_REGEX.match( path ); end



  def self.write_bundle( path, datafiles:, header: nil )
    File.open( path, 'w:utf-8') do |fout|
      if header
        fout.write( header )
        fout.write( "\n\n" )
      end
      datafiles.each do |datafile|
        File.open( datafile, 'r:utf-8') do |fin|
          text = fin.read
          text = text.sub( /__END__.*/m, '' )    ## note: add/allow support for __END__; use m-multiline flag
          fout.write( text )
        end
      end
    end
  end

end # module Datafile
