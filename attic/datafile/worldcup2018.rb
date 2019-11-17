####################################
# Datafile for World Cup 2018
#
#  use
#    $ sportdb new worldcup2018


world  'world.db', setup: 'countries'


football 'national-teams'

### fix: allow same "zip/dataset" get referenced many times (but only download once)
### football 'openfootball/world-cup', setup: '2018_quali'

football 'world-cup', setup: '2018'
