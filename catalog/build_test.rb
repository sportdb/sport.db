####
#  build a simple test catalog.db
#     was TestCatalog in sportdb-formats

require 'active_record'   ## todo: add sqlite3? etc.

require_relative 'schema'
require_relative 'models'


### note: make sure to load latest sportdb/structs !!!  (allow key with numbers!)
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))

require 'sportdb/structs'
require 'sportdb/catalogs'
require 'sportdb/formats'
require 'fifa'

require_relative 'indexer'
require_relative 'country_indexer'
require_relative 'national_team_indexer'
require_relative 'club_indexer'
require_relative 'league_indexer'



####
#  db support
def connect
    config = {
        adapter:  'sqlite3',
        database: './testcatalog.db',
    }

    ActiveRecord::Base.establish_connection( config )
    # ActiveRecord::Base.logger = Logger.new( STDOUT )

    ## if sqlite3 add (use) some pragmas for speedups
    if config[:adapter]  == 'sqlite3'  &&
       config[:database] != ':memory:'
      ## note: if in memory database e.g. ':memory:' no pragma needed!!
      ## try to speed up sqlite
      ##   see http://www.sqlite.org/pragma.html
      con = ActiveRecord::Base.connection
      con.execute( 'PRAGMA synchronous=OFF;' )
      con.execute( 'PRAGMA journal_mode=OFF;' )
      con.execute( 'PRAGMA temp_store=MEMORY;' )
    end
end


def auto_migrate!
    connect
    unless CatalogDb::Model::Country.table_exists?
        CatalogDb::CreateDb.new.up
    end
end


auto_migrate!


## set "system" catalog to use this db too
SportDb::Import.config.catalog_path = './testcatalog.db'
## check country count
puts "countries:"
puts CatalogDb::Metal::Country.count




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
leagues  = SportDb::Import::LeagueReader.parse( <<TXT )
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



puts "Test.data_dir:"
puts Test.data_dir

end     # module SportDb
end     # module Import

puts "bye"



__END__




  def build_club_index
    recs = ClubReader.parse( <<TXT )
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

    index = ClubIndex.new
    index.add( recs )
    index
  end

