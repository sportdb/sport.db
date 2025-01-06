$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))

require 'sportdb/catalogs'




League         = CatalogDb::Metal::League
LeaguePeriod   = CatalogDb::Metal::LeaguePeriod


# CatalogDb::Metal.tables  ## table stats (before)
CatalogDb::Metal::Record.database = '../catalog/catalog.db'
# CatalogDb::Metal.tables  ## table stats (after)


## pp Country.count
pp League.count
pp LeaguePeriod.count

puts "==> eng 1 - 1991/92"
m = League.match_by_code_and_season( 'eng1', season: '1991/92' )
pp m
puts "==> eng 1 - 1992/93"
m = League.match_by_code_and_season( 'eng1', season: '1992/93' )
pp m
puts "==> eng 1 - 1993/94"
m = League.match_by_code_and_season( 'eng1', season: '1993/94' )
pp m

puts "==> eng pl - 1991/92"
m = League.match_by_code_and_season( 'engpl', season: '1991/92' )
pp m
puts "==> eng pl - 1992/93"
m = League.match_by_code_and_season( 'engpl', season: '1992/93' )
pp m


puts "==> eng 2 - 1991/92"
m = League.match_by_code_and_season( 'eng2', season: '1991/92' )
pp m
puts "==> eng 2 - 1992/93"
m = League.match_by_code_and_season( 'eng2', season: '1992/93' )
pp m


puts "==> aut 2 - 2024/25"
m = League.match_by_code_and_season( 'aut2', season: '2024/25' )
pp m

puts "==> sco ps - 2024/25"
m = League.match_by_code_and_season( 'scops', season: '2024/25' )
pp m
puts "==> sco 1 - 2024/25"
m = League.match_by_code_and_season( 'sco1', season: '2024/25' )
pp m

puts "==> ger bl - 2024/25"
m = League.match_by_code_and_season( 'gerbl', season: '2024/25' )
pp m
puts "==> de 1 - 2024/25"
m = League.match_by_code_and_season( 'de1', season: '2024/25' )
pp m


puts "bye"

__END__

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

