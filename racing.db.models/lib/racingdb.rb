# encoding: utf-8


###
# note:
#   racingdb is a addon for sportdb
#    assumes sportdb gets required


# our own code

require 'racing/version' # let it always go first


require 'sportdb/models/race'
require 'sportdb/models/record'
require 'sportdb/models/run'
require 'sportdb/models/track'


require 'sportdb/utils_record'


require 'sportdb/readers/race'
require 'sportdb/readers/record'
require 'sportdb/readers/race_team'
require 'sportdb/readers/track'





module RacingDb

  def self.banner
    "racingdb/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    "#{File.expand_path( File.dirname(File.dirname(__FILE__)) )}"
  end

end # module RacingDb



puts RacingDb.banner   # say  hello
