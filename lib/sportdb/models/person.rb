module SportDb::Model


class Person < ActiveRecord::Base
  self.table_name = 'persons'  #  avoids possible "smart" plural inflection to people

  has_many :goals

  belongs_to :country, :class_name => 'WorldDb::Model::Country', :foreign_key => 'country_id'


  def title()       name               end  # alias for name
  def title=(value) self.name = value  end  # alias for name


  def self.create_or_update_from_values( new_attributes, values )

    ## fix: add/configure logger for ActiveRecord!!!
    logger = LogKernel::Logger.root

    ## check optional values
    values.each_with_index do |value, index|
      if value =~ /^[a-z]{2}$/  ## assume two-letter country key e.g. at,de,mx,etc.
        value_country = Country.find_by_key!( value )
        new_attributes[ :country_id ] = value_country.id
      elsif value =~ /^[A-Z]{3}$/  ## assume three-letter code e.g. AUS, MAL, etc.
        new_attributes[ :code ] = value
      elsif value =~ /^([0-9]{1,2})\s(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s([0-9]{4})$/  ## assume birthday
        value_date_str = '%02d/%s/%d' % [$1, $2, $3]     ## move to matcher!!
        value_date = Date.strptime( value_date_str, '%d/%b/%Y' )  ## %b - abbreviated month name (e.g. Jan,Feb, etc.)
        logger.debug "   birthday #{value_date_str}  -  #{value_date}"
        new_attributes[ :born_at ] = value_date
        ## todo: convert to date
      else
        ## todo: assume title2 ??
        ## assume title2 if title2 is empty (not already in use)
        ##  and if it title2 contains at least two letter e.g. [a-zA-Z].*[a-zA-Z]
        # issue warning: unknown type for value
        logger.warn "unknown type for value >#{value}< - key #{new_attributes[:key]}"
      end
    end

    ## quick hack: set nationality_id if not present to country_id
    if new_attributes[ :nationality_id ].blank?
      new_attributes[ :nationality_id ] = new_attributes[ :country_id ]
    end

    rec = Person.find_by_key( new_attributes[ :key ] )
    if rec.present?
      logger.debug "update Person #{rec.id}-#{rec.key}:"
    else
      logger.debug "create Person:"
      rec = Person.new
    end
      
    logger.debug new_attributes.to_json
   
    rec.update_attributes!( new_attributes )
  end # create_or_update_from_values


end  # class Person


end # module SportDb::Model

