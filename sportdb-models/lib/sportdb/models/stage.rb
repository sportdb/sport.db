
module SportDb
  module Model


class Stage < ActiveRecord::Base

if ActiveRecord::VERSION::MAJOR == 3
  has_many :games, order: 'pos'
else
  has_many :games, -> { order('pos') }
end

  belongs_to :event

  has_many :stage_teams, class_name: 'StageTeam'
  has_many :teams, :through => :stage_teams

end # class Stage

  end # module Model
end # module SportDb
