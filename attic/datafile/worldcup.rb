####################################
# Datafile for World Cups
#
#  use
#    $ sportdb new worldcup

world  'world.db', setup: 'countries'

football 'national-teams'
football 'national-teams', setup: 'history'

football 'world-cup', setup: 'history'
