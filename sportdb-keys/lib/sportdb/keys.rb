# encoding: utf-8

###
# note: it's an addon to sportdb (get all libs via sportdb)
require 'sportdb'


# our own code

require 'sportdb/keys/version' # let it always go first
require 'sportdb/keys/keys'
require 'sportdb/keys/models'



module SportDb
  module Keys

  def self.banner
    "sportdb-keys/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    "#{File.expand_path( File.dirname( File.dirname(File.dirname(__FILE__))) )}"
  end

  end # module Keys
end # module SportDb


puts SportDb::Keys.banner   # say hello

