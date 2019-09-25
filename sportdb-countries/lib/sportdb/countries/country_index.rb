# encoding: utf-8

module SportDb
module Import

## built-in countries for (quick starter) auto-add
class CountryIndex

  def initialize( recs )
    @countries         = []
    @countries_by_code = {}
    @countries_by_name = {}

    add( recs )
  end


  ## helpers from country - use a helper module for includes (share with clubs etc.) - why? why not?
  def strip_year( name ) Country.strip_year( name ); end
  def has_year?( name)   Country.has_year?( name ); end
  def strip_lang( name ) Country.strip_lang( name ); end
  def normalize( name )  Country.normalize( name ); end


  def add( recs )
    ###########################################
    ## auto-fill countries
    ## pp recs
    recs.each do |rec|
      ## rec e.g. { key:'af', fifa:'AFG', name:'Afghanistan'}

      @countries << rec

      ## add codes lookups - key, fifa, ...
      if @countries_by_code[ rec.key ]
        puts "** !! ERROR !! country code (key) >#{rec.key}< already exits!!"
        exit 1
      else
        @countries_by_code[ rec.key ] = rec
      end

      ## add fifa code (only) if different from key
      if rec.key != rec.fifa.downcase
        if @countries_by_code[ rec.fifa.downcase ]
          puts "** !! ERROR !! country code (fifa) >#{rec.fifa.downcase}< already exits!!"
          exit 1
        else
          @countries_by_code[ rec.fifa.downcase ] = rec
        end
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

      names.each_with_index do |name,i|
        ## check lang codes e.g. [en], [fr], etc.
        ##  todo/check/fix:  move strip_lang up in the chain - check for duplicates (e.g. only lang code marker different etc.) - why? why not?
        name = strip_lang( name )
        norm = normalize( name )
        old_rec = @countries_by_name[ norm ]
        if old_rec
          ## check if country name already is included or is new country rec
            msg = "** !!! ERROR !!! - name conflict/duplicate - >#{name}< will overwrite >#{old_rec.name}< with >#{rec.name}<"
            puts msg
            exit 1
        else
          @countries_by_name[ norm ] = rec
        end
      end

    end  ## each record
  end # method initialize



  def []( key )
    code = key.to_s.downcase   ## allow symbols (and always downcase e.g. AUT to aut etc.)
    country = @countries_by_code[ code ]
    if country.nil?     ## try by (normalized) name
       name = normalize( key.to_s )
       country = @countries_by_name[ name ]
    end
    country
  end

##  fix/todo: add find_by_name and find_by_code and find_by
#  def find_by_name( name )
#  end
#  def find_by_code( code )
#  end
end # class CountryIndex


end   # module Import
end   # module SportDb
