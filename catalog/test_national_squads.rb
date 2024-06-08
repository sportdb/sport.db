### note: make sure to load latest sportdb/structs !!!  (allow key with numbers!)
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))  ## sportdb-indexers


require 'sportdb/indexers'


## set catalog db (required for world search api)
SportDb::Import.config.catalog_path = './catalog.db'


paths = Dir.glob( '../../../openfootball/euro/2024--germany/squads/*.txt')
pp paths


errors = []

paths.each_with_index do |path, i|
  # path = '../../../openfootball/euro/2024--germany/squads/austria.txt'
  recs = SportDb::Import::NationalSquadReader.read( path )
  ## pp recs
  puts "==> #{i}/#{paths.size} - #{File.basename(path)} ..."
  puts  "  #{recs.size} record(s)"

  recs.each do |rec|
     
     club_name   = rec.club
     country_key = rec.club_nat 

     m = SportDb::Import.config.catalog.clubs.match_by( name: club_name,
                                                        country: country_key )
    if m.size == 1
         club = m[0]
        print "OK  #{club_name}, #{country_key}" 
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
