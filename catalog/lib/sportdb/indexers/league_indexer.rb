
module CatalogDb


class LeagueIndexer < Indexer

  def self.read( path )
    pack = SportDb::Package.new( path )   ## lets us use direcotry or zip archive

    recs = []
    pack.each_leagues do |entry|
      recs += SportDb::Import::LeagueReader.parse( entry.read )
    end
    recs

    add( recs )
  end


## note: split names into names AND codes
##      1)  key plus all lower case names are codes
##      2)    all upper case names are names AND codes
##      3)    all other names are names

## only allow asci a to z (why? why not?)
##  excludes Ö1 or such (what else?)
IS_CODE_N_NAME_RE = %r{^
                           [\p{Lu}0-9. ]+
                       $}x
## add space (or /) - why? why not?
IS_CODE_RE           = %r{^
                            [\p{Ll}0-9.]+
                        $}x

  def add( rec_or_recs )   ## add club record / alt_names
    recs = rec_or_recs.is_a?( Array ) ? rec_or_recs : [rec_or_recs]      ## wrap (single) rec in array

    recs.each do |rec|
      ## puts "adding:"
      ## pp rec
      ### step 1) add canonical name

      ## todo/check: use/add a codes attribute/column - why? why not?

      league = Model::League.create!( key:        rec.key,
                                      name:       rec.name,
                                      alt_names:  rec.alt_names.empty? ? nil : rec.alt_names.join( ' | ' ),
                                      clubs:      rec.clubs?,
                                      intl:       rec.intl?,
                                      country_key:  rec.country ? rec.country.key : nil
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

    ###
    ## split names into names AND codes
        mixed      = rec.alt_names
        names      = [rec.name]
        more_codes = []

        mixed.each do |name|
          if IS_CODE_N_NAME_RE.match?( name )
            names << name
            more_codes << name    ## downcase here (or "automagic" with normalize later?)
          elsif IS_CODE_RE.match?( name )
            more_codes << name
          else
            ## assume name
            names << name
          end
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
        prefixes = []
        prefixes += rec.country.names
        prefixes += rec.country.adjs    # adjectives

        # puts "qname (country) prefixes:"
        # pp prefixes

        prefixes = prefixes.map {|prefix| normalize( unaccent( prefix )) }
        prefixes = prefixes.uniq
        # pp prefixes

        prefixes.each do |prefix|
          norms += norms.map { |norm| prefix + norm }
        end

        ## auto-add Austria 1 or such - why? why not?
        ##  alt_names_auto << "#{country.name} #{league_key}"
      end

      norms = norms.uniq
      norms.each do |norm|
          Model::LeagueName.create!( key:     league.key,
                                     name:    norm )
      end


      ####
      ##  auto add codes

     ## get codes via (league) periods
     codes = rec.periods.map { |period| period.key }
     codes = codes.uniq

     if rec.country
       codes.each do |code|
         alt_codes_auto = gen_alt_codes( code, country: rec.country )
         codes += alt_codes_auto
       end
     end

     codes += more_codes

      ##  todo/fix:
      ## use a special normalize formula for codes??
      ##   e.g. do NOT unaccent - why? why not?
      ##    only downcase (and strip dot(.) etc.)
      ##    allow ö or ö1 or such - why? why not?
      ##  without translit to o and o1??
      norms = codes.map { |code| normalize( code ) }
      norms = norms.uniq

      puts "codes:"
      pp norms

      norms.each do |norm|
          Model::LeagueCode.create!( key:     league.key,
                                     code:    norm )
      end


      #########################
      ### add league periods
      rec.periods.each do |period|
        pp period
        period_rec = Model::LeaguePeriod.create!( key:          league.key,
                                                  tier_key:     period.key,
                                                  name:         period.name,
                                                  qname:        period.qname,
                                                  slug:         period.slug,
                                                  prev_name:    period.prev_name,
                                                  start_season: period.start_season ? period.start_season.to_s : nil,
                                                  end_season:   period.end_season ? period.end_season.to_s : nil )
      end
    end
  end # method add



  def gen_alt_codes( code, country: )
     self.class.gen_alt_codes( code, country: country )
  end

  def self.gen_alt_codes( code, country: )
      alt_codes_auto = []

      ## note: split key into country + league key on FIRST dot !!!
      dot = code.index( '.' )
      if dot   ## note - skip if not using dot format (e.g. at.1 etc.)
        country_key = code[0..dot-1]
        league_key  = code[dot+1..-1]

        codes = country.codes
        ## double check/assert that code is a matching country code
        if !codes.include?( country_key )
           puts "!! ASSERT ERROR - no matching country code found for #{code}"
           pp country
           exit 1
        end

        ## add shortcut for top level 1 (just country key)
        if league_key == '1'
          alt_codes_auto += codes
        end

        codes.each do |alt_code|
          if country_key != alt_code
            alt_codes_auto << "#{alt_code} #{league_key}"
          end
        end
      end

    ## pp alt_codes_auto
    alt_codes_auto
  end

end # class LeagueIndexer
end   # module CatalogDb

