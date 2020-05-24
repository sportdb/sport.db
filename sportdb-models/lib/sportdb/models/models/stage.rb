
module SportDb
  module Model


class Stage < ActiveRecord::Base

  has_many :matches, -> { order('pos') }, class_name: 'Match'

  belongs_to :event

  has_many :stage_teams, class_name: 'StageTeam'
  has_many :teams, :through => :stage_teams

end # class Stage


class StageTeam < ActiveRecord::Base
  self.table_name = 'stages_teams'

  belongs_to :stage
  belongs_to :team
end # class StageTeam

  end # module Model
end # module SportDb
