###
#
#  move the name variant generation out of the structs
#     keep structs "to the metal"
#    maybe add later to index downstream - why? why not?


class Ground
 ## special import only attribs
 attr_accessor :alt_names_auto    ## auto-generated alt names


 def duplicates?
    names = [name] + alt_names + alt_names_auto
    names = names.map { |name| normalize( sanitize(name) ) }

    names.size != names.uniq.size
  end

  def duplicates
    names = [name] + alt_names + alt_names_auto

    ## calculate (count) frequency and select if greater than one
    names.reduce( {} ) do |h,name|
       norm = normalize( sanitize(name) )
       h[norm] ||= []
       h[norm] << name; h
    end.select { |norm,names| names.size > 1 }
  end

  def add_variants( name_or_names )
    names = name_or_names.is_a?(Array) ? name_or_names : [name_or_names]
    names.each do |name|
      name = sanitize( name )
      self.alt_names_auto += variants( name )
    end
  end

  ##############################
  ## helper methods for import only??
  ## check for duplicates
  include SportDb::NameHelper
end


# ----

def add_alt_names( rec, names )   ## helper for adding alternat names
    ## strip and  squish (white)spaces
    #   e.g. New York FC      (2011-)  => New York FC (2011-)
    #
    #  move remove $ and squish  upstream to indexer - why? why not? 
  
    names = names.map { |name| name.gsub( '$', '' ).gsub( /[ \t\u00a0]+/, ' ' ).strip }
  
    rec.alt_names += names
    rec.add_variants( names ) # auto-add (possible) auto-generated variant names
  
    ## check for duplicates
    if rec.duplicates?
      duplicates = rec.duplicates
      puts "*** !!! WARN !!! - #{duplicates.size} duplicate alt name mapping(s):"
      pp duplicates
      pp rec
      ##
      ##  todo/fix:  make it only an error with exit 1
      ##               if (not normalized) names are the same (not unique/uniq)
      ##                  e.g. don't exit on  A.F.C. == AFC etc.
      ## exit 1
    end
  end
  