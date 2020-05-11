
module SportDb

  def self.test_data_path
    "#{root}/test/data"
  end

  def self.read_setup( setup, include_path )
    reader = Reader.new( include_path )
    reader.load_setup( setup )
  end

  def self.read_setup_from_zip( zip_name, setup, include_path, opts={} ) ## todo/check - use a better (shorter) name ??
    reader = ZipReader.new( zip_name, include_path, opts )
    reader.load_setup( setup )
    reader.close
  end

  def self.read_all( include_path )   # convenience helper
    read_setup( 'setups/all', include_path )
  end

  # load built-in (that is, bundled within the gem) named plain text seeds
  # - pass in an array of pairs of event/seed names e.g.
  #   [['at.2012/13', 'at/2012_13/bl'],
  #    ['cl.2012/13', 'cl/2012_13/cl']] etc.

  def self.read( ary, include_path )
    reader = Reader.new( include_path )
    ## todo: check kind_of?( Array ) or kind_of?(String) to support array or string
    ary.each do |name|
      reader.load( name )
    end
  end

  def self.update!
    puts '*** update event fixtures...'
    Updater.new.run
  end


end