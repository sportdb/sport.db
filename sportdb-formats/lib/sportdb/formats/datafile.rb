# encoding: utf-8


module Datafile      # note: keep Datafile in its own top-level module/namespace for now - why? why not?

  def self.find( path, pattern )
     datafiles = []

     ## check all txt files (incl. starting with dot (.)) as candidates
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

  def self.find_clubs( path )       find( path, CLUBS_REGEX ); end
  def self.find_clubs_wiki( path )  find( path, CLUBS_WIKI_REGEX ); end


  LEAGUES_REGEX = %r{  (?:^|/)               # beginning (^) or beginning of path (/)
                     leagues\.txt$
                    }x

  def self.find_leagues( path )     find( path, LEAGUES_REGEX ); end


  CONF_REGEX = %r{  (?:^|/)               # beginning (^) or beginning of path (/)
                     \.conf\.txt$
                 }x

  def self.find_conf( path )       find( path, CONF_REGEX ); end




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
