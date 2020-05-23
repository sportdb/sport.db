def self.create_or_update_from_values( new_attributes, values )

  ## fix: add/configure logger for ActiveRecord!!!
  logger = LogUtils::Logger.root


  ## check optional values
  values.each_with_index do |value, index|
    if value =~ /^city:/   ## city:
      value_city_key = value[5..-1]  ## cut off city: prefix
      value_city = City.find_by_key( value_city_key )
      if value_city.present?
        new_attributes[ :city_id ] = value_city.id
      else
        ## todo/fix: add strict mode flag - fail w/ exit 1 in strict mode
        logger.warn "city with key #{value_city_key} missing"
        ## todo: log errors to db log???
      end
    elsif value =~ /^(18|19|20)[0-9]{2}$/  ## assume founding year -- allow 18|19|20
      ## logger.info "  founding/opening year #{value}"
      new_attributes[ :since ] = value.to_i
    elsif value =~ /\/{2}/  # assume it's an address line e.g.  xx // xx
      ## logger.info "  found address line #{value}"
      new_attributes[ :address ] = value
    elsif value =~ /^(?:[a-z]{2}\.)?wikipedia:/  # assume it's wikipedia e.g. [es.]wikipedia:
      logger.info "  found wikipedia line #{value}; skipping for now"
    elsif value =~ /(^www\.)|(\.com$)/  # FIX: !!!! use a better matcher not just www. and .com
      new_attributes[ :web ] = value
    elsif value =~ /^[A-Z][A-Z0-9][A-Z0-9_]?$/   ## assume two or three-letter code e.g. FCB, RBS, etc.
      new_attributes[ :code ] = value
    elsif value =~ /^[a-z]{2,3}$/  ## assume two or three-letter country key e.g. at,de,mx, or eng,sco,wal,nir etc.
      ## fix: if country does NOT match / NOT found - just continue w/ next match!!!!
      #   - just issue an error/warn do NOT crash
      value_country = Country.find_by_key!( value )
      new_attributes[ :country_id ] = value_country.id
    else
      ## todo: assume title2 ??
      # issue warning: unknown type for value
      logger.warn "unknown type for value >#{value}< - key #{new_attributes[:key]}"
    end
  end

  rec = Team.find_by_key( new_attributes[ :key ] )
  if rec.present?
    logger.debug "update Team #{rec.id}-#{rec.key}:"
  else
    logger.debug "create Team:"
    rec = Team.new
  end

  logger.debug new_attributes.to_json

  rec.update_attributes!( new_attributes )

end # create_or_update_from_values


 def self.create_from_ary!( teams, more_values={} )
 teams.each do |values|

   ## key & title required
   attr = {
     key: values[0]
   }

   ## title (split of optional synonyms)
   # e.g. FC Bayern Muenchen|Bayern Muenchen|Bayern
   titles = values[1].split('|')

   attr[ :title ]    =  titles[0]
   ## add optional synonyms
   attr[ :synonyms ] =  titles[1..-1].join('|')  if titles.size > 1


   attr = attr.merge( more_values )

   ## check for optional values
   values[2..-1].each do |value|
     if value.is_a? Country
       attr[ :country_id ] = value.id
     elsif value.is_a? City
       attr[ :city_id ] = value.id
     elsif value =~ /#{TEAM_CODE_PATTERN}/   ## assume its three letter code (e.g. ITA or S04 etc.)
       attr[ :code ] = value
     elsif value =~ /^city:/   ## city:
       value_city_key = value[5..-1]  ## cut off city: prefix
       value_city = City.find_by_key!( value_city_key )
       attr[ :city_id ] = value_city.id
     else
       attr[ :title2 ] = value
     end
   end

   ## check if exists
   team = Team.find_by_key( values[0] )
   if team.present?
     puts "*** warning team with key '#{values[0]}' exists; skipping create"
   else
     Team.create!( attr )
   end
 end # each team
end
