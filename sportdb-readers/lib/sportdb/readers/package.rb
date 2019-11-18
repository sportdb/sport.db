require 'pp'



class Package
  attr_reader :name, :path

  ################################
  ## builder-style overloading of new for convenience

  def self.open( path )
    if !File.exist?( path )  ## file or directory
      puts "** !!! ERROR !!! file NOT found >#{path}<; cannot open package"
      exit 1
    end

    if File.extname( path ) == '.zip' &&   # note: includes dot (.) eg .zip
       File.file?( path )
      ZipPackage.new( path )
    elsif File.directory?( path )
      DirPackage.new( path )
    else
      puts "** !!! ERROR !!! cannot open package - directory or file with .zip extension required"
      exit 1
    end
  end

  def self.create( path )
    open( path )
  end

  class << self
    alias_method :old_new, :new           # note: store "old" orginal version of new
    alias_method :new,     :create        #   replace original version with build_class
  end
end


class DirPackage < Package

  def initialize( path )
    @path = path

    basename = File.basename( path )   ## note: ALWAYS keeps "extension"-like name if present (e.g. ./austria.zip => austria.zip)
    @name = basename
  end

  def self.new( *new_args )
    old_new( *new_args )
  end
end


class ZipPackage < Package

  def initialize( path )
    @path = path

    extname  = File.extname( path )    ## todo/check: double check if extension is .zip - why? why not?
    basename = File.basename( path, extname )
    @name = basename
  end

  def self.new( *new_args )
    old_new( *new_args )
  end
end


pack1  = Package.new( 'austria.zip' )
pack2a = Package.new( 'austria' )
pack2b = Package.new( './austria/' )
pack3  = ZipPackage.new( './england.zip' )

pp pack1.class
pp pack1

pp pack2a.class
pp pack2a
pp pack2b.class
pp pack2b

pp pack3.class
pp pack3
