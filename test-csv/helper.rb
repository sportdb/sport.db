## note: use the local version of gems
$LOAD_PATH.unshift( File.expand_path( '../date-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../score-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sports/lib' ))


## minitest setup
require 'minitest/autorun'


## our own code
require 'sports'



## let's put test configuration in its own namespace / module
class Test    ## todo/check: works with module too? use a module - why? why not?

  ####
  #  todo/fix:  find a better way to configure shared test datasets - why? why not?
  #    note: use one-up (..) directory for now as default - why? why not?
  def self.data_dir()        @data_dir ||= '../test'; end
  def self.data_dir=( path ) @data_dir = path; end
end


CsvMatchParser = Sports::CsvMatchParser


