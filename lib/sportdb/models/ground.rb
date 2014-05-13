
module SportDb
  module Model

class Ground < ActiveRecord::Base

  belongs_to :country, class_name: 'WorldDb::Model::Country', foreign_key: 'country_id'
  belongs_to :city,    class_name: 'WorldDb::Model::City',    foreign_key: 'city_id'

  has_many :games


  def self.create_or_update_from_values( new_attributes, values )

    ## fix: add/configure logger for ActiveRecord!!!
    logger = LogKernel::Logger.root

    ## check optional values
    logger.debug "  [Ground]  values >#{values.join('<>')}<"

    city_title = ''

    values.each_with_index do |value, index|
      if value =~ /^(19|20)[0-9]{2}$/  ## assume founding year -- allow 19|20
        logger.info "  founding/opening year #{value}"
        new_attributes[ :since ] = value.to_i
      elsif value =~ /^[1-9][0-9_]+[0-9]$/   # number; assume capacity e.g. 12_541 or similar
        # todo/fix: check how to differentiate between founding year
        # and capacity if capcity islike year
        #  need to use _ e.g. 1_999 not 1999 and will get added as capacity !!!
        #  - by position ??  year is first entry, capacity is second ??? -add/fix

        logger.info "  found capacity #{value}"
        new_attributes[ :capacity ] = value.gsub('_', '').to_i
      elsif value =~ /^[A-Z]{1,3}$/  # assume; state/region code e-g B | TX etc.
        # skip region/state code
        logger.info "  found region/state code #{value}; skipping for now"
      elsif value =~ /\/{2}/  # assume it's an address line e.g.  xx // xx
        logger.info "  found address line #{value}"
        new_attributes[ :address ] = value
      elsif value =~ /^clubs:/ # assume it's clubs line  e.g. clubs: Santos
        logger.info "  found clubs line #{value}; skipping for now"
      elsif value =~ /^(?:[a-z]{2}\.)?wikipedia:/  # assume it's wikipedia e.g. [es.]wikipedia:
        logger.info "  found wikipedia line #{value}; skipping for now"
      elsif value =~ /GMT[+-][0-9]/ # dirrty hack for time zones
        logger.info "  found time zone #{value}"
        new_attributes[ :timezone ] = value
      else
        logger.info "  found city >#{value}< for ground >#{new_attributes[ :key ]}<"

        city_title = value.dup   # remember for auto-add city

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

    #### try to auto-add city

    if city_title.present?

      ### todo/fix: strip city_title subtitles e.g. Hamburg (Hafen) becomes Hamburg etc.
      city_values = [city_title]
      city_attributes = {
        country_id: rec.country_id,
        # region_id:  rec.region_id    ### todo/fix: add region if present
      }

      # todo: add convenience helper create_or_update_from_title
      city = City.create_or_update_from_values( city_values, city_attributes )

      ### fix/todo: set new autoadd flag too?
      ##  e.g. check if updated? e.g. timestamp created <> updated otherwise assume created?

      ## now at last add city_id to brewery!
      rec.city_id = city.id
      rec.save!
    end
  end # create_or_update_from_values


end # class Ground

  end # module Model
end # module SportDb
