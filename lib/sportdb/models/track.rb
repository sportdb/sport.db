module SportDb::Models

class Track < ActiveRecord::Base

  has_many :races

  belongs_to :country, :class_name => 'WorldDb::Models::Country', :foreign_key => 'country_id'

  #####################
  ## convenience helper for text parser/reader

  ### fix: move to event!!! (e.g. scoped by event)

  def self.known_tracks_table
    
    ## build known tracks table w/ synonyms e.g.
    #
    # [[ 'wolfsbrug', [ 'VfL Wolfsburg' ]],
    #  [ 'augsburg',  [ 'FC Augsburg', 'Augi2', 'Augi3' ]],
    #  [ 'stuttgart', [ 'VfB Stuttgart' ]] ]
 
    known_tracks = []
     
    Track.all.each_with_index do |track,index|

      titles = []
      titles << track.title
      titles += track.synonyms.split('|') if track.synonyms.present?
      
      ## NB: sort here by length (largest goes first - best match)
      #  exclude code and key (key should always go last)
      titles = titles.sort { |left,right| right.length <=> left.length }
      
      ## escape for regex plus allow subs for special chars/accents
      titles = titles.map { |title| TextUtils.title_esc_regex( title )  }
       
      known_tracks << [ track.key, titles ]
      
      ### fix:
      ## plain logger
      
      LogUtils::Logger.root.debug "  Track[#{index+1}] #{track.key} >#{titles.join('|')}<"
    end
    
    known_tracks
  end # method known_tracks_table



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