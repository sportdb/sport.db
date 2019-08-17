##
# bundle all football.db /openfootball/clubs .txt files into a single clubs.txt

require 'pp'


##
## todo/fix: (re)use find_datafiles from sportdb-config gem / library - do NOT duplicate - why? why not?


CLUBS_REGEX = %r{  (?:^|/)               # beginning (^) or beginning of path (/)
                       (?:[a-z]{1,3}\.)?   # optional country code/key e.g. eng.clubs.txt
                       clubs\.txt$
                   }x


def find_datafiles( path, pattern=CLUBS_REGEX )
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

datafiles = find_datafiles( '../../openfootball/clubs' )
pp datafiles

File.open( './config/clubs.txt', 'w:utf-8') do |fout|
  fout.write( <<TXT )
##########################################
# auto-generated all-in-one single datafile clubs.txt bundle
#    on #{Time.now} from #{datafiles.size} datafile(s)
#  please, do NOT edit here; use the source
#    see https://github.com/openfootball/clubs - updates welcome!
TXT
  datafiles.each do |datafile|
    File.open( datafile, 'r:utf-8') do |fin|
      fout.write( "\n\n" )
      fout.write( fin.read )
    end
  end
end
