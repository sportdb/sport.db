# encoding: utf-8

module SportDb
  module Model


class GroupStanding < ActiveRecord::Base

  self.table_name = 'group_standings'

  has_many   :entries, class_name: 'SportDb::Model::GroupStandingEntry', foreign_key: 'group_standing_id'
  belongs_to :group

end # class GroupStanding


  end # module Model
end # module SportDb
