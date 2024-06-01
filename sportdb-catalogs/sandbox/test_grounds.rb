$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))

require 'sportdb/catalogs'

## add for now for EventInfo
require 'sportdb/formats'


Country      = CatalogDb::Metal::Country
City         = CatalogDb::Metal::City

League       = CatalogDb::Metal::League
NationalTeam = CatalogDb::Metal::NationalTeam
Club         = CatalogDb::Metal::Club
EventInfo    = CatalogDb::Metal::EventInfo

Ground       = CatalogDb::Metal::Ground



SportDb::Import.config.catalog_path = '../catalog/grounds.db'

CITIES  = SportDb::Import.world.cities
GROUNDS = SportDb::Import.catalog.grounds

pp Country.count
pp City.count

pp League.count
pp NationalTeam.count
pp Club.count
pp EventInfo.count

pp Ground.count


require 'cocos'


recs = parse_data( <<TXT )
  # euro 2016 in france
  # 10 stadiums
  Stade de France, Saint-Denis
  Stade Bollaert-Delelis, Lens
  Parc des Princes, Paris
 Stade Vélodrome, Marseille
 Stade Pierre-Mauroy, Lille
 Parc Olympique Lyonnais, Lyon
 Nouveau Stade de Bordeaux, Bordeaux
 Stadium Municipal, Toulouse
 Stade Geoffroy-Guichard, Saint-Étienne
 Allianz Riviera, Nice


 # euro 2024
 ## 10 stadiums (+2 variants)
 München Fußball Arena, München
  Köln Stadion, Köln
  Stuttgart Arena, Stuttgart
  Frankfurt Arena, Frankfurt
  Olympiastadion, Berlin
  BVB Stadion Dortmund, Dortmund
  Volksparkstadion, Hamburg
  Arena Auf Schalke, Gelsenkirchen
  Düsseldorf Arena, Düsseldorf
  Leipzig Stadion, Leipzig
  Munich Football Arena, Munich
  Waldstadion, Frankfurt
 
  # euro 2020
  # 12 statiums
  Stadio Olimpico, Rome
   Olympic Stadium, Baku
   Parken Stadium, Copenhagen
   Krestovsky Stadium, Saint Petersburg
   Arena Națională, Bucharest
   Johan Cruyff Arena, Amsterdam
   Wembley Stadium, London
   Hampden Park, Glasgow
   La Cartuja, Seville
   Puskás Aréna, Budapest
   Allianz Arena, Munich
   Estadio de La Cartuja, Seville
  
  

TXT

## pp recs


##
## check for cities first
recs.each do |_,name|
  m = CITIES.match_by( name: name )
                    
  if m.size == 1
    city = m[0]
    print "    "
    print "%-30s" % "#{name}"
    if name != city.name 
      print " => #{city.name}, #{city.country.name}"
    end
    print "\n"
  else
    puts "!!  #{name}"
  end                      
end


puts 
puts

recs.each do |name,city|
  m = GROUNDS.match_by( name: name, 
                        city: city )
                    
  if m.size == 1
    ground = m[0]
    print "    "
    print "%-30s" % "#{name}, #{city}"
    if name != ground.name || 
       city != ground.city.name
      print " => #{ground.name} @ #{ground.city.name}, #{ground.country.name}"
    end
    print "\n"
  else
    puts "!!  #{name}, #{city}"
  end                      
end
                    
puts "bye"




__END__

Euro 2016

!!  Parc Olympique Lyonnais, Lyon
!!  Nouveau Stade de Bordeaux, Bordeaux
