module Sports

##
#  note: check that shape/structure/fields/attributes match
#            the ActiveRecord model !!!!

## add city here
##   use module World - why? why not?

class City
  attr_reader   :key, :name, :country
  attr_accessor :alt_names

  def initialize( key: nil, 
                  name:, country: )
    ## note: auto-generate key "on-the-fly" if missing for now - why? why not?
    ## note: quick hack - auto-generate key, that is, remove all non-ascii chars and downcase
    @key       = key || unaccent(name).downcase.gsub( /[^a-z]/, '' ) + "_" + country.key
    @name      = name
    @country   = country
    @alt_names = []
  end
end  # class City


class Country

  ## note: is read-only/immutable for now - why? why not?
  ##          add cities (array/list) - why? why not?
  attr_reader   :key, :name, :code, :tags
  attr_accessor :alt_names

  def initialize( key: nil, name:, code:, tags: [] )
    ## note: auto-generate key "on-the-fly" if missing for now - why? why not?
    ## note: quick hack - auto-generate key, that is, remove all non-ascii chars and downcase
    @key = begin 
              if key
                key 
              elsif code
                 code.downcase
              else
                 unaccent( name ).downcase.gsub( /[^a-z]/, '' )
              end
            end
    @name, @code = name, code
    @alt_names      = []
    @tags           = tags
  end

end  # class Country

end   # module Sports

