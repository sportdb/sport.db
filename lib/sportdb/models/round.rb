
module SportDb
  module Model


class Round < ActiveRecord::Base

if ActiveRecord::VERSION::MAJOR == 3
  has_many :games, :order => 'pos'
else
  has_many :games, -> { order('pos') }
end

  belongs_to :event

end # class Round


  end # module Model
end # module SportDb


