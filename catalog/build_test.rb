####
#  build a simple test catalog.db
#     was TestCatalog in sportdb-formats

### note: make sure to load latest sportdb/structs !!!  (allow key with numbers!)
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))


require 'sportdb/indexers'


CatalogDb.open( './testcatalog.db' )




module SportDb
module Import

##########
## build_country_index
countries = CountryReader.read( "#{Test.data_dir}/world/countries.txt" )
pp countries
CatalogDb::CountryIndexer.new( countries )

## check country count
puts "countries:"
puts CatalogDb::Metal::Country.count


###########
## build_league_index
leagues  = LeagueReader.parse( <<TXT )
= England =
1       English Premier League
          | ENG PL | England Premier League | Premier League
2       English Championship
          | ENG CS | England Championship | Championship
3       English League One
          | England League One | League One
4       English League Two
5       English National League

cup      EFL Cup
          | League Cup | Football League Cup
          | ENG LC | England Liga Cup

= Scotland =
1       Scottish Premiership
2       Scottish Championship
3       Scottish League One
4       Scottish League Two
TXT

pp leagues

league_indexer = CatalogDb::LeagueIndexer.new
league_indexer.add( leagues )


########################
##   build_club_index
    

   clubs = ClubReader.parse( <<TXT )
= England

Chelsea FC
Tottenham Hotspur
West Ham United
Crystal Palace

### note add move entires for testing club name history
Manchester United FC
  | Manchester United
  | Newton Heath FC

Manchester City FC
  | Manchester City
  | Ardwick FC

Arsenal FC
  | The Arsenal FC
  | Woolwich Arsenal FC
  | Royal Arsenal FC

Gateshead FC
  | South Shields FC

Sheffield Wednesday
  | The Wednesday FC

Port Vale FC
  | Burslem Port Vale FC

Chesterfield FC
  | Chesterfield Town FC

Birmingham FC
  | Small Heath FC

Burton Swifts FC
Burton Wanderers FC
Burton United FC

Blackpool FC
South Shore FC

Glossop FC
  | Glossop North End FC

Walsall FC
  | Walsall Town Swifts FC


Newcastle West End FC
Newcastle East End FC
Newcastle United FC
TXT

pp clubs

club_indexer = CatalogDb::ClubIndexer.new
club_indexer.add( clubs )
    
puts "Test.data_dir:"
puts Test.data_dir

end     # module SportDb
end     # module Import



puts "bye"
