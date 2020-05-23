module SportDb
  module Model

class Assoc < ActiveRecord::Base


  has_many :parent_assoc_assocs, class_name: 'AssocAssoc', foreign_key: 'assoc2_id'
  ## child_assocs - use child_assocs?  - (direct) member/child assocs instead of member?
  has_many :member_assoc_assocs,  class_name: 'AssocAssoc', foreign_key: 'assoc1_id'


  ## note: split member_assocs into two sets (into national=true and national=false)
  # e.g. fifa has six member confederations (non-national) and 216 national assocs
  ## note: includes all member (sub assocs + national assocs) - rename to member_assocs?
  has_many :all_assocs, class_name: 'Assoc', :source => :assoc2, :through => :member_assoc_assocs
  ## use zone/region as name instead of sub ( for confederatons,zones,etc.)
  has_many :sub_assocs,      -> { where( national: false ) },  class_name: 'Assoc', :source => :assoc2, :through => :member_assoc_assocs
  has_many :national_assocs, -> { where( national: true )  },  class_name: 'Assoc', :source => :assoc2, :through => :member_assoc_assocs

  ## for now can have more than one (direct) parent assoc
  ##   e.g. Africa Fed and Arab League Fed
  has_many :parent_assocs, class_name: 'Assoc', :source => :assoc1, :through => :parent_assoc_assocs

  # assoc only can have one direct team for now (uses belongs_to on other side)
  # has_one :team
end  # class Assoc


  end # module Model
end # module SportDb
