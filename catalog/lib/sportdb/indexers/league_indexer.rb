
module CatalogDb


class LeagueIndexer < Indexer

  def self.build( path )
    pack = SportDb::Package.new( path )   ## lets us use direcotry or zip archive

    recs = []
    pack.each_leagues do |entry|
      recs += SportDb::Import::LeagueReader.parse( entry.read )
    end
    recs

    leagues = new
    leagues.add( recs )
    leagues
  end


  def add( rec_or_recs )   ## add club record / alt_names
    recs = rec_or_recs.is_a?( Array ) ? rec_or_recs : [rec_or_recs]      ## wrap (single) rec in array

    recs.each do |rec|
      ## puts "adding:"
      ## pp rec
      ### step 1) add canonical name
      league = Model::League.create!( key: rec.key,
                                      name: rec.name,
                                      ## alt_names
                                      clubs: rec.clubs?,
                                      intl:  rec.intl?, 
                                      country_key:  rec.country ? country( rec.country).key : nil
                                    )

      ## step 2) add all names (canonical name + alt names + alt names (auto))
      names = [rec.name] + rec.alt_names
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

      ## todo/fix: move alt_names_auto up for check unique names
      ##    e.g. remove/avoid auto-generated duplicates ENG 1, AUT 1, etc
      names += rec.alt_names_auto

      norms = names.map do |name|
        ## check lang codes e.g. [en], [fr], etc.
        ##  todo/check/fix:  move strip_lang up in the chain - check for duplicates (e.g. only lang code marker different etc.) - why? why not?
        name = strip_lang( name )
        norm = normalize( name )
        norm
      end

      norms = norms.uniq 

      norms.each do |norm|
          Model::LeagueName.create!( key:     league.key, 
                                     name:    norm )
      end
    end
  end # method add


end # class LeagueIndexer
end   # module CatalogDb

