
module FootballDb
module Data

  MAJOR = 2024    ## todo: namespace inside version or something - why? why not??
  MINOR = 9
  PATCH = 30
  VERSION = [MAJOR,MINOR,PATCH].join('.')

  def self.version
    VERSION
  end

  def self.banner
    "footballdb-data/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}] in (#{root})"
  end

  def self.root
    File.expand_path( File.dirname(File.dirname(__FILE__)) )
  end

  def self.data_dir  ## rename to config_dir - why? why not?
    "#{root}/data"
  end

end # module Data
end # module FootballDb



puts FootballDb::Data.banner   # say hello