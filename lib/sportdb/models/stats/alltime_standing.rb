# encoding: utf-8

module SportDb
  module Model


class AlltimeStanding < ActiveRecord::Base

  self.table_name = 'alltime_standings'

  has_many :entries,  class_name: 'SportDb::Model::AlltimeStandingEntry', foreign_key: 'alltime_standing_id'

end # class AlltimeStanding


  end # module Model
end # module SportDb
