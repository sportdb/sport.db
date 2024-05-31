

module CatalogDb


class ClubIndexer < Indexer

  def self.read( path )
    pack = SportDb::Package.new( path )   ## lets us use direcotry or zip archive

    recs = []
    pack.each_clubs do |entry|
      recs += SportDb::Import::ClubReader.parse( entry.read )
    end
    recs

    add( recs )

    ## add wiki(pedia) anchored links
    # recs = []
    # pack.each_clubs_wiki do |entry|
    #   recs += WikiReader.parse( entry.read )
    # end

    # pp recs
    # clubs.add_wiki( recs )
  end
 

 

  def strip_wiki( name )     # todo/check: rename to strip_wikipedia_en - why? why not?
    ##  change/rename to strip_wiki_qualifier or such - why? why not?
    ## note: strip disambiguationn qualifier from wikipedia page name if present
    ##        note: only remove year and foot... for now
    ## e.g. FC Wacker Innsbruck (2002) => FC Wacker Innsbruck
    ##      Willem II (football club)  => Willem II
    ##
    ## e.g. do NOT strip others !! e.g.
    ##   América Futebol Clube (MG)
    ##  only add more "special" cases on demand (that, is) if we find more
    name = name.gsub( /\([12][^\)]+?\)/, '' ).strip  ## starting with a digit 1 or 2 (assuming year)
    name = name.gsub( /\(foot[^\)]+?\)/, '' ).strip  ## starting with foot (assuming football ...)
    name
  end

  def add_wiki( rec_or_recs )   ## add wiki(pedia club record / links
    recs = rec_or_recs.is_a?( Array ) ? rec_or_recs : [rec_or_recs]      ## wrap (single) rec in array

    recs.each do |rec|
      ## note: strip qualifier () from wikipedia page name if present
      ## e.g. FC Wacker Innsbruck (2002) => FC Wacker Innsbruck
      ##      Willem II (football club)  => Willem II
      ##
      ## e.g. do NOT strip others !! e.g.
      ##   América Futebol Clube (MG)
      ##  only add more "special" cases on demand (that, is) if we find more
      name = strip_wiki( rec.name )

      m = match_by( name: name, country: rec.country )
      if m.nil?
        puts "** !!! ERROR !!! - no matching club found for wiki(pedia) name >#{name}, #{rec.country.name} (#{rec.country.key})<; sorry - to fix add name to clubs"
        exit 1
      end
      if m.size > 1
        puts "** !!! ERROR !!! - too many (greater than one) matching clubs found for wiki(pedia) name >#{name}, #{rec.country.name} (#{rec.country.key})<"
        pp m
        exit 1
      end
      club = m[0]
      club.wikipedia = rec.name
    end
  end  # method add_wiki


  def add( rec_or_recs )   ## add club record / alt_names
    recs = rec_or_recs.is_a?( Array ) ? rec_or_recs : [rec_or_recs]      ## wrap (single) rec in array

    recs.each do |rec|
      ## puts "adding:"
      ## pp rec
      ### step 1) add canonical name

###
## check for unique name and report error!!

      club = Model::Club.find_by( name: rec.name )
      if club
        puts "!! ERROR - found club with same name:"
        pp club
        puts "cannot add; sorry:"
        pp rec
      end

      club = Model::Club.create!(
                    key:        rec.key,
                    name:       rec.name,
                    alt_names:  rec.alt_names.empty? ? nil : rec.alt_names.join( ' | ' ), 
                    code:       rec.code, 
                    city:       rec.city,
                    district:   rec.district,
                    address:    rec.address, 
                    country_key:  country( rec.country ).key,
                    geos:       rec.geos.nil? || rec.geos.empty?  ? nil : rec.geos.join( ' › ' )                                                  
      )
      pp club
   
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
          Model::ClubName.create!( key:    club.key, 
                                   name:    norm )
      end
    end
  end # method add
end # class ClubIndexer
end   # module CatalogDb
