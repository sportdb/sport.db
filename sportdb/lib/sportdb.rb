# encoding: utf-8


require 'sportdb/models'

require 'logutils/activerecord'   ## NOTE: check - add to/include in/move to sportdb/models

## check if already included in datafile gem ??
require 'fetcher'   # for fetching/downloading fixtures via HTTP/HTTPS etc.
require 'datafile'   ## lets us use Datafile::Builder,Datafile etc.

require 'gli'

# our own code

require 'sportdb/cli/version'    # let version always go first
require 'sportdb/cli/opts'
require 'sportdb/cli/main'


module SportDb

  def self.main
    Tool.new.run(ARGV)
  end

end  # module SportDb


#####
# auto-load/require some addons

## puts 'before auto-load (require) sportdb addons'
## puts '  before sportdb/update'
require 'sportdb/update'
## puts '  before sportdb/service'
require 'sportdb/service'
## puts 'after auto-load (require) sportdb addons'


SportDb.main   if __FILE__ == $0
