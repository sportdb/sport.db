require 'active_record'   ## todo: add sqlite3? etc.


require_relative 'lib/sportdb/indexers/models'


config = {
        adapter:  'sqlite3',
        database: './grounds.db',   #'./catalog.db',
}

ActiveRecord::Base.establish_connection( config )    



puts "  #{CatalogDb::Model::Country.count} countries"
puts "        #{CatalogDb::Model::CountryName.count} country names"
puts "  #{CatalogDb::Model::City.count} cities"
puts "        #{CatalogDb::Model::CityName.count} city names"

puts "  #{CatalogDb::Model::Club.count} clubs"
puts "        #{CatalogDb::Model::ClubName.count} club names"
puts "  #{CatalogDb::Model::NationalTeam.count} national teams"
puts "        #{CatalogDb::Model::NationalTeamName.count} national team names"
puts "  #{CatalogDb::Model::League.count} leagues"
puts "        #{CatalogDb::Model::LeagueName.count} league names"

puts "  #{CatalogDb::Model::Ground.count} grounds"
puts "        #{CatalogDb::Model::GroundName.count} ground names"


#####
## dump all cities by country

CatalogDb::Model::Country.order( 'key' ).each do |country|
  cities = country.cities.order( 'name' )
  if cities.count > 0
    puts
    puts "==> #{country.key} - #{country.name} (#{country.code}) - #{cities.count} cities"
    cities.each do |city|
      print "#{city.name}"
      print " (#{city.alt_names})"  if city.alt_names
      print "  "
    end
    print "\n"
  end
end


puts "bye"


