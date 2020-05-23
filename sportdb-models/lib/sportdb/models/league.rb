module SportDb
  module Model


class League < ActiveRecord::Base

  ## leagues also used for conferences, world series, cups, etc.
  #
  ## league (or cup/conference/series/etc.) + season (or year) = event

  has_many :events
  has_many :seasons, :through => :events

  belongs_to :country, :class_name => 'WorldDb::Model::Country', :foreign_key => 'country_id'

end  # class League


  end # module Model
end # module SportDb
