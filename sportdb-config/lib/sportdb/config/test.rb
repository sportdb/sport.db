## add test data_dir config - move out of import

class Test    ## todo/check: works with module too? use a module - why? why not?
  def self.data_dir() @data_dir ||= './datasets'; end
  def self.data_dir=( path ) @data_dir = path; end
end


pp Test.data_dir
Test.data_dir= './dl'
pp Test.data_dir
