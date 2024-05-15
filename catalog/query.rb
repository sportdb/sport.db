require 'active_record'   ## todo: add sqlite3? etc.


require_relative 'lib/sportdb/indexers/models'


config = {
        adapter:  'sqlite3',
        database: './catalog.db',
}

ActiveRecord::Base.establish_connection( config )    


puts "  #{CatalogDb::Model::Country.count} countries"
puts "        #{CatalogDb::Model::CountryName.count} country names"
puts "  #{CatalogDb::Model::Club.count} clubs"
puts "        #{CatalogDb::Model::ClubName.count} club names"
puts "  #{CatalogDb::Model::NationalTeam.count} national teams"
puts "        #{CatalogDb::Model::NationalTeamName.count} national team names"
puts "  #{CatalogDb::Model::League.count} leagues"
puts "        #{CatalogDb::Model::LeagueName.count} league names"



## find all duplicate club keys!!!

dups = CatalogDb::Model::Club.group('key').having( 'count(key) > 1' )
pp dups

puts "  #{dups.size} dupliate(s)"

dups.each do |dup|
    recs =  CatalogDb::Model::Club.where( key: dup.key )
   puts "==> #{dup.key}  - #{recs.size}"
   pp recs
end



puts "bye"


__END__

{"bkbenhavn"=>2, "bodense"=>2, "fcastana"=>2, "fcdinamominsk"=>2, "fckrasnodar"=>2, "portlandtimbers"=>2} dupliate(s)
==> bkbenhavn  - 2
[#<CatalogDb::Model::Club:0x000001ab2dcf94d0
  id: 647,
  key: "bkbenhavn",
  name: "B 1903 København (1903-1992)",
  alt_names: nil,
  code: nil,
  country_key: "dk",
  created_at: 2024-05-12 12:36:28.620256 UTC,
  updated_at: 2024-05-12 12:36:28.620256 UTC>,
 #<CatalogDb::Model::Club:0x000001ab2dcf8990
  id: 649,
  key: "bkbenhavn",
  name: "B93 København",
  alt_names: nil,
  code: nil,
  country_key: "dk",
  created_at: 2024-05-12 12:36:28.698177 UTC,
  updated_at: 2024-05-12 12:36:28.698177 UTC>]
==> bodense  - 2
[#<CatalogDb::Model::Club:0x000001ab2dcf8850
  id: 673,
  key: "bodense",
  name: "B 1909 Odense",
  alt_names: nil,
  code: nil,
  country_key: "dk",
  created_at: 2024-05-12 12:36:29.258548 UTC,
  updated_at: 2024-05-12 12:36:29.258548 UTC>,
 #<CatalogDb::Model::Club:0x000001ab2dcf8710
  id: 674,
  key: "bodense",
  name: "B 1913 Odense",
  alt_names: nil,
  code: nil,
  country_key: "dk",
  created_at: 2024-05-12 12:36:29.276939 UTC,
  updated_at: 2024-05-12 12:36:29.276939 UTC>]
==> fcastana  - 2
[#<CatalogDb::Model::Club:0x000001ab2dcf85d0
  id: 101,
  key: "fcastana",
  name: "FC Astana",
  alt_names: nil,
  code: nil,
  country_key: "kz",
  created_at: 2024-05-12 12:36:16.973063 UTC,
  updated_at: 2024-05-12 12:36:16.973063 UTC>,
 #<CatalogDb::Model::Club:0x000001ab2dcf8490
  id: 102,
  key: "fcastana",
  name: "FC Astana-1964",
  alt_names: nil,
  code: nil,
  country_key: "kz",
  created_at: 2024-05-12 12:36:16.996184 UTC,
  updated_at: 2024-05-12 12:36:16.996184 UTC>]
==> fcdinamominsk  - 2
[#<CatalogDb::Model::Club:0x000001ab2dcf8350
  id: 464,
  key: "fcdinamominsk",
  name: "FC Dinamo Minsk",
  alt_names: nil,
  code: nil,
  country_key: "by",
  created_at: 2024-05-12 12:36:24.6057 UTC,
  updated_at: 2024-05-12 12:36:24.6057 UTC>,
 #<CatalogDb::Model::Club:0x000001ab2dcf8210
  id: 465,
  key: "fcdinamominsk",
  name: "FC Dinamo-93 Minsk (1992-1998)",
  alt_names: nil,
  code: nil,
  country_key: "by",
  created_at: 2024-05-12 12:36:24.623592 UTC,
  updated_at: 2024-05-12 12:36:24.623592 UTC>]
==> fckrasnodar  - 2
[#<CatalogDb::Model::Club:0x000001ab2dcf80d0
  id: 1911,
  key: "fckrasnodar",
  name: "FC Krasnodar",
  alt_names: nil,
  code: nil,
  country_key: "ru",
  created_at: 2024-05-12 12:36:56.72908 UTC,
  updated_at: 2024-05-12 12:36:56.72908 UTC>,
 #<CatalogDb::Model::Club:0x000001ab2dcf7f90
  id: 1912,
  key: "fckrasnodar",
  name: "FC Krasnodar 2",
  alt_names: nil,
  code: nil,
  country_key: "ru",
  created_at: 2024-05-12 12:36:56.748602 UTC,
  updated_at: 2024-05-12 12:36:56.748602 UTC>]
==> portlandtimbers  - 2
[#<CatalogDb::Model::Club:0x000001ab2dcf7e50
  id: 2554,
  key: "portlandtimbers",
  name: "Portland Timbers",
  alt_names: nil,
  code: nil,
  country_key: "us",
  created_at: 2024-05-12 12:37:11.619994 UTC,
  updated_at: 2024-05-12 12:37:11.619994 UTC>,
 #<CatalogDb::Model::Club:0x000001ab2dcf7d10
  id: 2555,
  key: "portlandtimbers",
  name: "Portland Timbers 2",
  alt_names: nil,
  code: nil,
  country_key: "us",
  created_at: 2024-05-12 12:37:11.639362 UTC,
  updated_at: 2024-05-12 12:37:11.639362 UTC>]