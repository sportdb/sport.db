module SportDb
  module Model


class StageTeam < ActiveRecord::Base
  self.table_name = 'stages_teams'

  belongs_to :stage
  belongs_to :team
end # class StageTeam


  end # module Model
end # module SportDb
