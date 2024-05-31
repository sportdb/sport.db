

module CatalogDb


class GroundIndexer < Indexer

  def self.read( path )
    pack = SportDb::Package.new( path )   ## lets us use direcotry or zip archive

    recs = []
    pack.each_grounds do |entry|
      recs += SportDb::Import::GroundReader.parse( entry.read )
    end
    recs

    ## return db records on add - why? why not?
    add( recs )
  end
 
  
  def add( rec_or_recs )   ## add club record / alt_names
    recs = rec_or_recs.is_a?( Array ) ? rec_or_recs : [rec_or_recs]      ## wrap (single) rec in array

    recs.each do |rec|
      ## puts "adding:"
      ## pp rec
      ### step 1) add canonical name

      ground = Model::Ground.create!(
                    key:        rec.key,
                    name:       rec.name,
                    alt_names:  rec.alt_names.empty? ? nil : rec.alt_names.join( ' | ' ), 
                    city:       rec.city,   ## note: city for now a string 
                    district:   rec.district,
                    address:    rec.address,
                    country_key:  country( rec.country ).key,
                    geos:       rec.geos.nil? || rec.geos.empty?  ? nil : rec.geos.join( ' › ' )                
      )
      pp ground

      ## step 2) add all names (canonical name + alt names + alt names (auto))
      names = [rec.name] + rec.alt_names

      ## check "hand-typed" names for year (auto-add)
      ## check for year(s) e.g. (1887-1911), (-2013),
      ##                        (1946-2001,2013-) etc.
      more_names = []
      names.each do |name|
        if has_year?( name )
          more_names <<  strip_year( name )
        end
      end

      names += more_names
      
      ## check for duplicates - simple check for now - fix/improve
      ## todo/fix: (auto)remove duplicates - why? why not?
      count      = names.size
      count_uniq = names.uniq.size
      if count != count_uniq
        puts "** !!! ERROR !!! - #{count-count_uniq} duplicate name(s):"
        pp names
        pp rec
        exit 1
      end

      ####
      #   note:
      ##    for now only add
      ##      - 1st unaccent
      ##      - 2nd downcase
      ##      - 3rd 
      norms = names.map do |name|
        ## check lang codes e.g. [en], [fr], etc.
        ##  todo/check/fix:  move strip_lang up in the chain - check for duplicates (e.g. only lang code marker different etc.) - why? why not?
        norm = strip_lang( name )
        norm = unaccent( norm ).downcase     
        norm = normalize( norm )
        norm
      end

      norms = norms.uniq  

      norms.each do |norm|
          Model::GroundName.create!( key:   ground.key, 
                                     name:  norm )
      end
    end
  end # method add
end # class GroundIndexer
end   # module CatalogDb
