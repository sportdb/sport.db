## note: use a different module/namespace
##   for the gem version info e.g. MonoCore vs Mono

module MonoCore   ## todo/check: rename to MonoMeta, MonoModule or such - why? why not?

  ## note: move root to its own namespace to avoid
  ##   conflict with Mono.root!!!!
  MAJOR = 0    ## todo: namespace inside version or something - why? why not??
  MINOR = 3
  PATCH = 0
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

end # module MonoCore


##################################
# add a convenience shortcut for now - why? why not?
module Mono
  VERSION = MonoCore::VERSION
end

