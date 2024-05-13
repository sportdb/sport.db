
module CatalogDb
module Metal

class Country  < Record
     self.tablename = 'countries'

     self.columns = ['key', 
                     'name', 
                     'code',
                     'tags',
                     'alt_names']

      
     def self._build_country( row )
        ## note: cache structs by key (do NOT rebuild duplicates; reuse)
        @cache ||= Hash.new
        @cache[ row[0] ] ||= Sports::Country.new(
                                key: row[0],
                                name: row[1],
                                code: row[2]   
                             )
     end                
                     
  ##  fix/todo: add  find_by (alias for find_by_name/find_by_code)
  def self.find_by_code( code )
   code = code.to_s.downcase   ## allow symbols (and always downcase e.g. AUT to aut etc.)
   
   rows = execute( <<-SQL )
   SELECT #{self.columns.join(', ')}
   FROM countries 
   INNER JOIN country_codes ON countries.key  = country_codes.key
   WHERE country_codes.code = '#{code}' 
SQL
  rows 
   
     if rows.empty? 
        nil 
     else 
         _build_country( rows[0] )
     end
 end


  ## helpers from country - use a helper module for includes (share with clubs etc.) - why? why not?
  # include NameHelper
  extend SportDb::NameHelper
  ## incl. strip_year( name )
  ##       has_year?( name)
  ##       strip_lang( name )
  ##       normalize( name )


 def self.find_by_name( name )
   name = normalize( name.to_s )  ## allow symbols too (e.g. use to.s first)
   
   rows = execute( <<-SQL )
   SELECT #{self.columns.join(', ')}
   FROM countries 
   INNER JOIN country_names ON countries.key  = country_names.key
   WHERE country_names.name = '#{name}' 
SQL
  rows 

     if rows.empty? 
        nil 
     else 
         _build_country( rows[0] )
     end   
 end


 def self.find( key )
   country = find_by_code( key )
   country = find_by_name( key )  if country.nil?     ## try lookup / find by (normalized) name
   country
 end
 class << self
   alias_method :[], :find
 end

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
 def self.parse( line )
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
end  # class Country
end  # module Metal
end  # module CatalogDb
 