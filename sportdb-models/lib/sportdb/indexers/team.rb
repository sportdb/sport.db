# encoding: UTF-8

module SportDb


##
#  todo/check:
#     simply add index() method to TeamReader (and remove this class) - why? why not??


class TeamIndexer

  include LogUtils::Logging

## make models available by default with namespace
#  e.g. lets you use Usage instead of Model::Usage
  include Models


  def self.from_file( path, more_attribs={} )
    ## note: assume/enfore utf-8 encoding (with or without BOM - byte order mark)
    ## - see textutils/utils.rb
    text = File.read_utf8( path )
    self.from_string( text, more_attribs )
  end

  def self.from_string( text, more_attribs={} )
    self.new( text, more_attribs )
  end  

  def initialize( text, more_attribs={} )
    ## todo/fix: how to add opts={} ???
    @text = text
    @more_attribs = more_attribs
  end


  def read
    ## return a hash (with all records) e.g.
    ## {"austria"=>
    ##   {:title=>"FK Austria Wien",
    ##    :synonyms=>["Austria Wien", "Austria"],
    ##    :values=>
    ##     ["1911",
    ##      "AUS",
    ##      "www.fk-austria.at",
    ##      "Fischhofgasse 12 // 1100 Wien",
    ##      "city:wien"]},
    ##  "rapid"=>
    ##   {:title=>"SK Rapid Wien",
    ##    :synonyms=>["Rapid Wien", "Rapid"],
    ##    :values=>
    ##     ["1899",
    ##      "RAP",
    ##      "www.skrapid.at",
    ##      "Keisslergasse 3 // 1140 Wien",
    ##      "city:wien"]},
    ##      ...

    reader = ValuesReader.from_string( @text, @more_attribs )

    h = {}

    reader.each_line do |new_attributes, values|
      puts "attribs:"
      pp new_attributes
      
      key = new_attributes.delete( :key )  ## remove key
      
      ## turn synonyms into an array
      synonyms = new_attributes[ :synonyms ]
      if synonyms
        new_attributes[ :synonyms ] = synonyms.split('|')
      end
      
      new_attributes[ :values ] = values
      
      h[ key ] = new_attributes
      
    end # each lines
    
    h ## return hash with all records (indexed by key)
  end


end # class TeamIndexer
end # module SportDb
