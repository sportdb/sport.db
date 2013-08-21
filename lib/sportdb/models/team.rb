module SportDb::Models


class Team < ActiveRecord::Base

  has_many :home_games, :class_name => 'Game', :foreign_key => 'team1_id'
  has_many :away_games, :class_name => 'Game', :foreign_key => 'team2_id'

  REGEX_KEY  = /^[a-z]{3,}$/
  REGEX_CODE = /^[A-Z][A-Z0-9][A-Z0-9_]?$/  # must start w/ letter a-z (2 n 3 can be number or underscore _)

  ## todo/fix: must be 3 or more letters (plus allow digits e.g. salzburgii, muenchen1980, etc.) - why? why not??
  validates :key,  :format => { :with => REGEX_KEY,  :message => 'expected three or more lowercase letters a-z' }
  validates :code, :format => { :with => REGEX_CODE, :message => 'expected two or three uppercase letters A-Z (and 0-9_; must start with A-Z)' }, :allow_nil => true

  has_many :event_teams, :class_name => 'EventTeam'  # join table (events+teams)
  has_many :events, :through => :event_teams

  ### fix - how to do it with has_many macro? use finder_sql?
  def games
    Game.where( 'team1_id = ? or team2_id = ?', id, id ).order( 'play_at' ).all
  end
  
  has_many :badges   # Winner, 2nd, Cupsieger, Aufsteiger, Absteiger, etc.

  belongs_to :country, :class_name => 'WorldDb::Models::Country', :foreign_key => 'country_id'
  belongs_to :city,    :class_name => 'WorldDb::Models::City',    :foreign_key => 'city_id'



  def self.create_or_update_from_values( new_attributes, values )

    ## fix: add/configure logger for ActiveRecord!!!
    logger = LogKernel::Logger.root

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
      elsif value =~ /^[A-Z][A-Z0-9][A-Z0-9_]?$/   ## assume two or three-letter code e.g. FCB, RBS, etc.
        new_attributes[ :code ] = value
      elsif value =~ /^[a-z]{2}$/  ## assume two-letter country key e.g. at,de,mx,etc.
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
        elsif value =~ REGEX_CODE   ## assume its three letter code (e.g. ITA or S04 etc.)
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
  
end  # class Team
  

end # module SportDb::Models