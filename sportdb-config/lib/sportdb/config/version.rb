# encoding: utf-8


module SportDb
module Module
module Catalogs

  MAJOR = 1    ## todo: namespace inside version or something - why? why not??
  MINOR = 1
  PATCH = 1
  VERSION = [MAJOR,MINOR,PATCH].join('.')

  def self.version
    VERSION
  end

  ## todo/fix: rename to sportdb-catalogs - why? why not?
  def self.banner
    "sportdb-config/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    File.expand_path( File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))) )
  end

end # module Catalogs
end # module Module
end # module SportDb
