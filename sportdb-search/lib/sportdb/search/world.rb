module Sports


class City
    def self._search() CatalogDb::Metal::City; end

    def self.match_by( name: )
       _search.match_by( name: name )
    end
end   # class City


class Country
    def self._search() CatalogDb::Metal::Country; end

    def self.find_by( code: nil, name: nil )
        ## todo/fix upstream - change to find_by( code:, name:, ) too - why? why not?
        if code && name.nil?
          _search.find_by_code( code )
        elsif name && code.nil?
          _search.find_by_name( name )
        else
          raise ArgumentError, "Country#find_by - one (and only one arg) required - code: or name:"
        end
    end

    def self.find( q )   ## find by code (first) or name (second)
        _search.find_by_name_or_code( q )
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
 def self.parse_heading( line )
    values = line.split( '•' )   ## use/support multi-lingual separator
    country = nil
    values.each do |value|
       value = value.strip
       ## check for trailing country code e.g. (at), (eng), etc
       ##   allow code 1 to 5 for now - northern cyprus(fifa) with 5 letters?.
       ##     add/allow  gb-eng, gb-wal (official iso2!!), in the future too - why? why not?
       if value =~ /[ ]+\((?<code>[A-Za-z]{1,5})\)$/  ## e.g. Austria (at)
         code =  $~[:code]
         name = value[0...(value.size-code.size-2)].strip  ## note: add -2 for brackets
         candidates = [ find_by( code: code ), find_by( name: name ) ]
         if candidates[0].nil?
           puts "** !!! ERROR Country.parse_heading - unknown code >#{code}< in line: #{line}"
           pp line
           exit 1
         end
         if candidates[1].nil?
           puts "** !!! ERROR Country.parse_heading - unknown name >#{code}< in line: #{line}"
           pp line
           exit 1
         end
         if candidates[0] != candidates[1]
           puts "** !!! ERROR Country.parse_heading - name and code do NOT match the same country:"
           pp line
           pp candidates
           exit 1
         end
         if country && country != candidates[0]
           puts "** !!! ERROR Country.parse_heading - names do NOT match the same country:"
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
           puts "** !!! ERROR Country.parse_heading - unknown name or code >#{value}< in line: #{line}"
           pp line
           exit 1
         end
         if country && country != candidate
           puts "** !!! ERROR Country.parse_heading - names do NOT match the same country:"
           pp line
           pp country
           pp candidate
           exit 1
         end
         country = candidate
       end
    end
    country
  end # method parse_heading


   ## add alternate names/aliases
   class << self
    alias_method :[],      :find    ### keep shortcut - why? why not?
    alias_method :heading, :parse_heading
   end


# open question - what name to use build or  parse_line or ?
#                              or   parse_recs for CountryReader?
#          remove CountryReader helper methods - why? why not?
#   use parse_heading/heading for now !!!
#
#   def self.parse( line )  or build( line ) ??
#      SportDb::Import.world.countries.parse( line )
#   end
#
# !!!! note - conflict with
#     def self.read( path )  CountryReader.read( path ); end
#     def self.parse( txt )  CountryReader.parse( txt ); end
#
end # class Country
end  # module Sports