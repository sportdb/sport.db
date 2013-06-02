module SportDb::Models

class Track < ActiveRecord::Base

  has_many :races

  belongs_to :country, :class_name => 'WorldDb::Models::Country', :foreign_key => 'country_id'


  def self.create_or_update_from_values( new_attributes, values )

    ## fix: add/configure logger for ActiveRecord!!!
    logger = LogKernel::Logger.root

    ## check optional values
    values.each_with_index do |value, index|
      if value =~ /^[a-z]{2}$/  ## assume two-letter country key e.g. at,de,mx,etc.
        value_country = Country.find_by_key!( value )
        new_attributes[ :country_id ] = value_country.id
      else
        ## todo: assume title2 ??
        ## assume title2 if title2 is empty (not already in use)
        ##  and if it title2 contains at least two letter e.g. [a-zA-Z].*[a-zA-Z]
        # issue warning: unknown type for value
        logger.warn "unknown type for value >#{value}< - key #{new_attributes[:key]}"
      end
    end

    rec = Track.find_by_key( new_attributes[ :key ] )
    if rec.present?
      logger.debug "update Track #{rec.id}-#{rec.key}:"
    else
      logger.debug "create Track:"
      rec = Track.new
    end
      
    logger.debug new_attributes.to_json
   
    rec.update_attributes!( new_attributes )
  end # create_or_update_from_values


end  # class Track


end # module SportDb::Models