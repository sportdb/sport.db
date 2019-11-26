##############################################
# Datafile for Austria / Österreich
#
#  use (inside the austria/ folder)
#    $ sportdb build


inline do
  Country.parse 'at', 'Austria', 'AUT', '83_871 km²', '8_414_638'
end

football 'austria'

## note: for now use only 2018/19 season (not the default all)
## football 'austria', season: '2018/19'
