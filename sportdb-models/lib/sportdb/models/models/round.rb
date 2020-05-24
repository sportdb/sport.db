
module SportDb
  module Model


class Round < ActiveRecord::Base

  has_many :matches, -> { order('pos') }, class_name: 'Match'

  belongs_to :event

end # class Round


  end # module Model
end # module SportDb

