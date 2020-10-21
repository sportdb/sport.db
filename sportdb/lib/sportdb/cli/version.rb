# encoding: utf-8

# Note: SportDb::VERSION gets used by core, that is, sportdb-models

## todo/fix: yes, rename to SportDbTool
module SportDbCli    # todo/check - rename to SportDbTool or SportDbCommands or SportDbShell ??

  MAJOR = 2 ## todo: namespace inside version or something - why? why not??
  MINOR = 3
  PATCH = 2
  VERSION = [MAJOR,MINOR,PATCH].join('.')

  def self.version
    VERSION
  end

  def self.banner
    "sportdb/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    File.expand_path( File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))) )
  end

end # module SportDbCli
