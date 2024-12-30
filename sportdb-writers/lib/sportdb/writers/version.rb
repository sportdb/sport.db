
module SportDb
module Module
  module Writers
    MAJOR = 0    ## todo: namespace inside version or something - why? why not??
    MINOR = 4
    PATCH = 1
    VERSION = [MAJOR,MINOR,PATCH].join('.')

    def self.version
      VERSION
    end

    def self.banner
      "sportdb-writers/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}] in (#{root})"
    end

    def self.root
      File.expand_path( File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))) )
    end

  end # module Writers
end # module Module
end # module SportDb