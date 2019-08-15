# encoding: utf-8


module SportDb
module Countries

  MAJOR = 0    ## todo: namespace inside version or something - why? why not??
  MINOR = 1
  PATCH = 0
  VERSION = [MAJOR,MINOR,PATCH].join('.')

  def self.version
    VERSION
  end

  def self.banner
    "sportdb-countries/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    File.expand_path( File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))) )
  end

  def self.test_data_dir
    "#{root}/test/data"
  end

end # module Countries
end # module SportDb
