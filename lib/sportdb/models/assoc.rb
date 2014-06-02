module SportDb
  module Model

class Assoc < ActiveRecord::Base

  has_many :assoc_teams, class_name: 'AssocTeam'
  has_many :teams, :through => :assoc_teams


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
