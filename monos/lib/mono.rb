require 'pp'
require 'time'
require 'date'
require 'yaml'
require 'open3'
require 'fileutils'
require 'optparse'


###
# our own code
require 'mono/version' # let version always go first
require 'mono/base'
require 'mono/git/base'
require 'mono/git/sync'
require 'mono/git/status'
require 'mono/git/tool'


puts Mono::Module.banner   # say hello
