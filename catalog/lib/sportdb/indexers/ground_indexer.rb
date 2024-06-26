

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
 

## quick hack for alt names - add more / use text file
# cities.txt
# = Germany
# München | Munich [en]

  CITY_ALT_NAMES = {
    'München' => ['Munich'],    # en
    'Köln'    => ['Cologne'],   # en
    'Wien'    => ['Vienna'],    # en
    'Roma'    => ['Rome'],      # en
    'Sevilla'    => ['Seville'],    # en
    'København'  => ['Copenhagen'],  # en
    'București'  => ['Bucharest'],  # en
    #  'Copenhagen'
    ## quick hack
    ## add districts (or nearbys) for now too - why? why not?
    ##  e.g. Stade de France, Paris 
    ##       Stade de France, Paris (Saint-Denis)
    ##       Stade de France, Saint-Denis
    'Paris'   => ['Saint-Denis', 'Paris Saint-Denis'], 
  }

  ### move shortcuts to indexer base for (re)use - why? why not?
  def config() CatalogDb.config;  end
  ## def city?()    config.city?   end


  def add( rec_or_recs )   ## add club record / alt_names
    recs = rec_or_recs.is_a?( Array ) ? rec_or_recs : [rec_or_recs]      ## wrap (single) rec in array

    recs.each do |rec|
      ## puts "adding:"
      ## pp rec
      ### step 1) add canonical name


      ###
      ## todo/fix:
      ##   make (inline quick & dirty) city indexer more (re)usable
      ##    break out - why? why not?

      ### add city record if not yet added
      ## country =  country( rec.country )

      
      ##
      ## maybe change city table to place table ??
      ##         ## and support city/district in one lookup - why? why not?
      ##           e.g. Paris, Paris (Saint-Denis), Saint-Denis - why? why not?  

      ## Finds the first record matching the specified conditions. 
      ## There is no implied ordering so if order matters, you should specify it yourself.
      ##  If no record is found, returns nil. 
  
      attribs = {
        key:         rec.key,
        name:        rec.name,
        alt_names:   rec.alt_names.empty? ? nil : rec.alt_names.join( ' | ' ), 
        district:    rec.district,
        address:     rec.address,
        country_key: rec.country.key,
        geos:        rec.geos.nil? || rec.geos.empty?  ? nil : rec.geos.join( ' › ' )                
      }

      ## add (keep) city: as string to - why? why not?
      ## todo - use city_key (record) instead of city (string ) - why? why not?
      ##  note - now a config option

      if config.city?

        city = Model::City.find_by( name:        rec.city, 
                                    country_key: rec.country.key )
        if city.nil?
          ## (quick 6 dirty) auto-add
          city_alt_names = CITY_ALT_NAMES[ rec.city ] || []
          city_key = unaccent( rec.city ).downcase.gsub( /[^a-z]/, '' ) + "_" + rec.country.key
   
          city = Model::City.create!( 
                              key:         city_key,
                              name:        rec.city,
                              alt_names:   city_alt_names.empty? ? nil : city_alt_names.join( ' | ' ), 
                              country_key: rec.country.key
                          )
          ## add names for queries/lookups
          city_names = [rec.city] + city_alt_names
          city_names.each do |city_name|
             Model::CityName.create!(
                           key:   city.key,
                           name:  unaccent( city_name ).downcase.gsub( /[^a-z]/, '' )
                         )
          end
        end
        attribs[ :city_key ]  = city.key 
      else
        attribs[ :city_name ] = rec.city
      end
   
      ground = Model::Ground.create!( **attribs )
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
