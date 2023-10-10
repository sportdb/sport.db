# encoding: UTF-8

module PersonDb
  module Model

class Person < ActiveRecord::Base

  self.table_name = 'persons'

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

      #### fix: use more generic/better date reader (allow more formats!!!)
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


    ####################################################
    # title-ize / normal-ize names (titles/synonyms)

    ##
    ##  make sure title and synonyms do NOT use all UPPERCASE
    ##   e.g. convert Neymar DA SILVA SANTOS to Neymar Da Sliva Santos etc.

    ### fix:  add auto camelcase/titlecase
    ## move to textutils
    ##  make it an option for name to auto Camelcase/titlecase?
    ##  e.g. BONFIM COSTA SANTOS    becomes
    ##       Bonfim Costa Santos  etc.
    ##  fix: better move into person parser?
    ##   store all alt_names titleized!!!

    raw_title = new_attributes[ :title ]
    new_title = titleize( raw_title )
    if raw_title != new_title
      logger.debug "  change person title/name to <#{new_title}> from >#{raw_title}<"
      new_attributes[ :title ] = new_title
    end

    raw_synonyms = new_attributes[ :synonyms ]
    if raw_synonyms.present?
       new_synonyms = raw_synonyms.split('|').map { |value| titleize(value) }.join('|')
       
       if raw_synonyms != new_synonyms
         logger.debug "  change person synonyms/alt_names to <#{new_synonyms}> from >#{raw_synonyms}<"
         new_attributes[ :synonyms ] = new_synonyms
       end
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

private


  def self.titleize( str )    # note: added as class-level method for self.create etc.
    ## fix: for now works only with ASCII only
    ##  words 2 letters and ups
    ##  fix also allow words w/ quote e.g.  O'Connor etc.
    str.gsub(/\b[A-Z]{2,}\b/) { |match| match.capitalize }
  end

end # class Person

  end # module Model
end # module PersonDb
