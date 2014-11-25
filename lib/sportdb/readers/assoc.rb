# encoding: UTF-8

module SportDb


class AssocReader

  include LogUtils::Logging

## make models available by default with namespace
#  e.g. lets you use Usage instead of Model::Usage
  include Models


  def self.from_zip( zip_file, entry_path, more_attribs={} )
    ## get text content from zip
    entry = zip_file.find_entry( entry_path )

    text = entry.get_input_stream().read()
    text = text.force_encoding( Encoding::UTF_8 )

    self.from_string( text, more_attribs )
  end

  def self.from_file( path, more_attribs={} )
    ## note: assume/enfore utf-8 encoding (with or without BOM - byte order mark)
    ## - see textutils/utils.rb
    text = File.read_utf8( path )
    self.from_string( text, more_attribs )
  end

  def self.from_string( text, more_attribs={} )
    AssocReader.new( text, more_attribs )
  end  


  def initialize( text, more_attribs={} )
    ## todo/fix: how to add opts={} ???
    @text = text
    @more_attribs = more_attribs
  end


  def read()
    reader = ValuesReader.from_string( @text, @more_attribs )

    reader.each_line do |new_attributes, values|
      Assoc.create_or_update_from_values( new_attributes, values )
    end # each lines
  end


end # class AssocReader
end # module SportDb
