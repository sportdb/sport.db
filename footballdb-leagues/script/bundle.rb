##
# bundle all football.db /openfootball/leagues .txt files into a single leagues.txt

require 'pp'


##
## todo/fix: (re)use find_datafiles from sportdb-config gem / library - do NOT duplicate - why? why not?


LEAGUES_REGEX = %r{  (?:^|/)               # beginning (^) or beginning of path (/)
                       leagues\.txt$
                   }x

def find_datafiles( path, pattern )
     datafiles = []   ## note: [country, path] pairs for now

     ## check all txt files as candidates  (MUST include country code for now)
     candidates = Dir.glob( "#{path}/**/*.txt" )
     pp candidates
     candidates.each do |candidate|
       datafiles << candidate    if pattern.match( candidate )
     end

     pp datafiles
     datafiles
end

def bundle( path, datafiles, header )
  File.open( path, 'w:utf-8') do |fout|
    fout.write( header )
    datafiles.each do |datafile|
      File.open( datafile, 'r:utf-8') do |fin|
        fout.write( "\n\n" )
        text = fin.read
        text = text.sub( /__END__.*/m, '' )      ## note: add/allow support for __END__; use m-multiline flag
        fout.write( text )
      end
    end
  end
end



datafiles = find_datafiles( '../../../openfootball/leagues', LEAGUES_REGEX )
pp datafiles

bundle( './config/leagues.txt', datafiles, <<TXT )
##########################################
# auto-generated all-in-one single datafile leagues.txt bundle
#    on #{Time.now} from #{datafiles.size} datafile(s)
#  please, do NOT edit here; use the source
#    see https://github.com/openfootball/leagues - updates welcome!
TXT
