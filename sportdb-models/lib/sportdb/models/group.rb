
module SportDb
  module Model


class Group < ActiveRecord::Base

if ActiveRecord::VERSION::MAJOR == 3
  has_many :games, order: 'pos'
else
  has_many :games, -> { order('pos') }
end

  belongs_to :event

  has_many :group_teams, class_name: 'GroupTeam'
  has_many :teams, :through => :group_teams

end # class Group
  
  
  end # module Model
end # module SportDb
