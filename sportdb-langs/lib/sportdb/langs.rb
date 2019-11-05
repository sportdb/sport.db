# encoding: utf-8


## 3rd party libs/gems
require 'logutils'     ## note: requires (stdlibs) pp, yaml, etc.


###
# our own code
require 'sportdb/langs/version' # let version always go first
require 'sportdb/langs/lang'



module SportDb
  def self.lang
    # todo/fix: find a better way for single instance ??
    #  will get us ruby warning:  instance variable @lang not initialized   => find a better way!!!
    #   just use @lang w/o .nil?  e.g.
    #  @lang =|| Lang.new   why? why not??  or better use @@lang =|| Lang.new  for class variable!!!
     @lang ||= Lang.new
     @lang
  end
end # module SportDb



puts SportDb::Langs.banner   # say hello
