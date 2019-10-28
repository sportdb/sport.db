##
# bundle all football.db /openfootball/leagues .txt files into a single leagues.txt

require 'sportdb/formats'


LEAGUES_DIR = '../../../openfootball/leagues'



datafiles = Datafile.find_leagues( LEAGUES_DIR )
pp datafiles

Datafile.write_bundle( './config/leagues.txt',
                       datafiles: datafiles,
                       header: <<TXT )
##########################################
# auto-generated all-in-one single datafile leagues.txt bundle
#    on #{Time.now} from #{datafiles.size} datafile(s)
#  please, do NOT edit here; use the source
#    see https://github.com/openfootball/leagues - updates welcome!
TXT
