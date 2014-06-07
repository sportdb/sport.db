module SportDb
  module Model


class AssocAssoc < ActiveRecord::Base
  self.table_name = 'assocs_assocs'

  belongs_to :assoc1, class_name: 'Assoc', foreign_key: 'assoc1_id'   # parent assoc
  belongs_to :assoc2, class_name: 'Assoc', foreign_key: 'assoc2_id'   # child assoc is_member_of parent assoc

end # class AssocAssoc


  end # module Model
end # module SportDb
