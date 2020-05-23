
  def self.create_or_update_from_values( new_attributes, values )

    ## fix: add/configure logger for ActiveRecord!!!
    logger = LogUtils::Logger.root

    assoc_keys = []   # by default no association (e.g. fifa,uefa,etc.)

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
      elsif value =~ /^[a-z]{2}$/  ## assume two-letter country key e.g. at,de,mx,etc.
        ## fix: allow country letter with three e.g. eng,sco,wal,nir, etc. !!!
        ## fix: if country does NOT match / NOT found - just coninue w/ next match!!!!
        #   - just issue an error/warn do NOT crash
        value_country = Country.find_by_key!( value )
        new_attributes[ :country_id ] = value_country.id
        ## note: if country present - assume it's a national assoc, thus, set flag to true
        new_attributes[ :national ] = true
      elsif value =~ /^[a-z|]+$/   ##  looks like a tag list e.g. fifa|uefa or fifa|caf or ocf?
        logger.info "  trying adding assocs using keys >#{value}<"
        assoc_keys = value.split('|')
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

    unless assoc_keys.empty?
      ## add team to assocs
      assoc_keys.each do |assoc_key|
        assoc = Assoc.find_by_key!( assoc_key )
        logger.debug "  adding assoc to assoc >#{assoc.title}<"

        ### todo/fix: how can we delete assoc_assocs? for now only update n create
        assoc_assoc = AssocAssoc.where( assoc1_id: assoc.id, assoc2_id: rec.id ).first
        if assoc_assoc.nil?  ## create if does NOT exist yet
           AssocAssoc.create!( assoc1_id: assoc.id, assoc2_id: rec.id )
        end
      end
    end

  end # create_or_update_from_values
