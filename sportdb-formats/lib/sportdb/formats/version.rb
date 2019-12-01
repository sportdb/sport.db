# encoding: utf-8


module SportDb
module Formats

  MAJOR = 0    ## todo: namespace inside version or something - why? why not??
  MINOR = 1
  PATCH = 6
  VERSION = [MAJOR,MINOR,PATCH].join('.')

  def self.version
    VERSION
  end

  def self.banner
    "sportdb-formats/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    File.expand_path( File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))) )
  end

end # module Formats
end # module SportDb
