
module CatalogDb



## built-in countries for (quick starter) auto-add
class CountryIndexer  < Indexer


  ######################
  # hack - add more alternate country codes
  #   vehicle (int'l) licene plate (e.g. A, D, E)
  #
  # note - do NOT use Ö for now (gets auto-changed to O on normailization)

  MORE_CODES = parse_data( <<TXT )
    ## europe
    Austria,   A
    Belgium,   B
    Germany,   D
    Spain,     E
    France,     F
    Hungary,      H
    Italy,      I
    Luxembourg,   L
    Malta,        M
    Norway,       N
    Portugal,     P
    Sweden,       S
    Vatican City, V 

    ## note - Great Britain (and UK) same record for now - keep - why?
    ##  add alternate codes (default is uk / GBR)
    Great Britain,  GB

    ## alternate fifa et al codes
    Monaco,  MON             

    ## old/historic fifa et al codes
    Romania, 	ROM                ## fifa code is ROU

    ## more codes (iso? ioc? alt?)
    Slovenia,               SLO     ## fifa code is SVN
    Bosnia and Herzegovina, BOS     ## fifa code is BIH
 
    Northern Ireland,       NIRL    ## fifa code is NIR
    Serbia,                 SER     ## fifa code is SRB
    Serbia,                 SERB    ## fifa code is SRB
    Kosovo,                 KOS     ## old fifa code is KVX??

    Latvia,                 LAT     ## fifa code is LVA
    Lithuania,              LIT     ## fifa code is LTU

    Burundi,                BUR      ## fifa code is BDI
    Tanzania,               TZA      ## fifa code is TAN
    Myanmar,                MMR      ## fifa code is MYA
      
    Taiwan,                 TWN      ## fifa code is TPE
    Turkmenistan,           TURK     ## fifa code is TKM
    Tajikistan,             TAJ      ## fifa code is TJK

    Nicaragua,              NIC      ## fifa code is NCA
    Saudi Arabia,           SAUD     ## fifa code is KSA
    Iran,                   IRI      ## fifa code is IRN
      
    ##  BAH in use by Bahmas!!! cannot use for Bahrain - sorry
    ## Bahrain,                BAH      ## fifa code is BHR

    ## asia & et al
    ##  do NOT use for now 
    ##   C (Cuba), G (Gabun), Q (Qatar),
    ##   K (Kambodscha), 
    ##   T (Thailand), Z (Zambia) - why? why not?
    Japan, J

    ## more quirky codes
    Sudan,     SUD   #   fifa code is SDN 
    Mongolia,  MGL   #   fifa code is MNG  

    ## add more??? 
    ##  todo/fix - add upstream to new alt_codes attribute - why? why not?
    ##  for more see
    ##  - note - kosovo has kos alt code in alt name already
    ##             use all upcase alt names as alt codes - why? why not?
    ##
    ##     https://en.wikipedia.org/wiki/Comparison_of_alphabetic_country_codes
TXT


   ## note - reduce - first arg is accumulator e.g. h(ash)
   COUNTRY_ALT_CODES = MORE_CODES.reduce({}) do |h,(name,code)|
                          codes = h[name] ||= []
                          codes << code
                          h
                        end



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
       codes = [rec.key]
       codes << rec.code   if rec.key != rec.code.downcase
       codes += COUNTRY_ALT_CODES[ rec.name] || []
       
       codes = codes.map { |code| code.downcase }  ## make sure all codes are downcased 
       codes.each do |code|

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
      names = [rec.name] + rec.alt_names
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
