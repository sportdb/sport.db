
module SportDb
  module Model


class Group < ActiveRecord::Base

  has_many :matches, -> { order('pos') }, class_name: 'Match'

  belongs_to :event

  has_many :group_teams, class_name: 'GroupTeam'
  has_many :teams, :through => :group_teams

end # class Group


  end # module Model
end # module SportDb
