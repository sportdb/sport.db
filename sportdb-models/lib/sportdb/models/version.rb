# encoding: utf-8

module SportDb
module Module
module Models
  MAJOR = 2
  MINOR = 0
  PATCH = 0
  VERSION = [MAJOR,MINOR,PATCH].join('.')

  def self.version
    VERSION
  end

  def self.banner
    "sportdb-models/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    "#{File.expand_path( File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))) )}"
  end

end  # module Models
end  # module Module

  #################
  ## add convenience shortcuts
  VERSION = Module::Models::VERSION
end  # module SportDb
