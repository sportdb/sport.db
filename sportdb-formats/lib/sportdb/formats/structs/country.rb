# encoding: utf-8

module SportDb
  module Import

##
#  note: check that shape/structure/fields/attributes match
#            the ActiveRecord model !!!!

class Country

  ## note: is read-only/immutable for now - why? why not?
  ##          add cities (array/list) - why? why not?
  attr_reader   :key, :name, :fifa, :tags
  attr_accessor :alt_names

  def initialize( key:, name:, fifa:, tags: [] )
    @key, @name, @fifa = key, name, fifa
    @alt_names      = []
    @tags           = tags
  end

end  # class Country


end   # module Import
end   # module SportDb

