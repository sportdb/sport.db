## note: use a different module/namespace
##   for the gem version info e.g. Mono::Module vs Mono

module Mono
  module Module

    MAJOR = 0    ## todo: namespace inside version or something - why? why not??
    MINOR = 1
    PATCH = 1
    VERSION = [MAJOR,MINOR,PATCH].join('.')

    def self.version
      VERSION
    end

    def self.banner
      "monos/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
    end

    def self.root
      File.expand_path( File.dirname(File.dirname(__FILE__) ))
    end

  end # module Module
end # module Mono
