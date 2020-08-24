module Sports

##
#  note: check that shape/structure/fields/attributes match
#            the ActiveRecord model !!!!

class Country

  ## note: is read-only/immutable for now - why? why not?
  ##          add cities (array/list) - why? why not?
  attr_reader   :key, :name, :code, :tags
  attr_accessor :alt_names

  def initialize( key: nil, name:, code:, tags: [] )
    ## note: auto-generate key "on-the-fly" if missing for now - why? why not?
    ## note: quick hack - auto-generate key, that is, remove all non-ascii chars and downcase
    @key = key || name.downcase.gsub( /[^a-z]/, '' )
    @name, @code = name, code
    @alt_names      = []
    @tags           = tags
  end

end  # class Country

end   # module Sports

