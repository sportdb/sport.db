module SportDb::Model

class Ground < ActiveRecord::Base

  belongs_to :country, class_name: 'WorldDb::Model::Country', foreign_key: 'country_id'
  belongs_to :city,    class_name: 'WorldDb::Model::City',    foreign_key: 'city_id'


  def self.create_or_update_from_values( new_attributes, values )

    ## fix: add/configure logger for ActiveRecord!!!
    logger = LogKernel::Logger.root

    ## check optional values
    logger.debug "  [Ground]  values >#{values.join('<>')}<"

    values.each_with_index do |value, index|
      if value =~ /^[12][0-9]{3}$/  ## assume founding year
        # skip founding/opening year fow now
        logger.info "  found year #{value}; skipping for now"
      elsif value =~ /^[1-9][0-9_]+[0-9]$/   # number; assume capacity e.g. 12_541 or similar
        # todo/fix: check how to differentiate between founding year and capacity if capcity islike year
        #  - by position ??  year is first entry, capacity is second ??? -add/fix

        # skip capacity
        logger.info "  found capacity #{value}; skipping for now"
      elsif value =~ /^[A-Z]{1,3}$/  # assume; state/region code e-g B | TX etc.
        # skip region/state code
        logger.info "  found region/state code #{value}; skipping for now"
      elsif value =~ /\/{2}/  # assume it's an address line e.g.  xx // xx
        logger.info "  found address line #{value}; skipping for now"
      elsif value =~ /^clubs:/ # assume it's clubs line  e.g. clubs: Santos
        logger.info "  found clubs line #{value}; skipping for now"
      elsif value =~ /^(?:[a-z]{2}\.)?wikipedia:/  # assume it's wikipedia e.g. [es.]wikipedia:
        logger.info "  found wikipedia line #{value}; skipping for now"
      else
        logger.info "  found city >#{value}< for ground >#{new_attributes[ :key ]}<"

        ## todo: assume title2 ??
        ## assume title2 if title2 is empty (not already in use)
        ##  and if it title2 contains at least two letter e.g. [a-zA-Z].*[a-zA-Z]
        # issue warning: unknown type for value
        # logger.warn "unknown type for value >#{value}< - key #{new_attributes[:key]}"
      end
    end

    logger.debug " find ground key: #{new_attributes[ :key ]}"

    rec = Ground.find_by_key( new_attributes[ :key ] )
    if rec.present?
      logger.debug "update Ground #{rec.id}-#{rec.key}:"
    else
      logger.debug "create Ground:"
      rec = Ground.new
    end

    logger.debug new_attributes.to_json
   
    rec.update_attributes!( new_attributes )
  end # create_or_update_from_values


end # class Ground

end # module SportDb::Model
