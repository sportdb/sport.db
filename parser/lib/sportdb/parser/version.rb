
module SportDb
  module Module
    module Parser
  MAJOR = 0    ## todo: namespace inside version or something - why? why not??
  MINOR = 6
  PATCH = 20
  VERSION = [MAJOR,MINOR,PATCH].join('.')

  def self.version
    VERSION
  end

  def self.banner
    "sportdb-parser/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}] in (#{root})"
  end

  def self.root
    File.expand_path( File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))) )
  end

    end   # module Parser
  end
end
