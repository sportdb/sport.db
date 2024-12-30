
module Fifa
  MAJOR = 2024    ## todo: namespace inside version or something - why? why not??
  MINOR = 10
  PATCH = 17
  VERSION = [MAJOR,MINOR,PATCH].join('.')

  def self.version
    VERSION
  end

  def self.banner
    "fifa/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}] in (#{root})"
  end

  def self.root
    File.expand_path( File.dirname(File.dirname(File.dirname(__FILE__))) )
  end

  def self.data_dir  ## rename to config_dir - why? why not?
    "#{root}/config"
  end
end   # module Fifa
