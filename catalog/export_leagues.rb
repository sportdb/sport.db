require 'active_record'   ## todo: add sqlite3? etc.
require 'cocos'

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
puts "        #{CatalogDb::Model::LeaguePeriod.count} league periods"


rows = []
CatalogDb::Model::LeaguePeriod.all.each do |period|
  pp period


  rows << [
              period.tier_key,
              period.qname,
              period.slug,
              period.start_season || '',
              period.end_season || ''
          ]
end

# key, name, basename, start_season, end_season
headers = ['key',
           'name',
           'basename',
           'start_season',
           'end_season']

pp rows

write_csv( "./tmp2/leagues.csv", rows, headers: headers )


puts "bye"

