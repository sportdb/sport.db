# encoding: utf-8

module SportDb
  module Model


class GroupStandingEntry < ActiveRecord::Base

  self.table_name = 'group_standing_entries'

  belongs_to :group_standing
  belongs_to :team

end # class AlltimeStandingEntry


  end # module Model
end # module SportDb
