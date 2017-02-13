# encoding: utf-8

module SportDb
  module Model


class GroupStandingEntry < ActiveRecord::Base

  self.table_name = 'group_standing_entries'

  belongs_to :standing, class_name: 'SportDb::Model::GroupStanding', foreign_key: 'group_standing_id'
  belongs_to :team

  ## note:
  ##  map standing_id to group_standing_id - convenience alias
  def standing_id=(value)  write_attribute(:group_standing_id, value);  end

end # class GroupStandingEntry


  end # module Model
end # module SportDb
