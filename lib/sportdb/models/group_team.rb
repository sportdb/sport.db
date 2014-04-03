module SportDb
  module Model


class GroupTeam < ActiveRecord::Base
  self.table_name = 'groups_teams'
  
  belongs_to :group
  belongs_to :team
end # class GroupTeam


  end # module Model
end # module SportDb
