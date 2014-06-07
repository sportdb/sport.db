module SportDb
  module Model

class Assoc < ActiveRecord::Base

  has_many :member_assoc_assocs, class_name: 'AssocAssoc', foreign_key: 'assoc1_id'
  has_many :parent_assoc_assocs, class_name: 'AssocAssoc', foreign_key: 'assoc2_id'

  ## child_assocs - use child_assocs?  - (direct) member/child assocs
  # has_many :member_assocs, class_name: 'Assoc', :through => :member_assoc_assocs
  #   assoc2 -> holds member key

  ## for now can have more than one (direct) parent assoc
  ##   e.g. Africa Fed and Arab League Fed
  ## has_many :parent_assocs, class_name: 'Assoc', :through => :parent_assoc_assocs
  #   assoc1 -> holds parent key

  # assoc only can have one direct team for now (uses belongs_to on other side) 
  # has_one :team


  def self.create_or_update_from_values( new_attributes, values )

    ## fix: add/configure logger for ActiveRecord!!!
    logger = LogUtils::Logger.root

    ## check optional values
    values.each_with_index do |value, index|
      if value =~ /^(18|19|20)[0-9]{2}$/  ## assume founding year -- allow 18|19|20
        ## logger.info "  founding/opening year #{value}"
        new_attributes[ :since ] = value.to_i
      elsif value =~ /\/{2}/  # assume it's an address line e.g.  xx // xx
        logger.info "  found address line #{value}"
        ## new_attributes[ :address ] = value
      elsif value =~ /^(?:[a-z]{2}\.)?wikipedia:/  # assume it's wikipedia e.g. [es.]wikipedia:
        logger.info "  found wikipedia line #{value}; skipping for now"
      elsif value =~ /(^www\.)|(\.com$)/  # FIX: !!!! use a better matcher not just www. and .com
        new_attributes[ :web ] = value
      ## elsif value =~ /^[a-z]{2}$/  ## assume two-letter country key e.g. at,de,mx,etc.
      ##  ## fix: allow country letter with three e.g. eng,sco,wal,nir, etc. !!!
      ##  value_country = Country.find_by_key!( value )
      ##  new_attributes[ :country_id ] = value_country.id
      else
        ## todo: assume title2 ??
        # issue warning: unknown type for value
        logger.warn "unknown type for value >#{value}< - key #{new_attributes[:key]}"
      end
    end

    rec = Assoc.find_by_key( new_attributes[ :key ] )
    if rec.present?
      logger.debug "update Assoc #{rec.id}-#{rec.key}:"
    else
      logger.debug "create Assoc:"
      rec = Assoc.new
    end

    logger.debug new_attributes.to_json
   
    rec.update_attributes!( new_attributes )
  end # create_or_update_from_values

end  # class Assoc


  end # module Model
end # module SportDb
