module SportDB

class Template

  def initialize( path )
    @path = path
  end

  def render( binding )
    ## '<>' means omit newline for lines starting with <% and ending in %>
    ERB.new( load_template(), 0, '<>' ).result( binding )
  end

private
  def load_template
    puts " Loading template >#{@path}<..."
    File.read( @path )
  end

end # class Template


class Templater

## make models available in sportdb module by default with namespace
#  e.g. lets you use Team instead of Models::Team 
  include SportDB::Models


  def initialize( logger )
    if logger.nil?
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::INFO
    else
      @logger = logger
    end
  end

  attr_reader :logger

  def run( opts, args )
   
    ## assume active activerecord connection
    ##
     
    args.each do |arg|
      ## name = File.basename( arg, '.*' )
      name = arg
      gen_fixtures( opts.event, name )
    end

  end   # method run


  # make props available for template
  attr_reader :event
  
  def gen_fixtures( event_key, name )

    @event = Event.find_by_key!( event_key )
    
    puts "Event #{@event.key} >#{@event.title}<"

    ## todo: honor -o/--output option ??

    dest = "#{name}.rb"
    
    ## todo: check if path (parent dirs) exits?
    
    source = "#{SportDB.root}/templates/fixtures.rb.erb"

    puts " Merging template #{source} to #{dest}..."

    out = File.new( dest, 'w+' )
    out << Template.new( source ).render( binding )
    out.flush
    out.close
  end
  
end # class Templater
end # module SportDB