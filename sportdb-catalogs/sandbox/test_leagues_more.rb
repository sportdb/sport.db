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
m = League.match_by_code( 'eng1', season: '1991/92' )
pp m
puts "==> eng 1 - 1992/93"
m = League.match_by_code( 'eng1', season: '1992/93' )
pp m
puts "==> eng 1 - 1993/94"
m = League.match_by_code( 'eng1', season: '1993/94' )
pp m

puts "==> eng pl - 1991/92"
m = League.match_by_code( 'engpl', season: '1991/92' )
pp m
puts "==> eng pl - 1992/93"
m = League.match_by_code( 'engpl', season: '1992/93' )
pp m


puts "==> eng 2 - 1991/92"
m = League.match_by_code( 'eng2', season: '1991/92' )
pp m
puts "==> eng 2 - 1992/93"
m = League.match_by_code( 'eng2', season: '1992/93' )
pp m


puts "==> aut 2 - 2024/25"
m = League.match_by_code( 'aut2', season: '2024/25' )
pp m

puts "==> sco ps - 2024/25"
m = League.match_by_code( 'scops', season: '2024/25' )
pp m
puts "==> sco 1 - 2024/25"
m = League.match_by_code( 'sco1', season: '2024/25' )
pp m

puts "==> ger bl - 2024/25"
m = League.match_by_code( 'gerbl', season: '2024/25' )
pp m
puts "==> de 1 - 2024/25"
m = League.match_by_code( 'de1', season: '2024/25' )
pp m


puts "bye"


