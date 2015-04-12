# encoding: UTF-8

module SportDb


class SeasonReader

  include LogUtils::Logging

## make models available by default with namespace
#  e.g. lets you use Usage instead of Model::Usage
  include Models


  def self.from_zip( zip_file, entry_path )
    ## get text content from zip
    entry = zip_file.find_entry( entry_path )

    text = entry.get_input_stream().read()
    text = text.force_encoding( Encoding::UTF_8 )

    self.from_string( text )
  end

  def self.from_file( path )
    ## note: assume/enfore utf-8 encoding (with or without BOM - byte order mark)
    ## - see textutils/utils.rb
    text = File.read_utf8( path )
    self.from_string( text )
  end

  def self.from_string( text )
    SeasonReader.new( text )
  end  


  def initialize( text )
    ## todo/fix: how to add opts={} ???
    @text = text
  end

  def read
    reader = LineReader.from_string( @text )

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
