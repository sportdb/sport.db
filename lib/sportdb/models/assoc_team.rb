module SportDb
  module Model


class AssocTeam < ActiveRecord::Base
  self.table_name = 'assocs_teams'

  belongs_to :assoc
  belongs_to :team

end # class AssocTeam


  end # module Model
end # module SportDb
