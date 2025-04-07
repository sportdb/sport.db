
### forward references
##   require first to resolve circular references

module SportDbV2
  module Model

  Prop      = ConfDb::Model::Prop

  ## note: for now only team and league use worlddb tables
  #   e.g. with belongs_to assoc (country,region)

  class Team   < ActiveRecord::Base ; end
  class League < ActiveRecord::Base ; end

  end

  ## add backwards compatible n convenience namespace
  Models = Model
end # module SportDb


