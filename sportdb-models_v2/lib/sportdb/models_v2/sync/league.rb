module SportDbV2
  module Sync
    class League

    def self.find_or_create( name: )
       rec = Model::League.find_by( name: name )
      if rec.nil?
         attribs = { name: name }

         rec = Model::League.create!( attribs )
       end
       rec
    end

  end # class League
end   # module Sync
end   # module SportDb

