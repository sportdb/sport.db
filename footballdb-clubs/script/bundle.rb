##
# bundle all football.db /openfootball/clubs .txt files into a single clubs.txt

require 'sportdb/formats'    ## todo/fix: use "local" version e.g. patch load path - why? why not?


CLUBS_DIR = '../../../openfootball/clubs'    ## source repo directory path



datafiles = Datafile.find_clubs( CLUBS_DIR )
pp datafiles

Datafile.write_bundle( './config/clubs.txt',
                       datafiles: datafiles,
                       header: <<TXT )
##########################################
# auto-generated all-in-one single datafile clubs.txt bundle
#    on #{Time.now} from #{datafiles.size} datafile(s)
#  please, do NOT edit here; use the source
#    see https://github.com/openfootball/clubs - updates welcome!
TXT


datafiles = Datafile.find_clubs_wiki( CLUBS_DIR )
pp datafiles

Datafile.write_bundle( './config/clubs.wiki.txt',
                       datafiles: datafiles,
                       header: <<TXT )
##########################################
# auto-generated all-in-one single datafile clubs.wiki.txt bundle
#    on #{Time.now} from #{datafiles.size} datafile(s)
#  please, do NOT edit here; use the source
#    see https://github.com/openfootball/clubs - updates welcome!
TXT
