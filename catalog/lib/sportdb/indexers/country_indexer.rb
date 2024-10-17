
module CatalogDb



## built-in countries for (quick starter) auto-add
class CountryIndexer  < Indexer

  def add( rec_or_recs )
    recs = rec_or_recs.is_a?( Array ) ? rec_or_recs : [rec_or_recs]   ## wrap (single) rec in array
    ###########################################
    ## auto-fill countries
    ## pp recs
    recs.each do |rec|
      ## rec e.g. { key:'af', code:'AFG', name:'Afghanistan'}

      ## todo/check: use rec.attributes or such - why? why not?

      country = Model::Country.create!(
              key:       rec.key,
              code:      rec.code,
              name:      rec.name,
              ## use comma for alt names too - why? why not?
              alt_names: rec.alt_names ? rec.alt_names.join( ' | ' ) : nil,
              tags:      rec.tags      ? rec.tags.join( ', ' ) : nil,
       )
       pp country


       ## add codes lookups - key, code, ...
       ##   note - add code (only) if different from key
       rec.codes.each do |code|
        ## uncomment for debugging if db constraint error
=begin
         cc = Model::CountryCode.find_by( code: code )
         if cc
          puts "!! code #{code} already in use by:"
          pp cc
          puts "---"
          pp rec
          pp codes
         end
=end

         Model::CountryCode.create!( key:  country.key,
                                     code: code )
       end


      ##  add all names (canonical name + alt names
      names = rec.names
      more_names = []
      ## check "hand-typed" names for year (auto-add)
      ## check for year(s) e.g. (1887-1911), (-2013),
      ##                        (1946-2001,2013-) etc.
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

      norms = names.map do |name|
        ## check lang codes e.g. [en], [fr], etc.
        ##  todo/check/fix:  move strip_lang up in the chain - check for duplicates (e.g. only lang code marker different etc.) - why? why not?
        norm = strip_lang( name )
        norm = unaccent( norm )
        norm = normalize( norm )
        norm
      end

      norms = norms.uniq

      norms.each do |norm|
        Model::CountryName.create!( key:  country.key,
                                    name: norm )
      end
    end  ## each record
  end # method initialize


end # class CountryIndexer
end   # module CatalogDb
