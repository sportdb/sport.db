
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
      league = Model::League.create!( key:        rec.key,
                                      name:       rec.name,
                                      alt_names:  rec.alt_names.empty? ? nil : rec.alt_names.join( ' | ' ), 
                                      clubs:      rec.clubs?,
                                      intl:       rec.intl?, 
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

      norms = names.map do |name|
        ## check lang codes e.g. [en], [fr], etc.
        ##  todo/check/fix:  move strip_lang up in the chain - check for duplicates (e.g. only lang code marker different etc.) - why? why not?
        norm = strip_lang( name )
        norm = unaccent( norm )
        norm = normalize( norm )
        norm
      end

      norms = norms.uniq 

      ## auto-add country upfront e.g.
      ##   English Premier League  =>  England - English Premier League
      ##   Premier League          =>  England - Premier League
      ##  etc.
      ##
      ##  note - must be league for clubs and not intl!!!
      ##   maybe later add continent (e.g. Europe / Asia etc.)
      if rec.country 
        country_norm =  normalize( unaccent( country( rec.country ).name ))

        norms += norms.map { |norm| country_norm + norm }
      end

      ##  add more alt names 
      alt_names_auto = gen_alt_names( rec )
      alt_names_auto = alt_names_auto.map { |name| normalize( unaccent( name)) }

      norms += alt_names_auto 

      norms = norms.uniq 
  
      norms.each do |norm|
          Model::LeagueName.create!( key:     league.key, 
                                     name:    norm )
      end
    end
  end # method add



  def gen_alt_names( rec )   ## was alt_names_auto

    alt_names_auto = []

    ## always auto add key
    alt_names_auto <<  rec.key  

    if rec.country
      country                = rec.country
      ## note: split key into country + league key on FIRST dot !!!
      dot = rec.key.index( '.' )
      country_key = rec.key[0..dot-1]
      league_key  = rec.key[dot+1..-1]

      ## todo/check: add "hack" for cl (chile) and exclude?
      ##             add a list of (auto-)excluded country codes with conflicts? why? why not?
      ##                 cl - a) Chile  b) Champions League

      ## add shortcut for top level 1 (just country key)
      alt_names_auto <<   country.key    if league_key == '1'   
      if country.key != country.code.downcase
        alt_names_auto << "#{country.code} #{league_key}"
        alt_names_auto <<  country.code    if league_key == '1'   ## add shortcut for top level 1 (just country key)
      end
      alt_names_auto << "#{country.name} #{league_key}"  
    end

    ## pp alt_names_auto
    alt_names_auto
  end
  
end # class LeagueIndexer
end   # module CatalogDb

