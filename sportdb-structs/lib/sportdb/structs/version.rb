
module SportDb
  module Module
    module Structs
  MAJOR = 0    ## todo: namespace inside version or something - why? why not??
  MINOR = 5
  PATCH = 1
  VERSION = [MAJOR,MINOR,PATCH].join('.')

  def self.version
    VERSION
  end

  def self.banner
    "sportdb-structs/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}] in (#{root})"
  end

  def self.root
    File.expand_path( File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))) )
  end

    end   # module Structs
  end
end
