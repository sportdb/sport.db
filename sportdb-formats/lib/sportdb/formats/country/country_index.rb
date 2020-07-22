# encoding: utf-8

module SportDb
module Import

## built-in countries for (quick starter) auto-add
class CountryIndex

  attr_reader :countries     ## all country records

  def initialize( recs )
    @countries         = []
    @countries_by_code = {}
    @countries_by_name = {}

    add( recs )
  end


  ## helpers from country - use a helper module for includes (share with clubs etc.) - why? why not?
  include NameHelper
  ## incl. strip_year( name )
  ##       has_year?( name)
  ##       strip_lang( name )
  ##       normalize( name )


  def add( recs )
    ###########################################
    ## auto-fill countries
    ## pp recs
    recs.each do |rec|
      ## rec e.g. { key:'af', code:'AFG', name:'Afghanistan'}

      @countries << rec

      ## add codes lookups - key, code, ...
      if @countries_by_code[ rec.key ]
        puts "** !! ERROR !! country code (key) >#{rec.key}< already exits!!"
        exit 1
      else
        @countries_by_code[ rec.key ] = rec
      end

      ## add  code (only) if different from key
      if rec.key != rec.code.downcase
        if @countries_by_code[ rec.code.downcase ]
          puts "** !! ERROR !! country code  >#{rec.code.downcase}< already exits!!"
          exit 1
        else
          @countries_by_code[ rec.code.downcase ] = rec
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



  ##  fix/todo: add  find_by (alias for find_by_name/find_by_code)
  def find_by_code( code )
    code = code.to_s.downcase   ## allow symbols (and always downcase e.g. AUT to aut etc.)
    @countries_by_code[ code ]
  end

  def find_by_name( name )
    name = normalize( name.to_s )  ## allow symbols too (e.g. use to.s first)
    @countries_by_name[ name ]
  end

  def find( key )
    country = find_by_code( key )
    country = find_by_name( key )  if country.nil?     ## try lookup / find by (normalized) name
    country
  end
  alias_method :[], :find


  ###
  ##   split/parse country line
  ##
  ##  split on bullet e.g.
  ##   split into name and code with regex - make code optional
  ##
  ##  Examples:
  ##    Österreich • Austria (at)
  ##    Österreich • Austria
  ##    Austria
  ##    Deutschland (de) • Germany
  ##
  ##   todo/check: support more formats - why? why not?
  ##       e.g.  Austria, AUT  (e.g. with comma - why? why not?)
  def parse( line )
    values = line.split( '•' )   ## use/support multi-lingual separator
    country = nil
    values.each do |value|
       value = value.strip
       ## check for trailing country code e.g. (at), (eng), etc.
       if value =~ /[ ]+\((?<code>[a-z]{1,4})\)$/  ## e.g. Austria (at)
         code =  $~[:code]
         name = value[0...(value.size-code.size-2)].strip  ## note: add -2 for brackets
         candidates = [ find_by_code( code ), find_by_name( name ) ]
         if candidates[0].nil?
           puts "** !!! ERROR !!! country - unknown code >#{code}< in line: #{line}"
           pp line
           exit 1
         end
         if candidates[1].nil?
           puts "** !!! ERROR !!! country - unknown name >#{code}< in line: #{line}"
           pp line
           exit 1
         end
         if candidates[0] != candidates[1]
           puts "** !!! ERROR !!! country - name and code do NOT match the same country:"
           pp line
           pp candidates
           exit 1
         end
         if country && country != candidates[0]
           puts "** !!! ERROR !!! country - names do NOT match the same country:"
           pp line
           pp country
           pp candidates
           exit 1
         end
         country = candidates[0]
       else
         ## just assume value is name or code
         candidate = find( value )
         if candidate.nil?
           puts "** !!! ERROR !!! country - unknown name or code >#{value}< in line: #{line}"
           pp line
           exit 1
         end
         if country && country != candidate
           puts "** !!! ERROR !!! country - names do NOT match the same country:"
           pp line
           pp country
           pp candidate
           exit 1
         end
         country = candidate
       end
    end
    country
  end # method parse
end # class CountryIndex


end   # module Import
end   # module SportDb
