
module CatalogDb

  ## add inside module PersonDb too - why? why not?
  ##   keep shared with all indexers - why? why not?


class PlayerIndexer < Indexer

  def self.read( path )
    pack = SportDb::Package.new( path )   ## lets us use direcotry or zip archive

    recs = []
    pack.each_players do |entry|
      recs += SportDb::Import::PlayerReader.parse( entry.read )
    end
    recs

    add( recs )
  end
 

  def add( rec_or_recs )   ## add club record / alt_names
    recs = rec_or_recs.is_a?( Array ) ? rec_or_recs : [rec_or_recs]      ## wrap (single) rec in array

    recs.each do |rec|
      ## puts "adding:"
      ## pp rec
      ### step 1) add canonical name
      player = PersonDb::Model::Person.create!( name:       rec.name,
                                                alt_names:  rec.alt_names.empty? ? nil : rec.alt_names.join( ' | ' ), 
                                                nat:        rec.nat,
                                                height:     rec.height,
                                                birthdate:  rec.birthdate,
                                                birthplace: rec.birthplace,
                                                pos:        rec.pos, 
                                              )


     ## step 2) add all names (canonical name + alt names + alt names (auto))
      names = [rec.name]
      
     ## quick and dirty (first / last name) split 
     ##  cut off first name (and auto-add remaining names as last names) 
      values = rec.name.split( ' ' )
      if values.size > 1
        names << values[1..-1].join( ' ' )
      end

      names + rec.alt_names

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

      norms = norms.uniq  

      norms.each do |norm|
          PersonDb::Model::PersonName.create!( 
                                        person_id: player.id, 
                                        name:      norm )
      end
    end
  end # method add

end # class PlayerIndexer
end   # module CatalogDb
