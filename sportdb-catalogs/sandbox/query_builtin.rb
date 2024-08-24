$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))

require 'sportdb/catalogs'



Country      = CatalogDb::Metal::Country
League       = CatalogDb::Metal::League
NationalTeam = CatalogDb::Metal::NationalTeam
Club         = CatalogDb::Metal::Club
EventInfo    = CatalogDb::Metal::EventInfo

Ground       = CatalogDb::Metal::Ground



require 'footballdb/data'

# "../football.db.data/data/catalog.db"
path = "#{FootballDb::Data.data_dir}/catalog.db"

CatalogDb::Metal.tables  ## table stats (before)
CatalogDb::Metal::Record.database = path
CatalogDb::Metal.tables  ## table stats (after)


pp EventInfo.count


pp EventInfo.find_by( league: 'at.1', season: '2018/19' )
pp EventInfo.find_by( league: 'at.1', season: '2122/23' )

pp EventInfo.find_by( league: 'world', season: '1930' )
pp EventInfo.find_by( league: 'world', season: '1950' )


puts "bye"
