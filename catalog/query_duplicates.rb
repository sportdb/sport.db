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





## find all duplicate clubs by names!!!

dups = CatalogDb::Model::ClubName.group('name').having( 'count(name) > 1' )
## pp dups

dups_h = dups.count   ## or dups.size returns hash with counts!!!
puts
puts
puts "  #{dups_h.size} dupliate clubs(s) by name:"
pp dups_h

dups.each do |dup|
    recs =  CatalogDb::Model::Club.joins( :club_names ).where( club_names:
                                                                 { name: dup.name })
   puts "==> #{dup.name}  - #{recs.size}"
   pp recs
end

## build report / page
buf = String.new
buf << "## #{dups_h.size} Duplicate(s)\n\n"

buf << dups_h.map { |name, count|  "`#{name}` (#{count})" }.join( '·' )
buf << "\n\n"


dups.each do |dup|
  recs =  CatalogDb::Model::Club.joins( :club_names ).where( club_names:
                                                               { name: dup.name })

  buf << "- **#{recs.size}** clubs for **`#{dup.name}`**:\n"
  recs.each do |rec|
    buf << "  - #{rec.name}, #{rec.city ? rec.city : '?'}, #{rec.country.name} (#{rec.country.key})\n"
  end
end

write_text( "./o/DUPLICATES.md", buf )



## find all duplicate clubs by keys!!!
##   fix - remove -  check schema - key is unique by definition with index!!!
##    no need to check here!!!
dups = CatalogDb::Model::Club.group('key').having( 'count(key) > 1' )
## pp dups

dups_h = dups.count   ## or dups.size returns hash with counts!!!
puts
puts
puts "  #{dups_h.count} dupliate club(s) by key:"
pp dups_h

dups.each do |dup|
    recs =  CatalogDb::Model::Club.where( key: dup.key )
   puts "==> #{dup.key}  - #{recs.size}"
   pp recs
end



puts "bye"

