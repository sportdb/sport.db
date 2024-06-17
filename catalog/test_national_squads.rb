##
##
#  fix (2) clubs errors for euro !!
#   
#  ["Al Shabab FC (Riyadh), sa", "AS Monaco FC, fr"]
#    change monaco to mc (monaco) !!!
#   remove (Riyadh) from Al Shabab FC  !!!


# known duplicates - same names in euro 2024
##   - Ladislav Krejčí (CZE)    - 1999, 1992
##   - Lorenzo Pellegrini (ITA) - 2003, 1996
##   - Piotr Zieliński (POL)    - 1999, 1994
##   - Pepe (POR)               - 1997, 1983
##   - Bernardo Silva (POR)     - 2001, 1994
##   -  Liam Kelly (SCO)        - 1995, 1990
##   -  Rodri (ESP)             - 2000, 1996, 1990
##   -  Joselu (ESP)            - 2004, 1991, 1990
##         Reece James (ENG)
##            João Moutinho (POR)
##           Diego Llorente (ESP) 
##           Koke (ESP) 
##          Burak Yılmaz (TUR)
   



### note: make sure to load latest sportdb/structs !!!  (allow key with numbers!)
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))  ## sportdb-indexers


require 'sportdb/indexers'


## set catalog db (required for world search api)
SportDb::Import.config.catalog_path = './catalog.db'
SportDb::Import.config.players_path = './players.db'

CLUBS   = SportDb::Import.config.catalog.clubs
PLAYERS = SportDb::Import.config.catalog.players



## paths = Dir.glob( '../../../openfootball/euro/2024--germany/squads/*.txt')
paths = Dir.glob( '../../../openfootball/euro/2020--europe/squads/*.txt')
pp paths


errors = []

paths.each_with_index do |path, i|
  # path = '../../../openfootball/euro/2024--germany/squads/austria.txt'
  recs = SportDb::Import::NationalSquadReader.read( path )
  ## pp recs
  puts "==> #{i}/#{paths.size} - #{File.basename(path)} ..."
  puts  "  #{recs.size} record(s)"

  recs.each do |rec|
      
     ####
      #  pass 1 - check player  names 
      player_name      = rec.name
      player_birthyear = rec.birthyear
      player_nat       = rec.nat          ## aka country key
 
      m = PLAYERS.match_by( name:    player_name,
                            year:    player_birthyear,
                            country: player_nat )
  if m.size == 1
         player = m[0]
        print "OK  #{player_name} (#{player_nat}) b. #{player_birthyear}" 
        print "   =>    #{player.name} (#{player.nat})"  if player_name != player.name
        print "\n"
    elsif m.size == 0
        print "    #{player_name} (#{player_nat}) b. #{player_birthyear}" 
        print "\n"
        
        ## note - only add once (check for duplicates)
        errors <<  "player - #{player_name} (#{player_nat}) b. #{player_birthyear}"   
    else   # ambigous
        print "\n"
        print "!! more than one match (#{m.size}) for #{player_name} (#{player_nat})  b. #{player_birthyear}:"
        print "\n"
        pp m
        exit 1
    end

     ####
      #  pass 2 - check club names 
      club_name   = rec.club
      country_key = rec.club_nat 
 
      m = CLUBS.match_by( name:    club_name,
                          country: country_key )
     if m.size == 1
          club = m[0]
         print "OK    @ #{club_name}, #{country_key}" 
         ## note - ignore dots too e.g. Everton F.C. ==  Everton FC etc.
         print "   =>    #{club.name}, #{club.country.name}"  if club_name != club.name &&
                                                                 club_name.gsub('.', '') != club.name
         print "\n"
     elsif m.size == 0
         print "    #{club_name}, #{country_key}" 
         print "\n"
         
         ## note - only add once (check for duplicates)
         errors <<  "#{club_name}, #{country_key}"   unless errors.include?( "#{club_name}, #{country_key}" )
     else   # ambigous
         print "\n"
         print "!! more than one match (#{m.size}) for #{club_name}, #{country_key}:"
         print "\n"
         pp m
         exit 1
     end
  end
end


puts
pp errors
puts "  #{errors.size} error(s)"

puts "bye"
