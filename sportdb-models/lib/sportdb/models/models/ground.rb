
module SportDb
  module Model

class Ground < ActiveRecord::Base

  belongs_to :country, class_name: 'WorldDb::Model::Country', foreign_key: 'country_id'
  belongs_to :city,    class_name: 'WorldDb::Model::City',    foreign_key: 'city_id'

  has_many :matches

end # class Ground

  end # module Model
end # module SportDb

