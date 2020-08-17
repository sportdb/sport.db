# encoding: utf-8


module SeasonHelper ## use Helpers why? why not?
  ##############################################
  ### deprecated!!! use new Season class!!!
  ##   this code will get removed!!!!
  ###################################################
end  # module SeasonHelper


module SeasonUtils
  extend SeasonHelper
  ##  lets you use SeasonHelper as "globals" eg.
  ##     SeasonUtils.prev( season ) etc.
end # SeasonUtils
