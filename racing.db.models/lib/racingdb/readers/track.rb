# encoding: UTF-8

#######
## note: uses SportDb namespace by design (not RacingDb) !!!
##


module SportDb


class TrackReader

  include LogUtils::Logging

## make models available by default with namespace
#  e.g. lets you use Usage instead of Model::Usage
  include Models


  attr_reader :include_path


  def initialize( include_path, opts = {} )
    @include_path = include_path
  end


  def read( name, more_attribs={} )
    reader = ValuesReaderV2.new( name, include_path, more_attribs )

    reader.each_line do |new_attributes, values|
      Track.create_or_update_from_values( new_attributes, values )
    end # each lines
  end



end # class TrackReader
end # module SportDb
