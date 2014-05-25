# encoding: utf-8

module SportDb
  module Model


class AlltimeStandingEntry < ActiveRecord::Base

  self.table_name = 'alltime_standing_entries'

  belongs_to :alltime_standing
  belongs_to :team
  
end # class AlltimeStandingEntry


  end # module Model
end # module SportDb
