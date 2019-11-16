
# from sportdb-readers/readers.rb

datafiles_conf = Datafile.find_conf( path )
datafiles      = Datafile.find( path, %r{/\d{4}-\d{2}    ## season folder e.g. /2019-20
                                         /[a-z0-9_-]+\.txt$    ## txt e.g /1-premierleague.txt
                                        }x )

datafiles_conf.each { |datafile| read_conf( datafile, season: season sync: sync ) }
datafiles.each { |datafile| read_match( datafile, season: season, sync: sync ) }
