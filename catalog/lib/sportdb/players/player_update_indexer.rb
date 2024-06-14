
module CatalogDb

  ## add inside module PersonDb too - why? why not?
  ##   keep shared with all indexers - why? why not?


class PlayerUpdateIndexer < Indexer


  def add( rec_or_recs )   ## add club record / alt_names
    recs = rec_or_recs.is_a?( Array ) ? rec_or_recs : [rec_or_recs]      ## wrap (single) rec in array

    recs.each do |rec|

 ### make sure norm (unaccented) names are unique
    names = rec.names

    norms = names.map do |name|
      ## check lang codes e.g. [en], [fr], etc.
      ##  todo/check/fix:  move strip_lang up in the chain - check for duplicates (e.g. only lang code marker different etc.) - why? why not?
      norm = unaccent( name ).downcase     
      norm = normalize( norm )
      norm
    end

    count      = norms.size
    count_uniq = norms.uniq.size
    if count != count_uniq
      puts "** !!! ERROR !!! - #{count-count_uniq} duplicate player update name(s):"
      pp names
      pp rec
      exit 1
    end

      puts "==> #{names.join( ' | ' )}, #{rec.nat} - b. #{rec.birthyear}"
      pp norms

      persons = []
      found = []
      not_found = []

=begin
      puts "try count:"
      puts PersonDb::Model::Person.count
      #=>  32659
      puts "try models:"
      person = PersonDb::Model::Person.first
      pp person
      puts "try names:"
      pp person.person_names.count
      pp person.person_names
=end

     norms.zip( names ).each do |norm, name|
         # note - joins only works with symbols (not strings? 
        recs = PersonDb::Model::Person.joins( :person_names ).
                       where( "person_names.name = '#{norm}'" +
                              " AND nat = '#{rec.nat}'"  + 
                              " AND cast(strftime( '%Y', birthdate ) as int) = #{rec.birthyear}"
                            )
        puts "  #{norm} - #{recs.size} record(s) found"
        pp recs.class.name  #=> ActiveRecord::Relation
         if recs.size > 0
            if recs.size > 1
               puts "!! ERROR - too many (#{recs.size}) matches for name:"
               pp recs
               exit 1
            end
             found << name
             persons << recs[0]
             pp recs[0]
             pp recs[0].class.name   #=> CatalogDb::PersonDb::Model::Persom
          else
             not_found << name
          end  
     end

       puts "found (#{found.size}):"
       pp found
       puts "not_found (#{not_found.size}):"
       pp not_found

       ## check all matches are the same record
       ##   use ids - why? why not?
       if persons.uniq.size != 1
         puts "** !!! ERROR !!! - more than one player update found:"
         pp persons
         exit 1
       end
    
       _update_names( persons[0], not_found )
    end
  end # method add


  def _update_names( player, names )  ## rename to update_alt_names or such? why? why not?
      ## todo/fix:
      ##   1) add to alt names too!!!
      ##   2) auto-add quick and dirty (first / last name) split if not yet added!!!

      ####
      #   note:
      ##    for now only add
      ##      - 1st unaccent
      ##      - 2nd downcase
      ##      - 3rd 
      norms = names.map do |name|
        ## check lang codes e.g. [en], [fr], etc.
        ##  todo/check/fix:  move strip_lang up in the chain - check for duplicates (e.g. only lang code marker different etc.) - why? why not?
        norm = unaccent( name ).downcase     
        norm = normalize( norm )
        norm
      end

      ## norms = norms.uniq  

      norms.each do |norm|
           player_name =  PersonDb::Model::PersonName.find_by(
                                person_id: player.id,
                                name:      norm
                             )
            if player_name
              ## skip name; already exists!!
              puts "!! WARN - (norm) name >#{norm}< already exists"
            else
               PersonDb::Model::PersonName.create!( 
                                        person_id: player.id, 
                                        name:      norm )
            end
        end
  end   # method _update_names


end # class PlayerUpdateIndexer
end   # module CatalogDb
