##########################################
# Datafile for Austrian Bundesliga
#
#  use
#    $ sportdb new at


###
## setup austria if not present
## -- move to austria.db e.g. /countries.txt - why? why not??
inline do
  WorldDb::Model::Country.parse( 'at', 'Austria', 'AUT', '83_871 km²', '8_414_638' )
end

world 'austria.db' # note: default setup is all


football 'at-austria'

