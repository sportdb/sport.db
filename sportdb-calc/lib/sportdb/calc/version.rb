# encoding: utf-8

module SportDb
  module Module
  module Calc
    MAJOR = 0
    MINOR = 1
    PATCH = 0
    VERSION = [MAJOR,MINOR,PATCH].join('.')

    def self.version
      VERSION
    end

    def self.banner
      "sportdb-calc/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
    end

    def self.root
      File.expand_path( File.dirname(File.dirname(File.dirname(__FILE__))) )
    end

  end  # module Calc
  end  # module Module

end  # module SportDb
