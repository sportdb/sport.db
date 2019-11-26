##############################################
# Datafile for Deutschland
#
#  use (inside the deutschland/ folder)
#    $ sportdb build


inline do
  Country.parse 'de', 'Germany', 'GER', '357_050 km²', '81_799_600'
end

football 'deutschland'

## note: for now use only 2019/20 season (not the default all)
## football 'deutschland', season: '2019/20'
