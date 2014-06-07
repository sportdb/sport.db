
module SportDb
  module Model

##################
#  FIX: add ?
#
#   use single table inheritance STI  ????
#    - to mark two dervided classes e.g.
#    - Club           ???   - why? why not?
#    - NationalTeam   ???   - why? why not?


class Team < ActiveRecord::Base

  has_many :home_games, class_name: 'Game', foreign_key: 'team1_id'
  has_many :away_games, class_name: 'Game', foreign_key: 'team2_id'

  ## todo/fix: must be 3 or more letters (plus allow digits e.g. salzburgii, muenchen1980, etc.) - why? why not??
  validates :key,  format: { with: /#{TEAM_KEY_PATTERN}/, message: TEAM_KEY_PATTERN_MESSAGE }
  validates :code, format: { with: /#{TEAM_CODE_PATTERN}/, message: TEAM_CODE_PATTERN_MESSAGE }, allow_nil: true

  has_many :event_teams, class_name: 'EventTeam'  # join table (events+teams)
  has_many :events, :through => :event_teams

  # note: team belongs_to a single (optinal) assoc for now (national assoc may have many assocs)
  belongs_to :assoc

  ### fix!!! - how to do it with has_many macro? use finder_sql?
  ##  finder_sql is depreciated in Rails 4!!!
  #   use -> { where()  } etc.  -- try it if it works
  ##   keep as is! best solution ??
  ##   a discussion here -> https://github.com/rails/rails/issues/9726
  ##   a discussion here (not really helpful) -> http://stackoverflow.com/questions/2125440/activerecord-has-many-where-two-columns-in-table-a-are-primary-keys-in-table-b

  def games
    Game.where( 'team1_id = ? or team2_id = ?', id, id ).order( 'play_at' )
  end

  def upcoming_games
    Game.where( 'team1_id = ? or team2_id = ?', id, id ).where( 'play_at > ?', Time.now ).order( 'play_at' )
  end

  def past_games
    Game.where( 'team1_id = ? or team2_id = ?', id, id ).where( 'play_at < ?', Time.now ).order( 'play_at desc' )
  end


  has_many :badges   # Winner, 2nd, Cupsieger, Aufsteiger, Absteiger, etc.

  belongs_to :country, class_name: 'WorldDb::Model::Country', foreign_key: 'country_id'
  belongs_to :city,    class_name: 'WorldDb::Model::City',    foreign_key: 'city_id'



  def self.create_or_update_from_values( new_attributes, values )

    ## fix: add/configure logger for ActiveRecord!!!
    logger = LogUtils::Logger.root

    assoc_keys = []   # by default no association (e.g. fifa,uefa,etc.)

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
      elsif value =~ /^[a-z]{2}$/  ## assume two-letter country key e.g. at,de,mx,etc.
        ## fix: allow country letter with three e.g. eng,sco,wal,nir, etc. !!!
        ## fix: if country does NOT match / NOT found - just coninue w/ next match!!!!
        #   - just issue an error/warn do NOT crash
        value_country = Country.find_by_key!( value )
        new_attributes[ :country_id ] = value_country.id
      elsif value =~ /^[a-z|]+$/ && values.size == index+1   ## is last entry and looks like a tag list e.g. fifa|uefa or fifa|caf or ocf? 
        logger.info "  trying adding assocs using keys >#{value}<"
        assoc_keys = value.split('|')
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

    unless assoc_keys.empty?
      ## add team to assocs
      assoc_keys.each do |assoc_key|
        assoc = Assoc.find_by_key!( assoc_key )
        logger.debug "  adding team to assoc >#{assoc.title}<"
        ## fix!!!!!: check if already member (do NOT add duplicates)
        assoc.teams << rec
      end
    end

  end # create_or_update_from_values
  
end  # class Team
  

  end # module Model
end # module SportDb
