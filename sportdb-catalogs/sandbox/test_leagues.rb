$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))

require 'sportdb/catalogs'




League         = CatalogDb::Metal::League
LeaguePeriod   = CatalogDb::Metal::LeaguePeriod


# CatalogDb::Metal.tables  ## table stats (before)
CatalogDb::Metal::Record.database = '../catalog/leagues.db'
# CatalogDb::Metal.tables  ## table stats (after)


## pp Country.count
pp League.count
pp LeaguePeriod.count


m = LeaguePeriod.match_by_code( 'eng1', season: '2024/25' )
pp m

m = LeaguePeriod.match_by_code( 'eng1', season: '1991/92' )
pp m

m = LeaguePeriod.match_by_code( 'eng1', season: '1888/89' )
pp m

m = LeaguePeriod.match_by_code( 'eng1', season: '1563' )
pp m

m = LeaguePeriod.match_by_code( 'ö', season: '2024/25' )
pp m

m = LeaguePeriod.match_by_code( 'ö2', season: '2024/25' )
pp m

m = LeaguePeriod.match_by_code( 'ö2', season: '2017/18' )
pp m


m = LeaguePeriod.match_by_name( 'Österr. Bundesliga', season: '2024/25' )
pp m

m = LeaguePeriod.match_by_name( 'English Premier League', season: '2024/25' )
pp m


m = LeaguePeriod.match_by_name_or_code( 'eng1', season: '2024/25' )
pp m
m = LeaguePeriod.match_by_name_or_code( 'English Premier League', season: '2024/25' )
pp m


puts "bye"

