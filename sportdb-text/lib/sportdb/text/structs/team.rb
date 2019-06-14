# encoding: utf-8

module SportDb
  module Struct



class Team
  attr_accessor  :name,
                 :alt_names,
                 :city,
                 :country


   ## add alias/compat - why? why not
   def title() @name; end
   def names()
     ary = [@name]
     ary += @alt_names  if @alt_names
     ary
   end   ## all names



  def initialize
    ## do nothing for now (use from_csv to setup data)
  end

  def self.create( **kwargs )
    self.new.update( kwargs )
  end

  def update( **kwargs )
    @name        = kwargs[:name]
    @alt_names   = kwargs[:alt_names]
    @city        = kwargs[:city]    ## use city struct - why? why not?
    ## todo: add country too

    self   ## note - MUST return self for chaining
  end
end # class Team


end # module Struct
end # module SportDb
