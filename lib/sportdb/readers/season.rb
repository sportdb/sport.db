# encoding: UTF-8

module SportDb


class SeasonReader

  include LogUtils::Logging

## make models available by default with namespace
#  e.g. lets you use Usage instead of Model::Usage
  include Models


  attr_reader :include_path


  def initialize( include_path, opts = {} )
    @include_path = include_path
  end


  def read( name, more_attribs={} )
    reader = LineReaderV2.new( name, include_path )

####
## fix!!!!!
##   use Season.create_or_update_from_hash or similar
##   use Season.create_or_update_from_hash_reader?? or similar
#   move parsing code to model

    reader.each_line do |line|

      # for now assume single value
      logger.debug ">#{line}<"

      key = line

      logger.debug "  find season key: #{key}"
      season = Season.find_by_key( key )

      season_attribs = {}

      ## check if it exists
      if season.present?
        logger.debug "update season #{season.id}-#{season.key}:"
      else
        logger.debug "create season:"
        season = Season.new
        season_attribs[ :key ] = key
      end

      season_attribs[ :title ] = key # for now key n title are the same
     
      logger.debug season_attribs.to_json
          
      season.update_attributes!( season_attribs )
    end # each line

  end  # method read


end # class SeasonReader
end # module SportDb
