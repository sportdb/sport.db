module SportDB

class Loader

## make models available in sportdb module by default with namespace
#  e.g. lets you use Team instead of Models::Team 
  include SportDB::Models


  def initialize( logger=nil )
    if logger.nil?
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::INFO
    else
      @logger = logger
    end
  end

  attr_reader :logger


  def run( opts, args )

    args.each do |arg|
      name = arg     # File.basename( arg, '.*' )
      
      if opts.load?
        load_fixtures_builtin( name )
      else
        load_fixtures_with_include_path( name, opts.data_path )
      end
    end
    
  end # method run


  def load_fixtures_with_include_path( name, include_path )  # load from file system
    path = "#{include_path}/#{name}.rb"
 
    puts "*** loading data '#{name}' (#{path})..."

    ## nb: assume/enfore utf-8 encoding (with or without BOM - byte order mark)
    ## - see sportdb/utils.rb
    code = File.read_utf8( path )
    
    load_fixtures_worker( code )
    
    Prop.create!( key: "db.#{fixture_name_to_prop_key(name)}.version", value: "file.rb.#{File.mtime(path).strftime('%Y.%m.%d')}" )
  end
  
  def load_fixtures_builtin( name ) # load from gem (built-in)
    path = "#{SportDB.root}/db/#{name}.rb"
 
    puts "*** loading data '#{name}' (#{path})..."

    code = File.read_utf8( path )
    
    load_fixtures_worker( code )

    ## for builtin fixtures use VERSION of gem

    Prop.create!( key: "db.#{fixture_name_to_prop_key(name)}.version", value: "sport.rb.#{SportDB::VERSION}" )
  end
  

private


  def load_fixtures_worker( code )
    
    self.class_eval( code )

    # NB: same as
    #
    # module SportDB
    #   include SportDB::Models
    #  <code here>
    # end
  end
  
end # class Loader
end # module SportDB
