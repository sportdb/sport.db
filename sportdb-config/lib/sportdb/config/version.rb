# encoding: utf-8



module SportDb
module Boot      ## note: use a different module than Config to avoid confusion with Configuration/config etc.!!!!
                 ##   maybe rename later gem itself to sportdb-boot - why? why not?

  MAJOR = 1    ## todo: namespace inside version or something - why? why not??
  MINOR = 0
  PATCH = 2
  VERSION = [MAJOR,MINOR,PATCH].join('.')

  def self.version
    VERSION
  end

  def self.banner
    "sportdb-config/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    File.expand_path( File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))) )
  end

end # module Boot
end # module SportDb
