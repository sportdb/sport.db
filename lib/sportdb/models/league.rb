module SportDb
  module Model


class League < ActiveRecord::Base
  
  ## leagues also used for conferences, world series, cups, etc.
  #
  ## league (or cup/conference/series/etc.) + season (or year) = event
  
  has_many :events
  has_many :seasons, :through => :events
  
  belongs_to :country, :class_name => 'WorldDb::Model::Country', :foreign_key => 'country_id'


  def self.create_or_update_from_values( new_attributes, values )

    ## fix: add/configure logger for ActiveRecord!!!
    logger = LogKernel::Logger.root

    ## check optional values
    values.each_with_index do |value, index|
      if value =~ /^club$/   # club flag
        new_attributes[ :club ] = true
      elsif value =~ /^[a-z]{2}$/  ## assume two-letter country key e.g. at,de,mx,etc.
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

    logger.debug " find league key: #{new_attributes[ :key ]}"

    rec = League.find_by_key( new_attributes[ :key ] )
    if rec.present?
      logger.debug "update League #{rec.id}-#{rec.key}:"
    else
      logger.debug "create League:"
      rec = League.new
    end
      
    logger.debug new_attributes.to_json
   
    rec.update_attributes!( new_attributes )
  end # create_or_update_from_values



  def self.create_from_ary!( leagues, more_values={} )
    leagues.each do |values|
      
      ## key & title required
      attr = {
        key:   values[0],
        title: values[1]
      }
      
      attr = attr.merge( more_values )
      
      ## check for optional values
      values[2..-1].each do |value|
        if value.is_a? Country
          attr[ :country_id ] = value.id
        else
          # issue warning: unknown type for value
        end
      end

      League.create!( attr )
    end # each league
  end

end  # class League


  end # module Model
end # module SportDb
